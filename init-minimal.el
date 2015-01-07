;;; Convenience functions
;;; ----------------------------------------------------------------------------
(defmacro my-make-goto-buffer-fn (name-sym buffer-name)
  `(defun ,name-sym ()
     (interactive)
     (if (get-buffer ,buffer-name)
         (switch-to-buffer ,buffer-name)
       (message (concat "Buffer not found: " ,buffer-name)))))
(my-make-goto-buffer-fn my-buffer-compilation "*compilation*")
(my-make-goto-buffer-fn my-buffer-grep "*grep*")
(my-make-goto-buffer-fn my-buffer-find "*Find*")
(my-make-goto-buffer-fn my-buffer-shell "*shell*")

(defun my-comment-prefix ()
  (interactive)
  (comment-dwim nil)
  (when (looking-back "[^ ]")
    (insert " "))
  (insert (format-time-string "%Y-%m-%d bstiles: " (current-time))))

(defun my-set-tab-width-4 ()
  (interactive)
  (set-variable 'tab-width 4))

(defun my-set-tab-width-8 ()
  (interactive)
  (set-variable 'tab-width 8))

(defun my-align-let ()
  (interactive)
  (save-excursion
    (let ((beg (search-backward "(let [")))
      (forward-char)
      (forward-sexp)
      (forward-sexp)
      (align-regexp beg (point)
                    "\\(\\s-*\\(\\s-*(let\\s-*\\[\\)?\\)\\_<.+?\\_>\\(\\s-+\\)"
                    3 1 nil))))

(defun my-toggle-truncate-lines ()
  (interactive)
  (set-variable 'truncate-lines (not truncate-lines)))

;;; Command key is Meta on Mac
;;; ----------------------------------------------------------------------------
(when (eq system-type 'darwin)
  (setq mac-command-modifier 'meta))

;; 'Correct' the backspace key in a tty by binding C-x ? to help-command
;; (in any case so that it is consistently bound) and translating C-h to DEL
;; only if in a tty
(if (< (string-to-number emacs-version) 21)
    (progn
      (my-global-set-key "C-x ?" 'help-command)
      (if (not window-system)
           (keyboard-translate ?\C-h ?\C-?))))

;;; Common global key bindings
;;; ----------------------------------------------------------------------------
(my-global-set-key "<f7>" 'mark-sexp) ; For terminals (mapped to C-opt-SPC in iTerm2)
;; (my-global-set-key "C-." 'hippie-expand)
(my-global-set-key "C-/" 'comment-or-uncomment-region)
(my-global-set-key "<f6>" 'comment-or-uncomment-region) ; For terminals (mapped to C-/ in iTerm2)
(my-global-set-key "C-c C-/" 'my-comment-prefix)
(my-global-set-key "C-c 4" 'my-set-tab-width-4)
(my-global-set-key "C-c 8" 'my-set-tab-width-8)
(my-global-set-key "C-c a" 'align-regexp)
(my-global-set-key "C-c A" 'my-align-let)
(my-global-set-key "C-c P" 'picture-mode)
(my-global-set-key "C-c f" 'font-lock-mode)
(my-global-set-key "C-c g c" 'my-buffer-compilation)
(if (< (string-to-number emacs-version) 24.4)
    (setq user-emacs-directory "~/.emacs.d"))
(my-make-find-file-fn my-file-init (expand-file-name "init.el" user-emacs-directory))
(my-global-set-key "C-c g e" 'my-file-init)
(my-make-find-file-fn my-file-init-minimal (expand-file-name "init-minimal.el" my-emacs-config-dir))
(my-global-set-key "C-c g E m" 'my-file-init-minimal)
(my-global-set-key "C-c g f" 'my-buffer-find)
(my-global-set-key "C-c g F" 'find-dired)
(my-global-set-key "C-c g g" 'my-buffer-grep)
(my-global-set-key "C-c g l" 'goto-line)
(my-global-set-key "C-c t" 'my-toggle-truncate-lines)
(my-global-set-key "C-c w" 'whitespace-mode)
(my-global-set-key "C-M-<tab>" [escape tab])
