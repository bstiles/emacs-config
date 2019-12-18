;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Emacs LOCAL initialization for Brians-MacBook-Pro
;;; - See init-full.org for more documentation
;;;

;;; Title bar color
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . nil))
(add-to-list 'default-frame-alist '(ns-appearance . dark))

(unless noninteractive (message "Loading %s..." load-file-name))

;; These are used to bind hot keys to open the specified files.
;; See key-bindings.el.

(my-make-find-file-fn my-file-org-stiles-technologies-administrative "~/Stiles Technologies/Administrative/stilestech-administrative.org")
(my-global-set-key "C-c o A" 'my-file-org-stiles-technologies-administrative)

(my-make-find-file-fn my-file-org-ccm-time-cards "~/CCM/ccm-time-cards.org")
(my-global-set-key "C-c o C" 'my-file-org-ccm-time-cards)

(my-make-find-file-fn my-file-org-ccm "~/CCM/ccm.org")
(my-global-set-key "C-c o c" 'my-file-org-ccm)

(my-make-find-file-fn my-file-org-ca-guns "~/org-personal/ca-guns.org")
(my-global-set-key "C-c o g" 'my-file-org-ca-guns)

(my-make-find-file-fn my-file-org-irise "~/iRise/irise.org")
(my-global-set-key "C-c o i" 'my-file-org-irise)

(my-make-find-file-fn my-file-org-irise-time-cards "~/iRise/irise-time-cards.org")
(my-global-set-key "C-c o I" 'my-file-org-irise-time-cards)

(my-make-find-file-fn my-file-journal "~/org/journal.org")
(my-global-set-key "C-c o j" 'my-file-journal)

(my-make-find-file-fn my-file-org-smartkable "~/SK/Administrative/smartkable.org")
(my-global-set-key "C-c o k" 'my-file-org-smartkable)

(my-make-find-file-fn my-file-org-smartkable-time-cards "~/SK/Administrative/smartkable-time-cards.org")
(my-global-set-key "C-c o K" 'my-file-org-smartkable-time-cards)

(my-make-find-file-fn my-file-org "~/org")
(my-global-set-key "C-c o O" 'my-file-org)

(my-make-find-file-fn my-file-org-one-ring "~/org/one-ring.org")
(my-global-set-key "C-c o o" 'my-file-org-one-ring)

(my-make-find-file-fn my-file-org-finances "~/org-personal/finances.org")
(my-global-set-key "C-c o p f" 'my-file-org-finances)

(my-make-find-file-fn my-file-org-personal "~/org-personal/personal.org")
(my-global-set-key "C-c o p p" 'my-file-org-personal)

(my-make-find-file-fn my-file-org-shooting "~/org-personal/shooting.org")
(my-global-set-key "C-c o p s" 'my-file-org-shooting)

(my-make-find-file-fn my-file-org-today "~/org-personal/today.org")
(my-global-set-key "C-c o p t" 'my-file-org-today)

(my-make-find-file-fn my-file-org-taxes "~/org-personal/taxes.org")
(my-global-set-key "C-c o p T" 'my-file-org-taxes)

(my-make-find-file-fn my-file-org-stiles-technologies "~/Stiles Technologies/Administrative/stilestech.org")
(my-global-set-key "C-c o s" 'my-file-org-stiles-technologies)

(my-make-find-file-fn my-file-org-stiles-technologies-time-cards "~/Stiles Technologies/Administrative/stilestech-time-cards.org")
(my-global-set-key "C-c o S" 'my-file-org-stiles-technologies-time-cards)

(my-make-find-file-fn my-file-org-work "~/org/work.org")
(my-global-set-key "C-c o w" 'my-file-org-work)
