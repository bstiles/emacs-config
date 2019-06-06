;;; my-plantuml-mode.el --- Highlight mode for PlantUML

;;; Commentary:

;; This major mode provides basic syntax highlighting for PlantUML.

;;; Code:

;; (defvar my-plantuml-keywords
;;   (regexp-opt
;;    '("@startuml" "@enduml")
;;    'symbols))

;; ;;;###autoload
;; (define-generic-mode 'my-plantuml-mode
;;   '(("/'" . "'/") ?\')
;;   '()
;;   `(
;;     ("[][(){}]" . font-lock-builtin-face)
;;     )
;;   '("\\.plantuml\\'")
;;   `(,(lambda ()
;;        (setq mode-name "my-plantuml")
;;        (modify-syntax-entry ?\( "()")
;;        (modify-syntax-entry ?\{ "(}")
;;        (modify-syntax-entry ?! ".")
;;        (modify-syntax-entry ?| "."))))

;; (provide 'my-plantuml-mode)
;; ;;; my-plantuml-mode.el ends here

(defvar my-plantuml-keywords
  '("@startuml" "@enduml"))

(defvar my-plantuml-tab-width 2 "Width of a tab for MY-PLANTUML mode")

(defvar my-plantuml-font-lock-defaults
  `((
     ;; stuff between double quotes
     ("\"\\.\\*\\?" . font-lock-string-face)
     ;; ; : , ; { } =>  @ $ = are all special elements
     (":\\|,\\|;\\|{\\|}\\|<-\\|->" . font-lock-keyword-face)
     ;; ( ,(regexp-opt my-plantuml-keywords 'words) . font-lock-builtin-face)
     )))

(define-derived-mode my-plantuml-mode fundamental-mode "MY-PLANTUML script"
  "MY-PLANTUML mode is a major mode for editing PlantUML files"
  (setq font-lock-defaults my-plantuml-font-lock-defaults)
  
  (when my-plantuml-tab-width
    (setq tab-width my-plantuml-tab-width))
  
  (setq comment-start "/'\\|'")
  (setq comment-end "'/")
  
  (modify-syntax-entry ?# "< b" my-plantuml-mode-syntax-table)
  (modify-syntax-entry ?\n "> b" my-plantuml-mode-syntax-table)
  
  ;; Note that there's no need to manually call `my-plantuml-mode-hook'; `define-derived-mode'
  ;; will define `my-plantuml-mode' to call it properly right before it exits
  )

(provide 'my-plantuml-mode)
