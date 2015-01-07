;; These are used to bind hot keys to open the specified files.
;; See key-bindings.el.
(if (< (string-to-number emacs-version) 24.4)
    (setq user-emacs-directory "~/.emacs.d"))
(setq my-file-init (expand-file-name "init.el" user-emacs-directory)
      my-file-init-org (expand-file-name "init.org" user-emacs-directory)
      my-file-journal "~/org/journal.org"
      my-file-org "~/org"
      my-file-org-one-ring "~/org/one-ring.org"
      my-file-org-capture "~/org/capture.org"
      my-file-org-personal "~org/personal.org"
      my-file-org-work "~/org/work.org")
(my-make-find-file-fn my-file-init my-file-init)
(my-make-find-file-fn my-file-init-org my-file-init-org)
(my-make-find-file-fn my-file-journal my-file-journal)
(my-make-find-file-fn my-file-org my-file-org)
(my-make-find-file-fn my-file-org-one-ring my-file-org-one-ring)
(my-make-find-file-fn my-file-org-capture my-file-org-capture)
(my-make-find-file-fn my-file-org-personal my-file-org-personal)
(my-make-find-file-fn my-file-org-work my-file-org-work)
