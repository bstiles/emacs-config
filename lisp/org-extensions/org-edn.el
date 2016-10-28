;;; org-edn.el --- Represents Org outlines and tables as EDN

;; Copyright (C) 2014 Brian Stiles <bstiles@bstiles.net>

;; Emacs Lisp Archive Entry
;; Filename: org-edn.el
;; Version: 0.0
;; Keywords: org edn
;; Author: Brian Stiles <bstiles@bstiles.net>
;; Maintainer: Brian Stiles <bstiles@bstiles.net>
;; Description: Represents Org outlines and tables as EDN.
;; Compatibility: Emacs24, ???

;; This file is not part of GNU Emacs.

;;; Commentary:

;;; Requirements:

(require 'org)
(require 'ob-core)
(require 'clojure-mode)
(require 'dash)

(defvar org-edn-popup-buffer-name "*org-edn*")

(defun org-edn-make-popup-buffer (name)
  "Create a temporary buffer called NAME."
  (with-current-buffer (get-buffer-create name)
    (kill-all-local-variables)
    (setq buffer-read-only nil)
    (erase-buffer)
    (set-syntax-table clojure-mode-syntax-table)
    (clojure-mode)
    (current-buffer)))

(defun org-edn-ednize-outline (f)
  (-when-let (node (car f))
    (let ((name (first node))
          (tags (second node))
          (props (third node)))
      (list* `(,name ,tags { ,@props })
             (mapcar #'org-edn-ednize-outline (rest f))))))

(defun org-edn-slurp-heading ()
  (list (org-current-level)             ; Level
        (substring-no-properties        ; Heading
         (or (org-get-heading t t) ""))
        (org-get-tags)                  ; Tags
        (reduce (lambda (pvs p)         ; Properties
                  (let ((v (org-entry-get nil p)))
                    (if v
                        (cons p (cons v pvs))
                      pvs)))
                ps
                :initial-value '())))

(defun org-edn-outline-to-edn (&optional root-depth)
  "Convert the Org outline in the current buffer to an EDN forest form.
\(((parent)
  \((child))
  \((sibling)
   \((grandchild))))
 \((second-tree...)))
Each node is (NAME TAG-LIST PROPERTY-MAP)."
  (interactive)
  (setq root-depth (or root-depth 1))
  (when (equal 'org-mode major-mode)
    (let* ((ps (org-buffer-property-keys))
           (entries (org-map-entries #'org-edn-slurp-heading))
           (edn (mapcar
                 #'org-edn-ednize-outline
                 (car
                  (reduce
                   (lambda (coll node)
                     (let* ((forest (first coll))
                            (branches (second coll))
                            (depths (third coll))
                            (last-depth (car depths))
                            (depth (car node))
                            (node (cdr node)))
                       (cond
                        ;; Down or sibling
                        ((or (not last-depth)
                             (<= last-depth depth))
                         (setq branches (cons (list node) branches))
                         (setq depths (cons depth depths)))
                        ;; Up
                        ((> last-depth depth)
                         (let ((branch (list node))
                               (branches* branches))
                           (while (and depths (> (car depths) depth))
                             (setq branch (append branch (list (car branches*))))
                             (setq branches* (cdr branches*))
                             (setq depths (cdr depths)))
                           (setq depths (cons depth depths))
                           (setq branches (list* branch branches*)))))
                       (if (= root-depth depth)
                           (list (cons (car branches) forest) nil nil)
                         (list forest branches depths))))
                   (reverse entries)
                   :initial-value '(nil nil nil))))))
      (if (called-interactively-p)
          (pop-to-buffer
           (with-current-buffer (org-edn-make-popup-buffer org-edn-popup-buffer-name)
             (cl-prettyprint edn)
             (current-buffer)))
        edn))))

(defun org-edn-normalize-property-list (plist)
  (cl-flet ((partition-list (list length)
                            (loop
                             while list
                             collect (subseq list 0 length)
                             do (setf list (nthcdr length list)))))
    (apply #'append
           (mapcar
            (lambda (pair)
              (list (replace-regexp-in-string
                     "[^-a-zA-Z0-9]" "_"
                     (replace-regexp-in-string
                      "[ \t]+" "-"
                      (downcase (car pair))))
                    (downcase (cadr pair))))
            (partition-list plist 2)))))

(defun org-edn-replace-links (table)
  "Replaces Org links in table cells with the contents of the
Babel src-block with a name that matches the link destination."
  (mapcar
   (lambda (row)
     (if (not (sequencep row))
         row
       (mapcar (lambda (cell)
                 (if (not (string-match org-bracket-link-analytic-regexp cell))
                     cell
                   (save-excursion
                     (org-link-search (match-string 3 cell))
                     (-when-let (info (org-babel-get-src-block-info))
                       (cadr info)))))
               row)))
   table))

(defun org-edn-get-table-properties ()
  (save-excursion
    (goto-char (org-table-begin))
    (previous-line)
    (let ((props '()))
      (while (looking-at "^#\\+\\(\\S-+\\):\\s-*\\(\\S-.*\\S-\\)\\s-*$")
        (setq props (append props (list (org-match-string-no-properties 1)
                                        (org-match-string-no-properties 2))))
        ;; 2014-05-17 bstiles: I think this can be problematic
        ;; if we don't also have the org-narrow-to-subtree
        ;; requirement above. We can otherwise get stuck at the
        ;; top of a file.
        (previous-line))
      props)))

(defun org-edn-get-table-spec ()
  "Parses the table around point. Table must be in an Org
subtree."
  (if (not (org-at-table-p))
      (progn
        (message "Can't find table spec!")
        nil)
    (save-excursion
      (save-restriction
        (org-narrow-to-subtree)
        (let ((table-text (buffer-substring-no-properties (org-table-begin)
                                                          (org-table-end)))
              (table (org-table-to-lisp))
              (props (org-edn-get-table-properties))
              parsed-property-list
              spec-props)
          (when (and (org-list-search-forward "\\S-[ \t]+::" nil t)
                     (setq parsed-property-list (org-list-parse-list))
                     (eq 'descriptive (car parsed-property-list)))
            (setq props
                  (append props
                          (car
                           (read-from-string
                            (org-no-properties
                             (org-list-to-generic
                              parsed-property-list
                              (list
                               :splicep t
                               :istart "" :iend "\n"
                               :dstart "(" :dend ")"
                               :dtstart "\"" :dtend "\""
                               :ddstart "\"" :ddend "\""
                               :nobr t))))))))
          (list
           ;; Spec properties
           (org-edn-normalize-property-list props)
           ;; Spec
           (org-edn-replace-links table)))))))

(defun org-edn-next-table (&optional backward)
  "Finds the next table not in a src, example, verbatim, or
clocktable block. If point is currently in a table, that is the
table moved to."
  (when (let ((search (if backward #'re-search-backward #'re-search-forward)))
          (funcall search org-table-any-line-regexp nil t))
    (beginning-of-line 1)
    (if (and (looking-at org-table-line-regexp)
             ;; Exclude tables in src/example/verbatim/clocktable blocks
             (not (org-in-block-p '("src" "example" "verbatim" "clocktable"))))
        t
      (when (org-at-table-p)
        (goto-char (if backward (org-table-begin) (org-table-end))))
      (org-edn-next-table backward))))

(defun org-edn-get-tables-forward ()
  (save-excursion
    (when (org-edn-next-table)
      (let ((spec (org-edn-get-table-spec)))
        (when (org-at-table-p)
          (goto-char (org-table-end)))
        (if (not spec)
            (org-edn-get-tables-forward)
          (cons spec (org-edn-get-tables-forward)))))))

(defun org-edn-ednize-tables (f)
  (when f
    (mapcar
     (lambda (l)
       (let ((props (first l))
             (table (second l)))
         `({ ,@props } ,table)))
     f)))

(defun org-edn-tables-to-edn ()
  "Convert the Org tables in the current buffer to an EDN form.
\((PROPERTY-MAP TABLE) ...)  Each table is a list of tuples or
'hline symbols representing table breaks (the meaning of which is
arbitrary)."
  (interactive)
  (save-excursion
    (save-restriction
      (goto-char (point-min))
      (let ((edn (org-edn-ednize-tables (org-edn-get-tables-forward))))
        (if (called-interactively-p)
            (pop-to-buffer
             (with-current-buffer (org-edn-make-popup-buffer org-edn-popup-buffer-name)
               (cl-prettyprint edn)
               (current-buffer)))
          edn)))))



(provide 'org-edn)
