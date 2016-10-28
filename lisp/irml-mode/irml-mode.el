;;; irml-mode.el --- Highlight mode for IRML

;;; Commentary:

;; This major mode provides basic syntax highlighting for IRML.

;;; Code:

(require 'thingatpt)

(defvar irml-assignee-face 'irml-assignee-face)
(defvar irml-local-ref-face 'irml-local-ref-face)
(defvar irml-global-ref-face 'irml-global-ref-face)
(defvar irml-chan-restrict-ref-face 'irml-chan-restrict-ref-face)
(defvar irml-msg-name-face 'irml-msg-name-face)
(defvar irml-chan-name-face 'irml-chan-name-face)
(defvar irml-component-name-face 'irml-component-name-face)
(defvar irml-call-face 'irml-call-face)
(defvar irml-selector-face 'irml-selector-face)
(defvar irml-dom-face 'irml-dom-face)
(defvar irml-free-variable-face 'irml-free-variable-face)
(defvar irml-aria-role-face 'irml-aria-role-face)
(defvar irml-aria-abstract-role-face 'irml-aria-abstract-role-face)
(defvar irml-aria-property-face 'irml-aria-property-face)
(defvar irml-aria-state-face 'irml-aria-state-face)

(defface irml-assignee-face
  '((t (:slant italic :weight bold))
    "Font Lock mode face used to highlight assignments."
    :group) 'irml-faces)

(defface irml-local-ref-face
  '((((class color) (background light)) (:foreground "Orchid"))
    (((class color) (background dark)) (:foreground "Aquamarine")) 
    "Font Lock mode face used to highlight local refs assignments."
    :group) 'irml-faces)

(defface irml-global-ref-face
  '((((class color) (background light)) (:foreground "Purple"))
    (((class color) (background dark)) (:foreground "SkyBlue")))
  "Font Lock mode face used to highlight global refs."
  :group 'irml-faces)

(defface irml-chan-restrict-ref-face
  '((((class color) (background light)) (:foreground "DarkGreen"))
    (((class color) (background dark)) (:foreground "GreenYellow")))
  "Font Lock mode face used to highlight channel restriction references."
  :group 'irml-faces)

(defface irml-msg-name-face
  '((((class color) (background light)) (:foreground "SeaGreen" :weight bold))
    (((class color) (background dark)) (:foreground "Green" :weight bold)))
  "Font Lock mode face used to highlight message names."
  :group 'irml-faces)

(defface irml-chan-name-face
  '((t :underline t))
  "Font Lock mode face used to highlight channel names."
  :group 'irml-faces)

(defface irml-component-name-face
  '((((class color) (background light)) (:foreground "Goldenrod"))
    (((class color) (background dark)) (:foreground "Gold")))
  "Font Lock mode face used to highlight component names."
  :group 'irml-faces)

(defface irml-call-face
  '((((class color) (background light)) (:foreground "Blue" :weight bold))
    (((class color) (background dark)) (:foreground "White" :weight bold)))
  "Font Lock mode face used to highlight channel names."
  :group 'irml-faces)

(defface irml-selector-face
  '((((class color) (background light)) (:foreground "SaddleBrown" :slant italic))
    (((class color) (background dark)) (:foreground "Peru" :slant italic)))
  "Font Lock mode face used to highlight selectors."
  :group 'irml-faces)

(defface irml-dom-face
  '((((class color) (background light)) (:foreground "SaddleBrown" :slant italic))
    (((class color) (background dark)) (:foreground "Burlywood" :slant italic)))
  "Font Lock mode face used to highlight selectors."
  :group 'irml-faces)

(defface irml-free-variable-face
  '((t :inverse-video t))
  "Font Lock mode face used to highlight free variables."
  :group 'irml-faces)

(defface irml-aria-role-face
  '((((class color) (background light)) (:foreground "DarkTurquoise" :slant italic))
    (((class color) (background dark)) (:foreground "Turquoise" :slant italic)))
  "Font Lock mode face used to highlight ARIA roles."
  :group 'irml-faces)

(defface irml-aria-abstract-role-face
  '((((class color) (background light)) (:foreground "DarkTurquoise" :slant italic :underline t))
    (((class color) (background dark)) (:foreground "Turquoise" :slant italic :underline t)))
  "Font Lock mode face used to highlight abstract ARIA roles."
  :group 'irml-faces)

(defface irml-aria-property-face
  '((t :inherit irml-aria-role-face :slant italic))
  "Font Lock mode face used to highlight ARIA properties."
  :group 'irml-faces)

(defface irml-aria-state-face
  '((t :inherit irml-local-ref-face :slant italic))
  "Font Lock mode face used to highlight ARIA states."
  :group 'irml-faces)

(defvar irml-identifier-regexp "[a-zA-Z][-a-zA-Z0-9]*")
(defvar irml-component-identifier-regexp "[A-Z][-a-zA-Z0-9]*")
(defvar irml-space-regexp "[ \t]")

(defun irml-custom-quote-regexp (quot-start quot-end)
  (let ((qe-first (substring quot-end 0 1))
        (qe-second (when (> (length quot-end) 1)
                     (substring quot-end 1 2))))
    (concat
     ;; match quot-begin, group quoted innards, group alternatives
     (regexp-quote quot-start)
     "\\(\\("
     ;; quoted first char of quot-end is okay
     (format "\\\\%s" (regexp-quote qe-first))
     ;; first char of quot-end is okay if not followed by qe-second
     (when qe-second
       (format "\\|%s[^%s]" (regexp-quote qe-first) (regexp-quote qe-second)))
     ;; anything but first char of quot-end is okay
     (format "\\|[^%s]" (regexp-quote qe-first))
     ;; end groups, match quot-end
     (format "\\)+?\\)%s" (regexp-quote quot-end)))))

(defvar irml-block-keywords
  (regexp-opt
   '("do" "define" "end")
   'symbols))

(defvar irml-keywords
  (regexp-opt
   '("this" "true" "false" "NULL")
   'symbols))

(defvar irml-aria-roles
  (regexp-opt
   '("alert" "alertdialog" "application" "article" "banner" "button"
     "checkbox" "columnheader" "combobox" "complementary" "contentinfo"
     "definition" "dialog" "directory" "document" "form"
     "grid" "gridcell" "group" "heading" "img"
     "link" "list" "listbox" "listitem" "log"
     "main" "marquee" "math" "menu" "menubar" "menuitem"
     "menuitemcheckbox" "menuitemradio"
     "navigation" "note" "option" "presentation" "progressbar"
     "radio" "radiogroup" "region" "row" "rowgroup" "rowheader"
     "scrollbar" "search" "separator" "slider" "spinbutton" "status"
     "tab" "tablist" "tabpanel" "textbox" "timer" "toolbar" "tooltip"
     "tree" "treegrid" "treeitem")
   'symbols))

(defvar irml-aria-abstract-roles
  (regexp-opt
   '("command" "composite" "input" "landmark" "range" "roletype"
     "section" "sectionhead" "select" "structure" "widget" "window")
   'symbols))

(defvar irml-aria-properties
  (regexp-opt
   (mapcar
    (lambda (s)
      (concat "aria-" s))
    '("activedescendant" "atomic" "autocomplete" "controls"
      "describedby" "dropeffect" "flowto" "haspopup"
      "label" "labelledby" "level" "live" "multiline" "multiselectable"
      "orientation" "owns" "posinset" "readonly" "relevant" "required"
      "setsize" "sort" "valuemax" "valuemin" "valuenow" "valuetext"))
   'symbols))

(defvar irml-aria-states
  (regexp-opt
   (mapcar
    (lambda (s)
      (concat "aria-" s))
    '("busy" "checked" "disabled" "expanded" "grabbed" "hidden"
      "invalid" "pressed" "selected"))
   'symbols))

(defun irml-aria-lookup (name)
  (interactive
   (let ((name (substring-no-properties (thing-at-point 'symbol)))
	 (enable-recursive-minibuffers t)
	 val)
     (setq val (completing-read (if name
				    (format "Describe symbol (default %s): " name)
				  "Describe symbol: ")
				obarray 'fboundp t nil nil
				name))
     (list (if (equal val "")
	       name val))))
  (if (string-prefix-p "aria" name t)
      (browse-url (concat "http://www.w3.org/WAI/PF/aria/states_and_properties#" name))
    (browse-url (concat "http://www.w3.org/WAI/PF/aria/roles#" name))))

;;;###autoload
(define-generic-mode 'irml-mode
  '()
  '()
  `(
    (";.*" . font-lock-comment-face)
    ("[=]"                                                                   . font-lock-warning-face)
    ("[(){},.]"                                                              . font-lock-builtin-face)
    (,(format "!%s" irml-identifier-regexp)                                  . irml-msg-name-face)
    (,(format "\\(%s\\)(" irml-identifier-regexp)                            1 irml-call-face)
    (,(format "\\(\\$%s\\)" irml-identifier-regexp)                          1 irml-local-ref-face)
    (,(format "\\(@%s\\)" irml-identifier-regexp)                            1 irml-global-ref-face)
    (,(format "\\([$@]?%s\\)!" irml-identifier-regexp)                       1 irml-chan-name-face append)
    (,(format "\\(\\?%s\\)" irml-identifier-regexp)                          1 irml-chan-restrict-ref-face)
    ("\"[^\"\n\r]*\""                                                        . font-lock-string-face)
    (,irml-keywords                                                          . font-lock-keyword-face)
    (,irml-block-keywords                                                    . font-lock-builtin-face)
    (,irml-aria-roles                                                        . irml-aria-role-face)
    (,irml-aria-abstract-roles                                               . irml-aria-abstract-role-face)
    (,irml-aria-properties                                                   . irml-aria-property-face)
    (,irml-aria-states                                                       . irml-aria-state-face)
    (,(format "%s" irml-component-identifier-regexp)                         . irml-component-name-face)
    (,(irml-custom-quote-regexp "«" "»")                                     0 font-lock-builtin-face t)
    (,(irml-custom-quote-regexp "«" "»")                                     1 irml-selector-face t)
    (,(irml-custom-quote-regexp "<" ">")                                     0 font-lock-builtin-face t)
    (,(irml-custom-quote-regexp "<" ">")                                     1 irml-dom-face t)
    (,(irml-custom-quote-regexp "<[" "]>")                                   0 font-lock-builtin-face t)
    (,(irml-custom-quote-regexp "<[" "]>")                                   1 irml-free-variable-face t)
    (,(format "\\([$@?]?%s\\)%s*=" irml-identifier-regexp irml-space-regexp) 1 irml-assignee-face append)
    )
  '("\\.irml\\'")
  `(,(lambda ()
       (setq mode-name "IRML")
       (modify-syntax-entry ?\( "()")
       (modify-syntax-entry ?\{ "(}")
       (modify-syntax-entry ?! ".")
       (modify-syntax-entry ?| ".")
       (modify-syntax-entry ?= ".")
       (local-set-key (kbd "C-c C-d") 'irml-aria-lookup))))

(provide 'irml-mode)
;;; irml-mode.el ends here
