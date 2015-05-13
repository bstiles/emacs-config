;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Emacs initialization
;;; - See init-full.org for more documentation
;;;

(unless noninteractive (message "Loading %s..." load-file-name))

;;; Config files location
;;; ----------------------------------------------------------------------------
(defvar my-emacs-config-dir (file-name-directory (file-chase-links load-file-name))
  "Directory containing my config files.")
(add-to-list 'load-path my-emacs-config-dir)

;;; Key binding setup
;;; - Use my- variations of `global-set-key' and `define-key' to capture
;;;   my customizations to key bindings.
;;; - Use `my-describe-key-bindings' to view all key bindings I've set.
;;; ----------------------------------------------------------------------------
(defvar my-global-key-bindings '()
  "Stores the global key bindings set with
`my-global-set-key'. These key bindings can be displayed with
`my-describe-key-bindings'.")

(defmacro my-global-set-key (key command)
  "Same as `global-set-key' but adds the definition to
`my-global-key-bindings' for use with
`my-describe-key-bindings'. KEY is passed to `kbd' before being
passed to `global-set-key'."
  (let ((command-desc (if (and (listp command) (eq 'quote (car command)))
                          (cadr command)
                        command)))
    `(progn
       (setq my-global-key-bindings
             (cons '(,key ,command-desc ,load-file-name)
                   (delq nil
                         (mapcar (lambda (x)
                                   (if (equal ,key (car x))
                                       nil
                                     x))
                                 my-global-key-bindings))))
       (global-set-key (kbd ,key) ,command))))

(if (< (string-to-number emacs-version) 24.4)
    (defun my-describe-key-bindings ()
      (interactive)
      (message "Not supported on older Emacsen."))
  (defun my-describe-key-bindings ()
    "List all key bindings set with `my-global-set-key' or
`my-define-key'."
    (interactive)
    (let ((my-key-bindings-help-buffer "*My Key Bindings*"))
      (ignore-errors (kill-buffer my-key-bindings-help-buffer))
      (with-current-buffer (get-buffer-create my-key-bindings-help-buffer)
        (insert "My Key Bindings:\n\n")
        (loop for (key command file) in (sort my-global-key-bindings
                                              (lambda (a b)
                                                (string< (car a) (car b))))
              do (insert (format "%-15s%-40s%s\n" key command
                                 (file-name-base (or file "")))))
        (goto-char (point-min))
        (help-mode)
        (display-buffer (current-buffer) t)))))

;;; Local customization
;;; - Allow each machine to supply machine-specific configuration.
;;; - The machine identifier is set in `my-machine-identifier-file'.
;;; ----------------------------------------------------------------------------
(defvar my-machine-identifier "UNDEFINED"
  "Uniquely identifies the machine on which Emacs is run")

(defvar my-machine-identifier-file "~/.emacs.d/machine-identifier.el"
  "Identifies a file that contains an emacs lisp expression to
set `my-machine-identifier'.")

;;; Defined here since local configs will be where this is typically
;;; used.
(defmacro my-make-find-file-fn (name-sym file-path)
  "Convenience for creating functions meant to be bound to keys
for quick access to commonly used files."
  `(defun ,name-sym ()
     (interactive)
     (find-file ,file-path)))

(if (not (load my-machine-identifier-file t))
    (message "WARN: Machine identifier file not found: %s"
             my-machine-identifier-file)
  (let ((machine (concat "local-config-" my-machine-identifier)))
    (when (not (load machine t))
      (message "WARN: Local init file not found: %s" machine))))

;;; Emacs customization
;;; - Override the custom-file location so Custom doesn't mess with init.el.
;;; ----------------------------------------------------------------------------
(setq custom-file (expand-file-name "emacs-custom.el" my-emacs-config-dir))
(load custom-file)

;;; Minimal/full customization
;;; - Always load the minimal config.
;;; - Only load full config if Emacs is version 24.4 or greater.
;;; ----------------------------------------------------------------------------
(load "init-minimal.el")

;;; Load full config for Emacs 24.4 or newer
;;; ---------------------------------------------------------------------------
(when (>= (string-to-number emacs-version) 24.4)
  ;; Bootstrap `use-package'
  (require 'package)
  (setq package-enable-at-startup nil)
  (package-initialize)
  (unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package))
  (require 'use-package)

  ;; Check how old the package archives are. If older than 2 weeks,
  ;; update them. MELPA is arbitrarily the representative age.
  (let* ((file "~/.emacs.d/elpa/archives/melpa/archive-contents")
         (attrs (or (file-attributes (file-truename file))
                    (file-attributes file))))
    (when (and attrs
               (> (float-time
                   (time-subtract (current-time)
                                  (nth 5 attrs)))
                  (* 2 7 24 60 60.0)))
      (package-refresh-contents)))

  ;; (use-package org :ensure t :pin org)
  (use-package org :ensure t :pin org)
  (use-package org-dotemacs :ensure t :pin marmalade)
  (org-babel-load-file (expand-file-name "init-full.org" my-emacs-config-dir))

;;; XXX 2015-01-06 bstiles: Use remainder of old init.el while
;;; migrating.
  (when (equal "Brians-MacBook-Pro" my-machine-identifier)
    (load "old-init.el")))

(message "-- End init.el evaluatation")
