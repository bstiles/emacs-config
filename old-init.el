(unless noninteractive (message "Loading %s..." load-file-name))

(desktop-save-mode 1)
(setq message-log-max 5000)
(prefer-coding-system 'utf-8)
(defun home-relative-file (relative-path)
  (concat (getenv "HOME") "/" relative-path))

(setq my-top 22)
(setq my-left 0); 0
(setq my-width-cols 204); 176 189 174 183 166
(setq my-height-rows 57); 57 52 54 48
(setq my-dock-height 90); 100 0
(setq my-dock-width 30); 30 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;;  BEGIN: Load packages
;;;;

(dolist (dir '(
               aquarium-mode
;               cider
               coffee-mode
               ;; css-mode
               ghc-mod
               grep-buffers
               hlint
               hl-sexp-overrides-bs
               html5-el
               irml-mode
               java-decompile-helper
               ;;plantuml-mode
               moz
               org-extensions
               ))
  (add-to-list 'load-path (expand-file-name (format "lisp/%s/" dir)
                                            user-emacs-directory)))

(if (and (>= (string-to-number emacs-version) 24) (< emacs-major-version 27))
    (package-initialize))

(eval-after-load "rng-loc"
  '(add-to-list 'rng-schema-locating-files
                (expand-file-name "lisp/html5-el/schemas.xml"
                                  user-emacs-directory)))
(require 'coffee-mode)                  ; Needed for js2 for some reason
(require 'whattf-dt)
(require 'jka-compr)
(require 'ange-ftp)
(require 'sql)
(require 'ansi-color)
(require 'grep-buffers)
(require 'cc-mode)
(require 'picture)
(require 'generic-x)
(require 'hl-sexp-overrides-bs)
(require 'clojure-mode)                 ; Needed for bug fix below
(require 'find-file-in-project)
(require 'org)
(require 'irml-mode)
(require 'uniquify)
(require 'org-edn)
(require 'auto-highlight-symbol)
(require 'dabbrev)
(require 'ediff)
(require 'emerge)
(require 'markdown-mode)
(require 'plantuml-mode)
(require 'js)
(require 'locate)
(require 'find-dired)
(require 'browse-url)
(require 'align)

(defalias 'margin-indicator-mode 'fci-mode)

;(auto-complete-config)

;(load-file (home-relative-file "elisp/java-decompile-helper.el"))
(load-library "java-decompile-helper")
;; (load-library "css-mode-simple")

(autoload 'ghc-init "ghc" nil t)
(add-hook 'haskell-mode-hook (lambda () (ghc-init) (flymake-mode)))

;;;;
;;;;  END: Load packages
;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(projectile-global-mode)
(recentf-mode 1)
(with-temp-buffer
  (insert "-*\n-/*")
  (write-file (concat (getenv "TMPDIR") "/.projectile")))

(mapc
 (lambda (hook)
   (add-hook hook 'margin-indicator-mode))
 '(clojure-mode-hook
   emacs-lisp-mode-hook))

(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

(autoload 'enable-paredit-mode "paredit"
  "Minor mode for pseudo-structurally editing Lisp code." t)

(mapc (lambda (mode-symbol)
        (add-hook mode-symbol
                  (lambda ()
                    ;; Cheap way to disable global-hl-line-mode
                    (set (make-local-variable 'face-remapping-alist)
                         '((hl-line :underline "SlateGray")))
                    ;; Add ending dot to symbol pattern
                    ;; (set (make-local-variable 'highlight-symbol-border-pattern)
                    ;;      (if (>= emacs-major-version 22)
                    ;;          '("\\_<" . "[.]?\\_>")
                    ;;        '("\\<" . "[.]?\\>")))
                    (enable-paredit-mode)
                    (hl-sexp-mode 1))))
      '(emacs-lisp-mode-hook
        lisp-mode-hook
        lisp-interaction-mode-hook
        clojure-mode-hook
        ielm-mode-hook))

(add-hook 'clojure-mode-hook
          (lambda ()
            (modify-syntax-entry ?. "_")))
;; (add-hook 'clojure-mode-hook
;;           (lambda ()
;;             (clj-refactor-mode 1)
;;             (cljr-add-keybindings-with-prefix "M-3")))

(mapc (lambda (mode)
        (add-hook mode
                  (lambda ()
                    (margin-indicator-mode))))
      '(coffee-mode-hook
        js2-mode-hook))

;; ==============================================================
;; Look and feel
;; ==============================================================
(setq visible-bell t)

;; (add-to-list 'default-frame-alist `(top . ,my-top))
;; (add-to-list 'default-frame-alist `(left . ,my-left))
;; (add-to-list 'default-frame-alist `(height . ,my-height-rows))
;; (add-to-list 'default-frame-alist `(width . ,my-width-cols))
;; (add-to-list 'default-frame-alist `(tool-bar-lines . nil))


(letrec ((common-defaults '((background-color . "DarkSlateGray")
                            (foreground-color . "Wheat")
                            (cursor-color . "#ff00aa")
                            (mouse-color . "White")))
         (ns-defaults (append common-defaults
                              `((tool-bar-lines . nil)
                                (width . ,my-width-cols)
                                (height . ,my-height-rows)
                                (left . ,my-left)
                                (top . ,my-top))))
         (term-defaults '((background-color . "Gray20")
                            (foreground-color . "Wheat")
                            (cursor-color . "#ff00aa")
                            (mouse-color . "White"))))
  (add-to-list 'window-system-default-frame-alist `(ns . ,ns-defaults))
  (add-to-list 'window-system-default-frame-alist `(x . ,common-defaults))
  (add-to-list 'window-system-default-frame-alist `(w32 . ,common-defaults))
  (add-to-list 'window-system-default-frame-alist `(nil . ,term-defaults)))

;; (if window-system
;;     (progn
;; ;      (setq default-frame-alist `((top . 22) (left . 0) (width . my-width-cols) (height . my-height-rows) (background-color . "DarkSlateGray") (foreground-color . "Wheat") (tool-bar-lines . nil) (cursor-color . "#ff00aa") ))
;; ;      (setq initial-frame-alist '((top . 22) (left . 0) (width . my-width-cols) (height . my-height-rows)))
;;       ;; Colors - set them before fonts are configured
;;       (progn
;;         (add-to-list 'default-frame-alist )
;;         (add-to-list 'default-frame-alist )
;;         (set-cursor-color "#ff00aa")
;;         (set-mouse-color "White"))))

(auto-compression-mode 1)

(defun my-set-colors (prefix)
  (interactive "p")
  (cond
   ((= 1 prefix) (progn
                   (set-background-color "DarkSlateGray")
                   (set-foreground-color "Wheat")))
   ((= 2 prefix) (progn
                   (set-background-color "grey24")
                   (set-foreground-color "Wheat")))
   ((= 3 prefix) (progn
                   (set-background-color "ivory2")
                   (set-foreground-color "navy")))
   ((= 4 prefix) (progn
                   (set-background-color "white")
                   (set-foreground-color "Black")))
   ((= 5 prefix) (progn
                   (set-background-color "grey15")
                   (set-foreground-color "wheat")))))

;; ========================================================
;; Look and feel continued
;; ========================================================
(add-hook 'after-init-hook 'global-company-mode)
(setq line-move-visual nil)
(setq x-select-enable-clipboard t)
(global-font-lock-mode t)
(set 'font-lock-maximum-decoration t)
(setq comint-input-ring-size 500)
(setq next-line-add-newlines nil)               ; Don't extend buffer

(setq-default completion-ignore-case t)         ; Case insensitive tab completion
(setq compilation-window-height 15)
;; Disable the menu-bar in console mode
(menu-bar-mode (if window-system 1 -1))

;; ========================================================
;; CIDER
;; ========================================================

(setq cider-repl-history-file (home-relative-file ".nrepl-history"))

(defun my-nrepl-complete-symbol-or-indent ()
  (interactive)
  (if (save-excursion
        (let ((end (point)))
          (beginning-of-line)
          (string-match "^[[:space:]]*$" (buffer-substring-no-properties (point) end))))
      (indent-for-tab-command)
    ;; 2016-02-07 bstiles: Was complete-symbol.
    (call-interactively #'company-complete)))

;; (eval-after-load "cider-interaction"
;;   '(progn
;;      (defadvice cider-load-buffer
;;          (around my-load-current-buffer-warn (&optional arg))
;;        (interactive "p")
;;        (if (= 4 arg)
;;            ad-do-it
;;          (let ((orig-warn (nrepl-dict-get
;;                            (nrepl-sync-request:eval "*warn-on-reflection*")
;;                            "value")))
;;            (unwind-protect
;;                (progn
;;                  (if (equal "false" orig-warn)
;;                      (nrepl-sync-request:eval "(set! *warn-on-reflection* true)"))
;;                  ad-do-it)
;;              (if (equal "false" orig-warn)
;;                  (nrepl-sync-request:eval
;;                   (format "(set! *warn-on-reflection* %s)" orig-warn))))))
;;        )
;;      (ad-activate 'cider-load-buffer t)))


(add-hook 'cider-repl-mode-hook
          (lambda ()
            (enable-paredit-mode)))

;; ========================================================
;; Ediff
;; ========================================================
(setq ediff-diff-options "-dw")

(defun my-org-visible-in-ediff-prepare ()
  (when (eq major-mode 'org-mode)
    (visible-mode 1)))

(defun my-org-visible-in-ediff-cleanup ()
  (ediff-with-current-buffer ediff-buffer-A
    (when (eq major-mode 'org-mode)
      (visible-mode 0)))
  (ediff-with-current-buffer ediff-buffer-B
    (when (eq major-mode 'org-mode)
      (visible-mode 0)))
  (when ediff-buffer-C
   (ediff-with-current-buffer ediff-buffer-C
     (when (eq major-mode 'org-mode)
       (visible-mode 0)))))

(defun my-org-table-to-gfm-table ()
  (interactive)
  (when (org-at-table-p)
    (save-excursion
      (goto-char (org-table-begin))
      (while (search-forward "-+-" nil t)
        (replace-match "-|-" nil t)))))

(add-hook 'ediff-prepare-buffer-hook
          #'my-org-visible-in-ediff-prepare)
(add-hook 'ediff-cleanup-hook
          #'my-org-visible-in-ediff-cleanup)


;; ========================================================
;; Compilation
;; ========================================================
(defun colorize-compilation-buffer ()
  (toggle-read-only)
  (ansi-color-apply-on-region (point-min) (point-max))
  (toggle-read-only))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

;; ========================================================
;; Shell
;; ========================================================
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; ========================================================
;; Dired
;; ========================================================

(add-hook 'dired-mode-hook
          (lambda ()
            (setq truncate-lines t)
            (dired-omit-mode)))

;; ========================================================
;; Org
;; ========================================================

(defun my-toggle-org-hide-blocks ()
  (interactive)
  (when (boundp 'org-hide-block-overlays)
    (if org-hide-block-overlays
        (org-show-block-all)
      (org-hide-block-all))))

;; 2013-05-13 bstiles: I turned confirmation off altogether. The
;; following code seems to have stopped working as of 8.0.2.
;; (defvar my-org-eval-has-been-blessed nil)
;; (make-variable-buffer-local 'my-org-eval-has-been-blessed)
;; (defun my-org-confirm-babel-evaluate (lang body)
;;   (not my-org-eval-has-been-blessed))
;; (defadvice org-babel-confirm-evaluate (after my-org-confirm-advice
;;                                         activate)
;;   "Capture result of `org-babel-confirm-evaluate' in a buffer
;;   local variable."
;;   (setq my-org-eval-has-been-blessed ad-return-value))

(setq org-babel-sh-command "bash")

;;; 2013-01-04 bstiles: from https://raw.github.com/lambdatronic/org-babel-example/master/org/potter.org
;; Patch ob-clojure to work with cider

;; (declare-function nrepl-send-string-sync "ext:nrepl" (code &optional ns))
;; (eval-after-load 'ob-clojure
;;   '(defun org-babel-execute:clojure (body params)
;;      "Execute a block of Clojure code with Babel."
;;      (let ((expanded (org-babel-expand-body:clojure body params))
;;            result)
;;        (case org-babel-clojure-backend
;;          (cider
;;           (require 'cider)
;;           (let ((result-params (cdr (assoc :result-params params))))
;;             (setq result
;;                   (nrepl-dict-get
;;                    (nrepl-sync-request:eval
;;                     expanded (cider-current-connection) (cider-current-session)
;;                     ;; 2016-01-23 bstiles: Use my-org-babel-ns if
;;                     ;; defined to force execution in a particular
;;                     ;; namespace. Set as a file local variable.
;;                     (if (boundp 'my-org-babel-ns)
;;                         my-org-babel-ns
;;                       nil))
;;                    (if (or (member "output" result-params)
;;                            (member "pp" result-params))
;;                        "out"
;;                      "value")))))
;;          (slime
;;           (require 'slime)
;;           (with-temp-buffer
;;             (insert expanded)
;;             (setq result
;;                   (slime-eval
;;                    `(swank:eval-and-grab-output
;;                      ,(buffer-substring-no-properties (point-min) (point-max)))
;;                    (cdr (assoc :package params)))))))
;;        (org-babel-result-cond (cdr (assoc :result-params params))
;;          result
;;          (condition-case nil (org-babel-script-escape result)
;;            (error result))))))

;; ========================================================
;; Mode associations
;; ========================================================

(setq auto-mode-alist (cons '("\\.md$" . markdown-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.js$" . js2-mode) auto-mode-alist))
;;; (setq auto-mode-alist (cons '("\\.json$" . javascript-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.class$" . java-decompile-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.\\(xml\\|xsl\\|rng\\|x?html\\|pom\\)\\'" . nxml-mode) auto-mode-alist))
;; (setq auto-mode-alist (cons '("\\.css\\'" . css-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.war$" . archive-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.ear$" . archive-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.rar$" . archive-mode) auto-mode-alist))
(add-to-list 'auto-mode-alist '("\\.mf\\'" . java-manifest-generic-mode))
(setq jka-compr-mode-alist-additions (cons '("\\.tar\\.gz'" . tar-mode) jka-compr-mode-alist-additions))
(add-to-list 'auto-mode-alist '("\\.applescript$" . applescript-mode))

(auto-compression-mode 0)
(add-to-list 'jka-compr-compression-info-list
             (vector
              "\\.plist\\'"
              "converting text XML to binary plist"
              (home-relative-file "bin/jka-compr-plutil-wrapper.sh") '("-convert binary1")
              "converting binary plist to text XML"
              (home-relative-file "bin/jka-compr-plutil-wrapper.sh") '("-convert xml1")
              nil nil "bplist"))
(auto-compression-mode 1)

;; ========================================================
;; iRise format handling
;; ========================================================

;; 2010-07-20 bstiles: I couldn't get this to work quite right.  Saving modifications to the
;; archive would save the archive to the tmp location, but the modifications would not
;; make it back to the original file.  Also, I would get an error in emacs after saving.
;; The workaround is cause the irise-zip script to error out when trying to save (zip).
;; This essentially causes the mechanism to be read only.

(defadvice archive-find-type (around find-ibloc-idoc-types)
              "Identify iBlocs and iDocs as zip archives"
              (widen)
              (goto-char (point-min))
              (let (case-fold-search)
                (cond ((looking-at "iRise i\\(Bl\\|D\\)oc....PK") 'zip)
                      (t ad-do-it))))
(ad-activate 'archive-find-type t)
;; (add-hook 'archive-mode-hook
;;           (lambda ()
;;             ))

;; Customized:
;; '(archive-zip-expunge (quote ("/Users/bstiles/bin/irise-zip" "-d" "-q")))
;; '(archive-zip-extract (quote ("/Users/bstiles/bin/irise-unzip" "-qq" "-c")))
;; '(archive-zip-update (quote ("/Users/bstiles/bin/irise-zip" "-q")))
;; '(archive-zip-update-case (quote ("/Users/bstiles/bin/irise-zip" "-q" "-k")))


;; ========================================================
;; Picture Mode
;; ========================================================

; ECB uses "\C-c ." for its map, overriding picture mode's use of that
; key for picture-movement-down
(add-hook 'picture-mode-hook
          (lambda ()
            (define-key picture-mode-map "\C-cv" 'picture-movement-down)))


;; ========================================================
;; Font lock stuff
;; ========================================================

(defvar my-esp-output-expression-face 'my-esp-output-expression-face)
(defface my-esp-output-expression-face
  '((t (:background "SeaGreen")))
  "Font Lock mode face used to highlight links."
  :group 'font-lock-highlighting-faces)
(defvar my-esp-code-start-face 'my-esp-code-start-face)
(defface my-esp-code-start-face
  '((t (:background "LimeGreen" :foreground "White" :weight bold)))
  "Font Lock mode face used to highlight links."
  :group 'font-lock-highlighting-faces)
(defvar my-esp-code-end-face 'my-esp-code-end-face)
(defface my-esp-code-end-face
  '((t (:background "FireBrick" :foreground "White")))
  "Font Lock mode face used to highlight links."
  :group 'font-lock-highlighting-faces)

(copy-face 'font-lock-function-name-face 'my-markdown-italic-face)
(set-face-foreground 'my-markdown-italic-face "cyan1")
(set-face-italic-p 'my-markdown-italic-face t)
(copy-face 'font-lock-function-name-face 'my-markdown-bold-face)
(set-face-foreground 'my-markdown-bold-face "OrangeRed")

(defvar logging-call-face 'logging-call-face)
(defface logging-call-face
  '((((class color) (background light)) (:foreground "Slate Gray"))
    (((class color) (background dark)) (:foreground "Light Slate Gray")))
  "Font Lock mode face logging calls."
  :group 'my-clj-faces)

;;; #_ comments font-locking
;; Code heavily borrowed from Slime.
;; https://github.com/slime/slime/blob/master/contrib/slime-fontifying-fu.el#L186
(defvar my-clojure--log-statement-regexp
  "\\((\\(l/\\|log/\\)?\\(d\\(fatal\\|error\\|warn\\|info\\|debug\\|trace\\)f?\\( +\\[?\\(:\\w+ ?\\)+]?\\)?\\)\\)"
  ;(rx "#_" (* " ") (group-n 1 (not (any " "))))
  "Regexp matching the start of a comment sexp.
The beginning of match-group 1 should be before the sexp to be
marked as a comment.  The end of sexp is found with
`clojure-forward-logical-sexp'.

By default, this only applies to code after the `#_' reader
macro.  In order to also font-lock the `(comment ...)' macro as a
comment, you can set the value to:
    \"#_ *\\\\(?1:[^ ]\\\\)\\\\|\\\\(?1:(comment\\\\_>\\\\)\"")

(defun my-clojure--search-log-statement-internal (limit)
  (when (search-forward-regexp my-clojure--log-statement-regexp limit t)
    (let* ((md (match-data))
           (start (match-beginning 1))
           (state (syntax-ppss start)))
      ;; inside string or comment?
      (if (or (nth 3 state)
              (nth 4 state))
          nil
        (goto-char start)
        (let* ((ks (recent-keys t))
               (len (length ks))
               (last (elt ks (1- len))))
          ;; 2016-04-26 bstiles: This check is a workaround for a bug
          ;; that seems to cause clojure-forward-logical-sexp to get
          ;; into an infinite loop when entering a backslash at the
          ;; end of a string (point is before the final ").
          (if  (or (and (numberp last) (equal last 92))
                   (and (consp last) (eq 'paredit-backslash (cdr last))))
              (forward-char 1)
            (clojure-forward-logical-sexp 1)))
        ;; Data for (match-end 1).
        (setf (elt md 3) (point))
        (set-match-data md)
        t))))

(defun my-clojure--search-log-statement (limit)
  "Find comment macros and set the match data.
Search from point up to LIMIT.  The region that should be
considered a comment is between `(match-beginning 1)'
and `(match-end 1)'."
  (if (< 120 (- (line-end-position) (line-beginning-position)))
      nil
    (let ((result 'retry))
      (while (and (eq result 'retry) (<= (point) limit))
        (condition-case nil
            (setq result (my-clojure--search-log-statement-internal limit))
          (end-of-file (setq result nil))
          (scan-error  (setq result 'retry))))
      result)))

(defun my-additional-lispy-font-lock-keywords ()
  (font-lock-add-keywords
   nil
   '(
                                        ; Log statements
     (my-clojure--search-log-statement 1 logging-call-face prepend)
     ;; ("(\\(\\(l/\\|log/\\)?\\(d\\(fatal\\|error\\|warn\\|info\\|debug\\|trace\\)f?\\( +\\[?\\(:\\w+ ?\\)+]?\\)?\\)\\)"
     ;;  1 font-lock-comment-face prepend)
                                        ; Reminder comments
     ("[;]+[ \t]*\\(FIXME\\|XXX\\|DbC\\|\\?\\?\\?\\)" 1 font-lock-warning-face t)
                                        ; Temporary definitions
     ("\\(\\w*XXX\\w*\\)" 1 font-lock-warning-face t)
                                        ; dbg
     ("\\(my/\\(?:ppdbg\\|dbg[*]?\\|ps\\|pp\\)\\)\\b" 1 font-lock-warning-face t)
                                        ; Brackets
     ("[][(){}]" . font-lock-builtin-face)
                                        ; Metadata
     ("\\(\\^:?\\sw\\(?:\\sw\\|\\s_\\)+\\)" 0 font-lock-builtin-face t)
                                        ; Punctuation, comparisons
     ("\\_<\\([=<>]=?\\) ?\\_>" 1 font-lock-keyword-face)
                                        ; Clojure function reader form
                                        ; Must match ( when using compose-region
     ("\\(#\\)[(\"]" 1 font-lock-builtin-face t)
                                        ; Clojure functior reader form parameter
     ("\\_<\\(%[1-9]?\\)\\_>" 1 font-lock-keyword-face t)
                                        ; Numbers
     ("\\(?:\\s(\\|\\s)\\|\\s-\\|\\s.\\|\\`\\|^\\)\\(-?\\(?:\\(?:0x[a-fA-F0-9]+\\)\\|\\(?:[0-9]+\\(?:[e./][0-9]+\\)?\\)\\)\\)" 1 font-lock-constant-face)
     )
   t))

(mapc
 (lambda (mode)
   (add-hook
    mode
    #'my-additional-lispy-font-lock-keywords))
 '(lisp-mode-hook emacs-lisp-mode-hook clojure-mode-hook))

(mapc
 (lambda (mode)
   (add-hook
    mode
    (lambda ()
      (font-lock-add-keywords
       nil
       '(
         ; Javascript arrow
         ("\\(=>\\)" 1 font-lock-function-name-face t)
         ; XML tags
         ("</?\\([A-Za-z][A-Za-z0-9]*/?\\)" 1 font-lock-builtin-face t)
         ; ESP delimiters
         ("\\(<%\\)" 1 my-esp-code-start-face t)
         ; ESP delimiters
         ("\\(%>\\)" 1 my-esp-code-end-face t)
         ; ESP delimiters
         ("<%=\\([^%]*?\\|[^>]*?\\)$" 1 font-lock-warning-face t)
         ; ESP delimiters
         ("<%=\\(.*?\\)%>" 1 my-esp-output-expression-face t)
         ; Destructive operators
;        ("\\+\\+\\|--\\|[+-|&^~%/*]=" . font-lock-warning-face)
         ("\\+\\+\\|--" . font-lock-warning-face)
         ("\\+=\\|-=\\|~=\\|%=\\|/=\\|*=\\||=\\|&=\\|\\^=" . font-lock-warning-face)
         ; Side-effect free operators
         ("[=!]==\\|[<>!=]=\\|[][(){}<>.,?:+-/*!~%|&^]" . font-lock-builtin-face)
         ; Javascript semicolon
         ("[;]" . font-lock-builtin-face)
         ; Assignment operators
         ("=" . font-lock-warning-face)
         ; Reminder comments
         ("[/#*][ \t]*\\(FIXME\\|XXX\\|DbC\\|\\?\\?\\?\\)" 1 font-lock-warning-face t)
         ; Temporary definitions
         ("\\(\\w*XXX\\w*\\)" 1 font-lock-warning-face t)
         ; DEBUG output statements
         ("\\([$._a-zA-Z0-9]*DEBUG[$._a-zA-Z0-9]*\\)" 1 font-lock-comment-face t)
         ; Javascript functions
         ("\\(\\<\\w+\\)[[:space:]]*=[[:space:]]*function\\>" 1 font-lock-function-name-face t)
         )
       t))))
 '(c-mode-hook java-mode-hook python-mode-hook js-mode-hook))

(font-lock-add-keywords
 'xml-mode
  '(; Highlight the text between these tags in SGML mode.
    ("[<>]" . font-lock-function-name-face)
    ("<.*\\(/\\).*>" 1 font-lock-function-name-face t)
    ("</?\\([^ />]+\\)[^>]*>" 1 font-lock-keyword-face t)
    ("<\\(!--\\)[^>]*>" 1 font-lock-comment-face t)
    ("</?\\(target\\)[^>]*>" 1 font-lock-function-name-face t)
    (" \\([^> =]+\\) *=" 1 font-lock-variable-name-face t)
    ("=[ \t\n]*\\(\"[^\"]+\"\\)" 1 font-lock-string-face t)
    ("<target[^>]*name=\"\\([^\"]*\\)\"[^>]*>" 1 font-lock-function-name-face t)
    ("\\(\${[^}]*}\\)" 1 font-lock-builtin-face t)
    ("\\(<!-- .*\\)$" 1 font-lock-comment-face t)
   )
  t)

(font-lock-add-keywords
 'coffee-mode
  '(
    ;; Temporary definitions
    ("\\(\\w*XXX\\w*\\)" 1 font-lock-warning-face t)
    ;; Temporary definitions
    ("\\(bus[.][A-Z_0-9]+\\)" 1 font-lock-warning-face t)
    ;; Reminder comments
    ("[/#*][ \t]*\\(FIXME\\|XXX\\|DbC\\|\\?\\?\\?\\)" 1 font-lock-warning-face t)
   )
  t)


;; ========================================================
;; Custom modes
;; ========================================================

(define-generic-mode spec-mode
  '(";" "#_")
  '()
  '((":\\(?:variables\\|invariants\\|transition-constraints\\|exceptions\\)"
     . font-lock-function-name-face)
    (":\\w+" . font-lock-keyword-face)
    ("[][()]\\|[.]\\{2\\}" . font-lock-builtin-face))
  '("\\.spec")
  '(paredit-mode)
  "Generic mode for Spec files")

(define-generic-mode drl-generic-mode
  '(?#)
  '("accumulate"
    "action"
    "activation-group"
    "agenda-group"
    "and"
    "attributes"
    "auto-focus"
    "collect"
    "contains"
    "date-effective"
    "date-expires"
    "dialect"
    "duration"
    "enabled"
    "end"
    "eval"
    "excludes"
    "exists"
    "false"
    "forall"
    "from"
    "function"
    "global"
    "import"
    "in"
    "init"
    "matches"
    "memberOf"
    "no-loop"
    "not"
    "null"
    "or"
    "package"
    "query"
    "result"
    "reverse"
    "rule"
    "rule-flow-group"
    "salience"
    "template"
    "then"
    "true"
    "when")
  '(("\\+\\+\\|--" . font-lock-warning-face)
    ("[^=!]\\(=\\)[^=]" 1 font-lock-warning-face)
    ("\\+=\\|-=\\|~=\\|%=\\|/=\\|*=\\||=\\|&=\\|\\^=" . font-lock-warning-face)
    ("[=!]==\\|[<>!=]=\\|[][(){}<>.,;?:+-/*!~%|&^]" . font-lock-builtin-face)
    ("[()]" . font-lock-builtin-face)
    ("\\b\\([A-Z]\\w+Fact\\)" 1 font-lock-function-name-face t)
    ("\\(\\$[A-z_0-9]+\\)" 1 font-lock-variable-name-face t))
  '("\\.drl")
  nil
  "Generic mode for JBoss Rules (Drools) DRL files.")


;; ========================================================
;; Input ring history
;; ========================================================
(add-hook 'inferior-js-mode-hook
          (lambda ()
            (setq comint-input-ring-file-name
                  (home-relative-file ".emacs.d/js-comint.history"))
            (comint-read-input-ring t)))
(add-hook 'kill-buffer-hook
          (lambda ()
            (comint-write-input-ring)))


;; ========================================================
;; SQL mode customizaiton
;; ========================================================

;; 2013-05-22 bstiles: XXX Disabled due to hang that manifested some
;; time after upgrading to 24.3.1. I have no idea what else changed.

;; 2008-02-26 bstiles: followed instructions in sql.el.gz
;; HSQL ---------------------------------------------------
;; (defcustom sql-hsql-program (home-relative-file "bin/hsql")
;;   "*Command to start hsql by HSQLDB."
;;   :type 'file
;;   :group 'SQL)

;; (defcustom sql-hsql-login-params '(database)
;;   "Login parameters to needed to connect to HSQLDB."
;;   :type 'sql-login-params
;;   :group 'SQL)

;; (defcustom sql-hsql-options '()
;;   "*List of additional options for `sql-hsql-program'."
;;   :type '(repeat string)
;;   :group 'SQL)

;; (defun sql-comint-hsql (product options)
;;   "Connect ti HSQLDB in a comint buffer."

;;   ;; Do something with `sql-user', `sql-password',
;;   ;; `sql-database', and `sql-server'.
;;   (let ((params options))
;;     (if (not (string= "" sql-database))
;;         (setq params (append (list sql-database) params)))
;;     (sql-comint product params)))

;; ;;;###autoload
;; (defun sql-hsql (&optional buffer)
;;   "Run hsql by HSQL as an inferior process."
;;   (interactive)
;;   (sql-product-interactive 'hsql buffer))

;; (setq sql-product-alist
;;       (cons '(hsql
;;               :font-lock sql-mode-mysql-font-lock-keywords
;;               :syntax-alist ((?# . "w"))
;;               :sqli-program sql-hsql-program
;;               :sqli-login sql-hsql-login-params
;;               :sqli-options sql-hsql-options
;;               :sqli-comint-func sql-comint-hsql
;;               :sqli-prompt-regexp "^\\(sql\\|raw\\|  \\+\\)> "
;;               :sqli-prompt-length 7)
;;             sql-product-alist))


;; ;; H2 -----------------------------------------------------
;; (defcustom sql-h2-program (home-relative-file "bin/h2")
;;   "*Command to start h2 by H2DB."
;;   :type 'file
;;   :group 'SQL)

;; (defcustom sql-h2-login-params '(database)
;;   "Login parameters to needed to connect to H2DB."
;;   :type 'sql-login-params
;;   :group 'SQL)

;; (defcustom sql-h2-options '()
;;   "*List of additional options for `sql-h2-program'."
;;   :type '(repeat string)
;;   :group 'SQL)

;; (defun sql-comint-h2 (product options)
;;   "Connect ti H2DB in a comint buffer."

;;   ;; Do something with `sql-user', `sql-password',
;;   ;; `sql-database', and `sql-server'.
;;   (let ((params options))
;;     (if (not (string= "" sql-database))
;;         (setq params (append (list "-url" sql-database) params)))
;;     (sql-comint product params)))

;; ;;;###autoload
;; (defun sql-h2 (&optional buffer)
;;   "Run h2 by H2 as an inferior process."
;;   (interactive)
;;   (sql-product-interactive 'h2 buffer))

;; (setq sql-product-alist
;;       (cons '(h2
;;               :font-lock sql-mode-mysql-font-lock-keywords
;;               :syntax-alist ((?# . "w"))
;;               :sqli-program sql-h2-program
;;               :sqli-login sql-h2-login-params
;;               :sqli-options sql-h2-options
;;               :sqli-comint-func sql-comint-h2
;;               :sqli-prompt-regexp "^\\(sql\\|raw\\|  \\+\\)> "
;;               :sqli-prompt-length 4)
;;             sql-product-alist))

;; --------------------------------------------------------
(add-hook 'sql-interactive-mode-hook
          (lambda ()
            (add-hook 'comint-preoutput-filter-functions
                      (lambda (str)
                        (if (not (> (point-max) 10))
                            str
                          (let ((endstring (buffer-substring (- (point-max) 9) (point-max))))
                            (if (and (not (string-match "\n$" endstring))
                                     (string-match "\\(sql\\|raw\\|  \\+\\)> *$" endstring))
                                (concat "\n" str)
                              str)))) nil t)))


;; ========================================================
;; ibuffer
;; ========================================================

(autoload 'ibuffer "ibuffer" "List buffers." t)
(setq ibuffer-show-empty-filter-groups nil)
(setq ibuffer-saved-filter-groups
      (quote (("default"
               ("REPL" (mode . cider-repl-mode))
               ("nREPL messages" (mode . nrepl-messages-mode))
               ("nREPL connections" (mode . nrepl-connections-buffer-mode))
               ("Dired" (mode . dired-mode))
               ("Clojure" (mode . clojure-mode))
               ("ClojureC" (mode . clojurec-mode))
               ("ClojureScript" (mode . clojurescript-mode))
               ("Org" (mode . org-mode))
               ("nXML" (mode . nxml-mode))
               ("Java" (mode . java-mode))
               ("Coffee" (mode . coffee-mode))
               ("Sh" (mode . sh-mode))
               ("Shell" (mode . shell-mode))
               ("Compilation" (mode . compilation-mode))
               ("Manifest" (mode . java-manifest-generic-mode))
               ("Conf" (mode . conf-javaprop-mode))
               ("Text" (mode . text-mode))
               ("Archive" (mode . archive-mode))
               ("Python" (mode . elpy-mode))
               ("Emacs-Lisp" (mode . emacs-lisp-mode))
               ("Custom" (mode . Custom-mode))
               ))))
(add-hook 'ibuffer-mode-hook
          (lambda ()
            (ibuffer-switch-to-saved-filter-groups "default")))


;; ========================================================
;; Expansion
;; ========================================================

;; 2014-01-08 bstiles: http://www.emacswiki.org/emacs/HippieExpand
(defun try-expand-flexible-abbrev (old)
  "Try to complete word using flexible matching.

Flexible matching works by taking the search string and then
interspersing it with a regexp for any character. So, if you try
to do a flexible match for `foo' it will match the word
`findOtherOtter' but also `fixTheBoringOrange' and
`ifthisisboringstopreadingnow'.

The argument OLD has to be nil the first call of this function, and t
for subsequent calls (for further possible completions of the same
string).  It returns t if a new completion is found, nil otherwise."
  (if (not old)
      (progn
	(he-init-string (he-lisp-symbol-beg) (point))
	(if (not (he-string-member he-search-string he-tried-table))
	    (setq he-tried-table (cons he-search-string he-tried-table)))
	(setq he-expand-list
	      (and (not (equal he-search-string ""))
		   (he-flexible-abbrev-collect he-search-string)))))
  (while (and he-expand-list
	      (he-string-member (car he-expand-list) he-tried-table))
    (setq he-expand-list (cdr he-expand-list)))
  (if (null he-expand-list)
      (progn
	(if old (he-reset-string))
	())
      (progn
	(he-substitute-string (car he-expand-list))
	(setq he-expand-list (cdr he-expand-list))
	t)))

(defun he-flexible-abbrev-collect (str)
  "Find and collect all words that flex-matches STR.
See docstring for `try-expand-flexible-abbrev' for information
about what flexible matching means in this context."
  (let ((collection nil)
        (regexp (he-flexible-abbrev-create-regexp str)))
    (save-excursion
      (goto-char (point-min))
      ;; 2014-01-09 bstiles: Add case-fold-search nil.
      (let ((case-fold-search nil))
        (while (search-forward-regexp regexp nil t)
          ;; Is there a better or quicker way than using
          ;; `thing-at-point' here?
          (setq collection (cons (thing-at-point 'word) collection)))))
    collection))

(defun he-flexible-abbrev-create-regexp (str)
  "Generate regexp for flexible matching of STR.
See docstring for `try-expand-flexible-abbrev' for information
about what flexible matching means in this context."
  (concat "\\b" (mapconcat (lambda (x) (concat "\\w*" (list x))) str "")
          "\\w*" "\\b"))

(setq hippie-expand-try-functions-list
      (cons 'try-expand-flexible-abbrev hippie-expand-try-functions-list))


;; ========================================================
;; Custom functions
;; ========================================================

(defun browse-url-chrome-browser (url &optional new-window)
  (interactive (browse-url-interactive-arg "URL: "))
  (start-process (concat "open " url) nil "open" "-a" "Google Chrome" url))

(defun my-open-in-browser ()
  (interactive)
  (let ((docroot "/Users/bstiles/Sites/")
        (baseurl "http://localhost/~bstiles/")
        (path (buffer-file-name (current-buffer))))
    (if (and (not 'disabled) ; Disable
             (string-match (concat docroot "\\(.*\\)") path))
        (browse-url (concat baseurl (match-string 1 path)))
      (browse-url path))))

(defun my-shell-template ()
  "Adds boilerplate to the current buffer suitable for a shell script."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (let ((template-buffer (find-file-noselect (home-relative-file "bin/00_NEW_SCRIPT_TEMPLATE.sh")))
          start
          end)
      (save-excursion
        (set-buffer template-buffer)
        (setq start (point-min) end (point-max)))
      (insert-buffer-substring template-buffer start end)
      (kill-buffer template-buffer))))

(defun my-shell-options-template ()
  "Adds boilerplate options parsing to the current buffer suitable for a shell script."
  (interactive)
  (save-excursion
    (let ((template-buffer (find-file-noselect (home-relative-file "bin/00_SCRIPT_OPTIONS_TEMPLATE.sh")))
          start
          end)
      (save-excursion
        (set-buffer template-buffer)
        (setq start (point-min) end (point-max)))
      (insert-buffer-substring template-buffer start end)
      (kill-buffer template-buffer))))

(defun my-pom-template ()
  "Default POM."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (let ((template-buffer (find-file-noselect (home-relative-file "Development/Runtime/Production/MasterControlProgram/Resources/create-bundle-project/DEFAULT_POM.XML")))
          start
          end)
      (save-excursion
        (set-buffer template-buffer)
        (setq start (point-min) end (point-max)))
      (insert-buffer-substring template-buffer start end)
      (kill-buffer template-buffer))))



(defun my-kill-lines (regexp)
  "Kill lines containing matches for REGEXP.
If a match is split across lines, all the lines it lies in are
deleted.  Applies to lines after point. Prefix with C-u to
prevent appending to the kill buffer."
  (interactive (list (read-from-minibuffer
                      "Kill lines (containing match for regexp): "
                      nil nil nil 'regexp-history nil t)))
  (save-excursion
    (goto-char (point-min))
    (let ((first-blood t))
      (while (and (not (eobp))
                  (re-search-forward regexp nil t))
        (if (and (not current-prefix-arg) (not first-blood))
            (append-next-kill))
        (kill-region (progn (goto-char (match-beginning 0))
                            (beginning-of-line)
                            (point))
                     (progn (forward-line 1) (point)))
        (setq first-blood nil)))))

(defun my-toggle-line-move-visual ()
  "Toggle behavior of up/down arrow key, by visual line vs logical line."
  (interactive)
  (if line-move-visual
      (setq line-move-visual nil)
    (setq line-move-visual t)))

(defun my-show-blocks-in-subtree ()
  (interactive)
  (save-excursion
    (save-restriction
      (org-narrow-to-subtree)
      (point-min)
      (org-block-map (lambda () (org-hide-block-toggle t)))
      (point-min)
      (org-block-map (lambda () (org-hide-block-toggle))))))

(defun my-hide-blocks-in-subtree ()
  (interactive)
  (save-excursion
    (save-restriction
      (org-narrow-to-subtree)
      (point-min)
      (org-block-map (lambda () (org-hide-block-toggle t))))))

(defun my-other-frame-reverse ()
  (interactive)
  (other-frame -1))

(defun my-frame-display-pixel-width ()
  (nth 3 (assoc 'geometry (frame-monitor-attributes))))

(defun my-frame-display-pixel-height ()
  (nth 4 (assoc 'geometry (frame-monitor-attributes))))

(defun my-window-split-rotate (arg)
  "Rotate two split-windows to be vertically or horizontally
arranged. If `arg` is 0, arrange side-by-side, otherwise
top-over-bottom."
  (if (> (length (window-list)) 2)
      (error "Can't toggle with more than 2 windows!")
    (condition-case nil
        (while t
          (windmove-left))
      (error nil))
    (condition-case nil
        (while t
          (windmove-up))
      (error nil))
    (let ((func (if (= 0 arg)
                    #'split-window-horizontally
                  #'split-window-vertically)))
      (delete-other-windows)
      (funcall func)
      (save-selected-window
        (other-window 1)
        (switch-to-buffer (other-buffer))))))

(setq my-window-widths-and-positions
      (list
       (lambda () (list my-width-cols my-left my-top))
       (lambda () (list (/ my-width-cols 2) my-left my-top))
       (lambda () (list (/ my-width-cols 2)
                        (- (frame-pixel-width) my-dock-width)
                        my-top))))
(defun my-toggle-window-width ()
  (interactive)
  (setq my-window-widths-and-positions
        (append (cdr my-window-widths-and-positions)
                (list (car my-window-widths-and-positions))))
  (let ((my-window-spec (funcall (car my-window-widths-and-positions)))
        (my-frame (window-frame (get-buffer-window (current-buffer)))))
    (if (equal my-width-cols (car my-window-spec))
        (my-window-split-rotate 0)
      (message "horiz")
      (my-window-split-rotate 4))
    (set-frame-width my-frame (car my-window-spec))
    (set-frame-position my-frame (car (cdr my-window-spec)) (cadr (cdr my-window-spec)))))

(setq my-window-heights-and-positions
      (list
       (lambda () (list my-height-rows my-left my-top))
       (lambda () (list (/ my-height-rows 2) my-left my-top))
       (lambda () (list (/ my-height-rows 2) my-left (- (my-frame-display-pixel-height)
                                                        (frame-pixel-height)
                                                        my-dock-height)))))
(defun my-toggle-window-height ()
  (interactive)
  (setq my-window-heights-and-positions
        (append (cdr my-window-heights-and-positions)
                (list (car my-window-heights-and-positions))))
  (let ((my-window-spec (funcall (car my-window-heights-and-positions)))
        (my-frame (window-frame (get-buffer-window (current-buffer)))))
    (set-frame-height my-frame (car my-window-spec))
    (set-frame-position my-frame (car (cdr my-window-spec)) (cadr (cdr my-window-spec)))))

(defun my-presentation-frame (prefix)
  (interactive "p")
  (cond
   ((= 1 prefix) (set-face-attribute 'default
                                     (make-frame '((width . 104) (height . 29)))
                                     :height 300))
   ((= 2 prefix) (set-face-attribute 'default
                                     (make-frame '((width . 80) (height . 36)))
                                     :height 240))
   ((= 3 prefix) (set-face-attribute 'default
                                     (make-frame '((width . 80) (height . 44)))
                                     :height 200))))

(defun my-indent-top-level-sexp (arg)
  (interactive "P")
  (save-excursion
    (let ((open-paren-in-column-0-is-defun-start nil))
      (beginning-of-defun)
      (indent-pp-sexp arg))))

(defun my-rgrep-in-project (arg)
  (interactive "P")
  (let ((default-directory (or (ffip-project-root) default-directory)))
    (call-interactively 'rgrep)))


(server-start)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; BEGIN: Bug fixes
;;;;

;;; 2015-09-08 bstiles: It seems a recent change to org-indent.el
;;; stops applying the org-indent face to the
;;; org-indent-boundary-char. So, I removed any customization of the
;;; org-indent face (letting org-hide be used instead for the stars)
;;; and added an appropriate face to org-indent-boundary-char directly
;;; in the code below.
(eval-after-load "org-indent"
  '(defun org-indent-set-line-properties (level indentation &optional heading)
     "Set prefix properties on current line an move to next one.

  LEVEL is the current level of heading.  INDENTATION is the
  expected indentation when wrapping line.

  When optional argument HEADING is non-nil, assume line is at
  a heading.  Moreover, if is is `inlinetask', the first star will
  have `org-warning' face."
     (let* ((stars (if (<= level 1) ""
                     (make-string (* (1- org-indent-indentation-per-level)
                                     (1- level))
                                  ?*)))
            (line
             (cond
              ((and (bound-and-true-p org-inlinetask-show-first-star)
                    (eq heading 'inlinetask))
               (concat org-indent-inlinetask-first-star
                       (org-add-props (substring stars 1) nil 'face 'org-hide)))
              (heading (org-add-props stars nil 'face 'org-hide))
              (t (concat (org-add-props (concat stars (make-string level ?*))
                             nil 'face 'org-indent)
                         (and (> level 0)
                              ;; 2015-09-08 bstiles: Add face to boundary char.
                              (org-add-props
                                  (char-to-string org-indent-boundary-char)
                                  nil 'face 'org-agenda-dimmed-todo-face))))))
            (wrap
             (org-add-props
                 (concat stars
                         (make-string level ?*)
                         (if heading " "
                           (make-string (+ indentation (min level 1)) ?\s)))
                 nil 'face 'org-indent)))
       ;; Add properties down to the next line to indent empty lines.
       (add-text-properties (line-beginning-position) (line-beginning-position 2)
                            `(line-prefix ,line wrap-prefix ,wrap)))
     (forward-line)))

;;; 2015-04-01 bstiles: Cider assumes I'm using themes to set colors
;;; and so doesn't pick up my color changes. Also, it appears that
;;; cider-scale-background-color is called early before I initially
;;; set the background-color to DarkSlateGray.
;; 2016-06-01 bstiles: Disabled workaround (seems to work now)
;; (defadvice my-set-colors (after fix-cider-error-color activate)
;;   (when (fboundp #'cider-scale-background-color)
;;     (setq cider-stacktrace-frames-background-color (cider-scale-background-color))))

(defun comint-carriage-motion (start end)
  "Interpret carriage control characters in the region from START to END.
Translate carriage return/linefeed sequences to linefeeds.
Make single carriage returns delete to the beginning of the line.
Make backspaces delete the previous character."
  (save-excursion
    ;; We used to check the existence of \b and \r at first to avoid
    ;; calling save-match-data and save-restriction.  But, such a
    ;; check is not necessary now because we don't use regexp search
    ;; nor save-restriction.  Note that the buffer is already widen,
    ;; and calling narrow-to-region and widen are not that heavy.
    (goto-char start)
    (let* ((inhibit-field-text-motion t)
	   (inhibit-read-only t)
	   (lbeg (line-beginning-position))
	   delete-end ch)
      ;; If the preceding text is marked as "must-overwrite", record
      ;; it in delete-end.
      (when (and (> start (point-min))
		 (get-text-property (1- start) 'comint-must-overwrite))
	(setq delete-end (point-marker))
	(remove-text-properties lbeg start '(comint-must-overwrite nil)))
      (narrow-to-region lbeg end)
      ;; Handle BS, LF, and CR specially.
      (while (and (skip-chars-forward "^\b\n\r") (not (eobp)))
	(setq ch (following-char))
	(cond ((= ch ?\b)		; CH = BS
	       (delete-char 1)
	       (if (> (point) lbeg)
		   (delete-char -1)))
	      ((= ch ?\n)
	       (when delete-end		; CH = LF
                 ;; 2011-04-02 bstiles: commented to prevent incorrect deletion
                 ;; of lines ending with CRLF
		 ;; (if (< delete-end (point))
		 ;;     (delete-region lbeg delete-end))
		 (set-marker delete-end nil)
		 (setq delete-end nil))
	       (forward-char 1)
	       (setq lbeg (point)))
	      (t			; CH = CR
	       (delete-char 1)
	       (if delete-end
		   (when (< delete-end (point))
		     (delete-region lbeg delete-end)
		     (move-marker delete-end (point)))
		 (setq delete-end (point-marker))))))
      (when delete-end
	(if (< delete-end (point))
	    ;; As there's a text after the last CR, make the current
	    ;; line contain only that text.
	    (delete-region lbeg delete-end)
	  ;; Remember that the process output ends by CR, and thus we
	  ;; must overwrite the contents of the current line next
	  ;; time.
	  (put-text-property lbeg delete-end 'comint-must-overwrite t))
	(set-marker delete-end nil))
      (widen))))

;; Replaces:
;; (defun comint-carriage-motion (start end)
;;   "Interpret carriage control characters in the region from START to END.
;; Translate carriage return/linefeed sequences to linefeeds.
;; Make single carriage returns delete to the beginning of the line.
;; Make backspaces delete the previous character."
;;   (save-excursion
;;     ;; We used to check the existence of \b and \r at first to avoid
;;     ;; calling save-match-data and save-restriction.  But, such a
;;     ;; check is not necessary now because we don't use regexp search
;;     ;; nor save-restriction.  Note that the buffer is already widen,
;;     ;; and calling narrow-to-region and widen are not that heavy.
;;     (goto-char start)
;;     (let* ((inhibit-field-text-motion t)
;;            (inhibit-read-only t)
;;            (lbeg (line-beginning-position))
;;            delete-end ch)
;;       ;; If the preceding text is marked as "must-overwrite", record
;;       ;; it in delete-end.
;;       (when (and (> start (point-min))
;;                  (get-text-property (1- start) 'comint-must-overwrite))
;;         (setq delete-end (point-marker))
;;         (remove-text-properties lbeg start '(comint-must-overwrite nil)))
;;       (narrow-to-region lbeg end)
;;       ;; Handle BS, LF, and CR specially.
;;       (while (and (skip-chars-forward "^\b\n\r") (not (eobp)))
;;         (setq ch (following-char))
;;         (cond ((= ch ?\b)               ; CH = BS
;;                (delete-char 1)
;;                (if (> (point) lbeg)
;;                    (delete-char -1)))
;;               ((= ch ?\n)
;;                (when delete-end         ; CH = LF
;;                  (if (< delete-end (point))
;;                      (delete-region lbeg delete-end))
;;                  (set-marker delete-end nil)
;;                  (setq delete-end nil))
;;                (forward-char 1)
;;                (setq lbeg (point)))
;;               (t                        ; CH = CR
;;                (delete-char 1)
;;                (if delete-end
;;                    (when (< delete-end (point))
;;                      (delete-region lbeg delete-end)
;;                      (move-marker delete-end (point)))
;;                  (setq delete-end (point-marker))))))
;;       (when delete-end
;;         (if (< delete-end (point))
;;             ;; As there's a text after the last CR, make the current
;;             ;; line contain only that text.
;;             (delete-region lbeg delete-end)
;;           ;; Remember that the process output ends by CR, and thus we
;;           ;; must overwrite the contents of the current line next
;;           ;; time.
;;           (put-text-property lbeg delete-end 'comint-must-overwrite t))
;;         (set-marker delete-end nil))
;;       (widen))))

;;; 2014-07-01 bstiles: fixes bug when:
;;; 1. Run test with failures in one jack-in session.
;;; 2. Quit and start a new jack-in session in a different project.
;;; 3. Run tests via C-c ,
;;; 2014-07-25 bstiles: reported fixed
;; (eval-after-load "cider-test"
;;   '(progn
;;        (defadvice cider-test-highlight-problems (around cider-test-bug-fix-1)
;;          (condition-case v ad-do-it
;;            (error nil)))
;;        (ad-activate 'cider-test-highlight-problems t)
;;        (defadvice cider-test-clear-highlights (around cider-test-bug-fix)
;;          (condition-case v ad-do-it
;;            (error nil)))
;;        (ad-activate 'cider-test-clear-highlights t)))

;;;;
;;;; END: Bug fixes
;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; BEGIN: Key bindings
;;;;
(mapc
 (lambda (mode-symbol)
   (add-hook mode-symbol
             (lambda ()
               (local-set-key (kbd "C-c C-c") 'my-open-in-browser))))
 '(nxml-mode-hook
   web-mode-hook))
(add-hook 'paredit-mode-hook
          (lambda ()
            (when (not (equal mode-name "REPL"))
              (local-set-key (kbd "RET") 'paredit-newline))))
(mapc
 (lambda (mode-symbol)
   (add-hook mode-symbol
             (lambda ()
               ;; (local-set-key (kbd "C-c C-d") 'ac-nrepl-popup-doc)
               (local-set-key (kbd "TAB") 'my-nrepl-complete-symbol-or-indent)
                                        ;               (local-set-key (kbd "C-.") 'dabbrev-expand)
               )))
 '(nrepl-interaction-mode-hook
   cider-repl-mode-hook
   cider-mode-hook
   nrepl-mode-hook))

(add-hook 'cider-mode-hook #'eldoc-mode)

(eval-after-load 'cider-ns
  (defun cider-ns-refresh (&optional mode)
    (interactive "P")
    (message "cider-ns-refresh is broken. Use C-c n R")))

;; (add-hook 'js2-mode-hook
;;           (lambda ()
;;             (local-set-key (kbd "C-M-x") 'js-send-last-sexp-and-go)
;;             (local-set-key (kbd "C-c C-b") 'js-send-buffer-and-go)
;;             (local-set-key (kbd "C-c C-r") 'js-send-region)
;;             (local-set-key (kbd "C-c b") 'js-send-buffer)
;;             (local-set-key (kbd "C-c l") 'js-load-file-and-go)
;;             (local-set-key (kbd "C-x C-e") 'js-send-last-sexp)))

;; (when (or (fboundp 'set-transient-map)          ; Emacs 24.4+
;;           (fboundp 'set-temporary-overlay-map)) ; Emacs 24.3
;;   (defun my-ahs-backward-repeat ()
;;     "Repeat ahs-backward on C-c < < ..."
;;     (interactive)
;;     (message "-------")
;;     (ahs-select 'ahs-backward-p)
;;     (message "..........")
;; ;    (ahs-backward)
;;     (let ((fun  (if (fboundp 'set-transient-map)
;;                     #'set-transient-map
;;                   #'set-temporary-overlay-map)))
;;       (funcall fun (let ((map  (make-sparse-keymap)))
;;                      (define-key map "<" 'my-ahs-backward-repeat)
;;                      map))))
;;   (defun my-ahs-forward-repeat ()
;;     "Repeat ahs-forward on C-c > > ..."
;;     (interactive)
;;     (ahs-forward)
;;     (let ((fun  (if (fboundp 'set-transient-map)
;;                     #'set-transient-map
;;                   #'set-temporary-overlay-map)))
;;       (funcall fun (let ((map  (make-sparse-keymap)))
;;                      (define-key map ">" 'my-ahs-forward-repeat)
;;                      map)))))

(add-hook 'auto-highlight-symbol-mode-hook
          (lambda ()
            ;; (local-set-key (kbd "C-c ,") 'ahs-backward)
            ;; (local-set-key (kbd "C-c .") 'ahs-forward)
            (local-set-key (kbd "C-c <") 'ahs-backward)
            (local-set-key (kbd "C-c >") 'ahs-forward)))

(ahs-onekey-edit "M-2 r" beginning-of-defun)
(ahs-onekey-edit "M-2 R" whole-buffer)

(add-hook 'clojure-mode-hook
          (lambda ()
            (auto-highlight-symbol-mode 1)))

(mapc
 (lambda (mode-symbol)
   (add-hook mode-symbol
             (lambda ()
               ;; Reclaim "C-c t" from clojure-mode
               (local-set-key (kbd "C-c t") 'my-toggle-truncate-lines))))
 '(emacs-lisp-mode-hook
   lisp-mode-hook
   lisp-interaction-mode-hook
   clojure-mode-hook
   coffee-mode-hook))
(add-hook 'coffee-mode-hook
          (lambda ()
            (define-key coffee-mode-map (kbd "C-c C-c") 'coffee-compile-buffer)
            (define-key coffee-mode-map (kbd "C-c C-r") 'coffee-compile-region)))
;;;;
;;;; END: Key bindings
;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(message "==================================")
(message "init.el file evaluated to the end!")
(message "==================================")
