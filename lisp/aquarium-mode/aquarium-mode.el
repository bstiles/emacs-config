(require 'ob)

;; 2013-08-26 bstiles: For some reason, url-retrieve* doesn't behave
;; properly for localhost (maybe any host) when a port is specified.
(defcustom aquarium-url-base
  "http://localhost/3000"
  "Base url of the aquarium endpoints.")

(defcustom aquarium-publish-url-base
  (concat aquarium-url-base "/publish")
  "Base url of the publish endpoint.")

(defcustom aquarium-fsm-url
  (concat aquarium-url-base "/fsm")
  "Url for FSM conversion.")

(defconst aquarium-topic-flash "flash")
(defconst aquarium-topic-behavior "behavior")
(defconst aquarium-topic-css "css")
(defconst aquarium-topic-html "html")
(defconst aquarium-topic-prototype "prototype")
(defconst aquarium-topic-log "log")

(defvar aquarium-topics
  `((?f ,aquarium-topic-flash "Eval raw JavaScript in the REPL.")
    (?b ,aquarium-topic-behavior "Compile behavior and register in the Simulator.")
    (?c ,aquarium-topic-css "Append CSS to the DOM.")
    (?h ,aquarium-topic-html "Attempt to replace raw HTML in the browser.")
    (?p ,aquarium-topic-prototype "Add or replace HTML prototype in the DOM.")
    (?l ,aquarium-topic-log "Write data to the console.")))

(defvar aquarium-content-types
  `((,aquarium-topic-flash . "application/javascript")
    (,aquarium-topic-prototype . "text/html")
    (,aquarium-topic-html . "text/html")
    ("text/html" . "text/html")
    (,aquarium-topic-css . "text/css")
    ("text/css" . "text/css")
    (,aquarium-topic-behavior . "application/json")
    ("json" . "application/json")
    ("application/json" . "application/json")))

(defvar aquarium-help-buffer "*Aquarium Publish Topic Help*")

(defun aquarium-publish-topic-help (arg)
  (ignore-errors (kill-buffer aquarium-help-buffer))
  (with-current-buffer (get-buffer-create aquarium-help-buffer)
    (insert "Topics:\n\n")
    (loop for (ch topic help) in aquarium-topics
          do (insert (format "%c:\t%-15s%s\n" ch topic help)))
    (goto-char (point-min))
    (help-mode)
    (display-buffer (current-buffer) t))
  (aquarium-publish-thing-at-point arg)
  (current-buffer))

(defun aquarium-source-url (extension)
  (save-excursion
    (let ((url (concat (org-no-properties (org-get-heading))
                       extension)))
      (while (org-up-heading-safe)
        (setq url (concat (org-no-properties (org-get-heading))
                          "::"
                          url)))
      ;;(url-hexify-string url url-path-allowed-chars)
      url)))

(defun aquarium-publish (topic content-type body &optional query-string)
  (let ((url-request-method "POST")
        (url-request-extra-headers `(("Content-Type" . ,(concat
                                                         content-type
                                                         "; charset=utf-8"))))
        (url-request-data (encode-coding-string body 'utf-8))
        (url (format "%s/%s%s" aquarium-publish-url-base topic
                     (or query-string ""))))
    (url-retrieve-synchronously url))
  (message "Published to %s%s: %s: %s" topic (or query-string "") content-type body))

(defun aquarium-get-src-blocks (language &optional tag)
  (let ((blocks nil))
    (org-babel-map-src-blocks nil
      (when (equal lang language)
        (let* ((info (org-babel-get-src-block-info))
               (name (nth-value 4 info)))
          (when (or (not tag)
                    (assoc tag (caddr info)))
            (setq blocks (cons `(,name . ,(cadr (aquarium-get-block))) blocks))))))
    (reverse blocks)))

(defun aquarium-flash (broadcast)
  (let* ((model (when (boundp 'aquarium-model) aquarium-model))
         (query-string (when (and (not broadcast) model)
                         (format "?model=%s" (url-hexify-string model)))))
    (if (region-active-p)
        (let ((region-text (buffer-substring-no-properties (mark) (point))))
          (deactivate-mark)
          (aquarium-publish aquarium-topic-flash "application/javascript"
                            region-text query-string))
      (-when-let (info (org-babel-get-src-block-info))
        (let ((lang (car info))
              (body (concat (org-babel-expand-src-block)
                            "\n// source="
                            (aquarium-source-url ""))))
          (let* ((content-type
                  (or (cdr (assoc aquarium-topic-flash aquarium-content-types))
                      (cdr (assoc lang aquarium-content-types))
                      "text/plain")))
            (aquarium-publish aquarium-topic-flash content-type body
                              query-string)))))))

(defun aquarium-normalize-property-list (plist)
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

(defun aquarium-next-table (&optional backward)
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
      (aquarium-next-table backward))))

(defun aquarium-goto-next-table-forward ()
  (interactive)
  (when (org-at-table-p)
    (goto-char (org-table-end)))
  (aquarium-next-table)
  (org-show-context))

(defun aquarium-goto-next-table-backward ()
  (interactive)
  (when (org-at-table-p)
    (goto-char (org-table-begin)))
  (aquarium-next-table t)
  (org-show-context))

(defun aquarium-goto-src-block-head-cycle-visibility ()
  (interactive)
  (org-babel-goto-src-block-head)
  (org-cycle))

(defvar aquarium-behavior-attribute-regexp
  (concat
   "^#\\+attr_html:\\s-+.*:class +"
   "\\([^:]+?\\)"                       ; data we want
   "\\(:.*\\|\\)$"))

(defun aquarium-replace-links (table)
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
                       (if (not (string-equal (car info) "irml"))
                           (message "Invalid code block: %S" info)
                         (cadr info))))))
               row)))
   table))

(defun aquarium-get-behavior-spec ()
  (if (not (and (org-at-table-p)
                (save-excursion
                  (goto-char (org-table-begin))
                  (previous-line)
                  (looking-at-p aquarium-behavior-attribute-regexp))))
      (progn
        (message "Can't find behavior spec!")
        nil)
    (save-excursion
      (save-restriction
        (org-narrow-to-subtree)
        (let ((table-text (buffer-substring-no-properties (org-table-begin)
                                                          (org-table-end)))
              (table (org-table-to-lisp))
              (name (when (save-excursion
                            (re-search-backward "^#\\+name:\\s-+\\(\\S-+\\)\\s-"
                                                nil t))
                      (org-match-string-no-properties 1)))
              (attr-props (-when-let (args (save-excursion
                                            (when (re-search-backward
                                                   aquarium-behavior-attribute-regexp
                                                   nil t)
                                              (org-match-string-no-properties 1))))
                            (let ((words (s-split "\\s-" args)))
                              (cond
                               ((= (length words) 1)
                                `(("type" . ,(car words))))
                               ((= (length words) 2)
                                `(("type" . ,(car words))
                                  ("format" . ,(cadr words))))))))
              parsed-property-list
              spec-props)
          (when (and (org-list-search-forward "\\S-[ \t]+::" nil t)
                     (setq parsed-property-list (org-list-parse-list))
                     (eq 'descriptive (car parsed-property-list)))
            (setq spec-props (car
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
                                  :nobr t)))))))
          (when name
            (setq spec-props (plist-put spec-props "name" name)))
          (-when-let (val (cdr (assoc "type" attr-props)))
            (setq spec-props (plist-put spec-props "type" val)))
          (-when-let (val (cdr (assoc "format" attr-props)))
            (setq spec-props (plist-put spec-props "format" val)))
          (when spec-props
            (list
             ;; Spec name
             name
             ;; Original table text
             table-text
             ;; Spec properties
             (aquarium-normalize-property-list spec-props)
             ;; Spec
             (aquarium-replace-links table))))))))

(defun aquarium-get-behavior-specs-forward ()
  (save-excursion
    (when (aquarium-next-table)
      (let ((spec (aquarium-get-behavior-spec)))
        (when (org-at-table-p)
          (goto-char (org-table-end)))
        (if (not spec)
            (aquarium-get-behavior-specs-forward)
          (cons spec (aquarium-get-behavior-specs-forward)))))))

(defun aquarium-behavior-spec-to-js (spec)
  (let* ((url-request-method "POST")
         (url-request-extra-headers `(("Content-Type" . "application/edn")
                                      ("Accept" . "application/json")))
         ;; cddr strips the name and table-text from the spec (not
         ;; part of the server's spec)
         (url-request-data (encode-coding-string (pp-to-string (cddr spec)) 'utf-8))
         (url aquarium-fsm-url)
         (buffer (url-retrieve-synchronously url))
         status
         content-type
         response-body)
    (save-excursion
      (set-buffer buffer)
      (goto-char (point-min))
      (re-search-forward "^HTTP/[0-9]\\.[0-9]\\s-+\\([0-9]+\\)\\s-+\\(.*\\)$" nil 'move)
      (setq status (match-string 1))
      (re-search-forward "^Content-Type: \\(.*\\)$" nil 'move)
      (setq content-type (match-string 1))
      (re-search-forward "\r?\n\r?\n" nil 'move)
      (setq response-body (buffer-substring-no-properties (point) (point-max)))
      (kill-buffer (current-buffer)))
    (when (string-match "^2.." status)
      (values content-type response-body))))

(defun aquarium-publish-behavior-specs (specs)
  (mapc
   (lambda (spec)
     (with-temp-buffer
       (point-min)
       (insert (format "#+name: %s\n" (car spec)))
       (insert (cadr spec))
       (mark-whole-buffer)
       (org-html-convert-region-to-html)
       (aquarium-publish aquarium-topic-html "text/html"
                         (buffer-substring-no-properties (point-min) (point-max))))
     (let ((name (car spec))
           (json (cadr (aquarium-behavior-spec-to-js spec)))
           (content-type (cdr (assoc aquarium-topic-behavior aquarium-content-types))))
       (aquarium-publish aquarium-topic-behavior content-type
                         (format "[\"%s\",%s]" name json))))
   specs))

(defun aquarium-behavior (walk-subtree)
  (if walk-subtree
      (save-excursion
        (save-restriction
          (org-narrow-to-subtree)
          (goto-char (point-min))
          (aquarium-publish-behavior-specs
           (aquarium-get-behavior-specs-forward))))
    (-when-let (spec (aquarium-get-behavior-spec))
      (aquarium-publish-behavior-specs (list spec))))
  (aquarium-publish "dispatch" "text/plain" "SYSTEM_RESET"))

(defun aquarium-get-block ()
  (cond
   ;; 2013-08-24 bstiles: This first condition may be superfluous with
   ;; the advent of aquarium-flash.
   ((-when-let (info (org-babel-get-src-block-info))
      (let ((lang (car info)))
        (values lang
                (if (or (string-equal lang "css")
                        (string-equal lang "nxml")
                        (string-equal lang "irml"))
                    (org-babel-execute-src-block nil nil '((:results . "silent")))
                  (org-babel-expand-src-block))
                (nth-value 4 info)))))
   ((save-excursion
      (when (re-search-backward org-babel-result-regexp nil t)
        (values nil (org-babel-read-result) nil))))))

(defun aquarium-prototype (lang &optional walk-subtree)
  (-when-let (template (save-excursion
                        (save-restriction
                          (widen)
                          (when (re-search-forward
                                 (org-babel-named-src-block-regexp-for-name
                                  (concat (if (equal "nxml" lang)
                                              "html"
                                            lang)
                                          "-prototype-template"))
                                 nil t)
                            (org-match-string-no-properties 5)))))
    (aquarium-publish
     aquarium-topic-prototype
     (cdr (assoc aquarium-topic-prototype aquarium-content-types))
     (save-excursion
       (save-restriction
         (if walk-subtree
             (org-narrow-to-subtree)
           (org-narrow-to-element))
         (goto-char (point-min))
         (apply #'concat
                (mapcar (lambda (block)
                          (let ((name (car block))
                                (body (cdr block)))
                            (format template name body)))
                        (aquarium-get-src-blocks lang :prototype))))))
    (aquarium-publish "dispatch" "text/plain" "SYSTEM_RESET")))

(defun aquarium-publish-thing-at-point (arg)
  (interactive "p")
  (message "Topic [?%s]: "
           (mapconcat (lambda (x) (char-to-string (car x))) aquarium-topics ""))
  (let* ((ch (save-window-excursion
               (select-window (minibuffer-window))
               (read-char))))
    (cond
     ((equal ch ??) (aquarium-publish-topic-help arg))
     ((equal aquarium-topic-flash (cadr (assoc ch aquarium-topics)))
      (progn
        (aquarium-flash (= 4 arg))
        (ignore-errors (kill-buffer aquarium-help-buffer))))
     ((equal aquarium-topic-behavior (cadr (assoc ch aquarium-topics)))
      (progn
        (aquarium-behavior (= 4 arg))
        (ignore-errors (kill-buffer aquarium-help-buffer))))
     ((equal aquarium-topic-prototype (cadr (assoc ch aquarium-topics)))
      (progn
        (aquarium-prototype "css" (= 4 arg))
        (aquarium-prototype "nxml" (= 4 arg))
        (ignore-errors (kill-buffer aquarium-help-buffer))))
     ((assoc ch aquarium-topics)
      (destructuring-bind (lang body name) (aquarium-get-block)
        (when body
          (let* ((topic (cdr (assoc ch aquarium-topics)))
                 (content-type (or (cdr (assoc topic aquarium-content-types))
                                   (cdr (assoc lang aquarium-content-types))
                                   "text/plain")))
            (aquarium-publish topic content-type body)
            (ignore-errors (kill-buffer aquarium-help-buffer))))))
     (t
      (message "No method for character: ?\\%c" ch)
      (ding)
      (sleep-for 1)
      (discard-input)
      (aquarium-publish-thing-at-point arg)))))

(define-minor-mode aquarium-mode
  "Mode for experimentation using Org-mode in Aquarium development."
  nil
  "/aquarium"
  `((,(kbd "C-c p") . aquarium-publish-thing-at-point)
    (,(kbd "C-M-}") . aquarium-goto-next-table-forward)
    (,(kbd "C-M-{") . aquarium-goto-next-table-backward)
    (,(kbd "C-c C-v U") . aquarium-goto-src-block-head-cycle-visibility)))

(defadvice org-babel-tangle (after do-nrepl-reset)
  "Run user/reset via nREPL after tangling is done."
  ;(my-cider-reset)
  ;; (if (not (get-buffer (nrepl-current-connection-buffer)))
  ;;     (message "No active nREPL connection.")
  ;;   (set-buffer (nrepl-find-or-create-repl-buffer))
  ;;   (goto-char (point-max))
  ;;   (insert "(script/reset)")
  ;;   (nrepl-return))
  )
(ad-activate 'org-babel-tangle t)
