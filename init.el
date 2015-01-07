(unless noninteractive
  (message "Loading %s..." load-file-name))

(setq my-emacs-config-dir "~/.emacs.d/emacs-config")
(add-to-list 'load-path my-emacs-config-dir)

;; Local customization
(load "local-config")

(if (< (string-to-number emacs-version) 24.4)
    ;; We're on an old emacs, only load minimal config
    (load "init-minimal.el")

  ;; Load full config
  ;; ---------------------------------------------------------------------------

  ;; Emacs customization
  (setq custom-file (expand-file-name "emacs-custom.el" my-emacs-config-dir))
  (load custom-file)

  ;; Bootstrap `use-package'
  (require 'package)
  (setq package-enable-at-startup nil)
  (package-initialize)
  (unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package))
  (require 'use-package)

  ;; (use-package org :ensure t :pin org)
  (use-package org-plus-contrib :ensure t :pin org)
  (use-package org-dotemacs :ensure t :pin marmalade)
  (org-babel-load-file (expand-file-name "init-full.org" my-emacs-config-dir))

;;; XXX 2015-01-06 bstiles: Use remainder of old init.el while
;;; migrating.
  ;; (load "old-init.el")
  )

(message "========================\nEnd init.el evaluatation\n========================")
