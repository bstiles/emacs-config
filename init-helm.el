(require 'helm)
(require 'helm-buffers)
(require 'helm-plugin)
(require 'helm-projectile)

;; 2013-09-05 bstiles: These are patterned after helm-org.el
(defvar my-helm-source-org-headlines
  `((name . "Org Headline")
    (headline
     ,@(mapcar
        (lambda (num)
          (format "^\\*\\{%d\\}\\( \\([^[:space:]]+[ ][^[:space:]]+\\|[^[:space:]]+\\|\\{1,12\\}\\|.+?\\)\\).*\\([ \t]+:[a-zA-Z0-9_@:]+:\\)?[ \t]*$"
                  num))
        (number-sequence 1 8)))
    (condition . (eq major-mode 'org-mode))
    (migemo)
    (subexp . 1)
    (persistent-action . (lambda (elm)
                           (helm-action-line-goto elm)
                           (org-cycle)))
    (action-transformer
     . (lambda (actions candidate)
         '(("Go to line" . helm-action-line-goto)))))
  "Show Org headlines.")

(defvar my-helm-source-org-named-blocks
  `((name . "Org Named Blocks")
    (headline "^#\\+name:\\(.*\\)$")
    (condition . (eq major-mode 'org-mode))
    (migemo)
    (subexp . 1)
    (persistent-action . (lambda (elm)
                           (helm-action-line-goto elm)
                           (org-cycle)))
    (action-transformer
     . (lambda (actions candidate)
         '(("Go to line" . helm-action-line-goto)))))
  "Show Org Block Names.")

(defun my-helm-org-headlines ()
  "Preconfigured `helm' for org headlines."
  (interactive)
  (helm-other-buffer 'my-helm-source-org-headlines "*org headlines*"))

(defun my-helm-org-named-blocks ()
  "Preconfigured `helm' for org named blocks."
  (interactive)
  (helm-other-buffer 'my-helm-source-org-named-blocks "*org named blocks*"))

(provide 'my-helm-projectile)

;; (require 'helm-ls-git)

;; (defun my-helm-ls-git-ls ()
;;   (interactive)
;;   (helm :sources '(helm-source-ls-git-status
;;                    helm-source-ls-git
;;                    ;; 2013-10-08 bstiles: added buffers list
;;                    helm-source-buffers-list)
;;         ;; When `helm-ls-git-ls' is called from lisp
;;         ;; `default-directory' is normally let-bounded,
;;         ;; to some other value;
;;         ;; we now set this new let-bounded value local
;;         ;; to `helm-default-directory'.
;;         :default-directory default-directory
;;         :buffer "*helm lsgit*"))
