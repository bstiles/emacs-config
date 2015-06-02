;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Emacs LOCAL initialization for Brians-MacBook-Pro
;;; - See init-full.org for more documentation
;;;

(unless noninteractive (message "Loading %s..." load-file-name))

;; These are used to bind hot keys to open the specified files.
;; See key-bindings.el.
(my-make-find-file-fn my-file-org-capture "~/org/capture.org")
(my-global-set-key "C-c o c" 'my-file-org-capture)

(my-make-find-file-fn my-file-journal "~/org/journal.org")
(my-global-set-key "C-c o j" 'my-file-journal)

(my-make-find-file-fn my-file-org "~/org")
(my-global-set-key "C-c o O" 'my-file-org)

(my-make-find-file-fn my-file-org-one-ring "~/org/one-ring.org")
(my-global-set-key "C-c o o" 'my-file-org-one-ring)

(my-make-find-file-fn my-file-org-personal "~/org-personal/personal.org")
(my-global-set-key "C-c o p" 'my-file-org-personal)

(my-make-find-file-fn my-file-org-work "~/org/work.org")
(my-global-set-key "C-c o w" 'my-file-org-work)
