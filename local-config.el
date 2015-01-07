(require 'globals)
;;; my-machine-identifier-file sets my-machine-identifier.
(if (not (load my-machine-identifier-file t))
    (message "WARN: Machine identifier file not found: %s"
             my-machine-identifier-file)
  (let ((machine (concat "local-config-" my-machine-identifier)))
    (when (not (load machine t))
      (message "WARN: Local init file not found: %s" machine))))
