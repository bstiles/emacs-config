(defface bs-hl-sexp-endcaps-face
  '((((type tty))
     (:bold t))
    (((class color) (background light))
     (:background "lightgray"))
    (((class color) (background dark))
     (:background "gray10"))
    (t (:bold t)))
  "Face used to fontify the endcaps of the sexp you're looking at."
  :group 'faces)

(defvar bs-hl-sexp-beginning-endcap-overlay nil)
(defvar bs-hl-sexp-ending-endcap-overlay nil)

(defun bs-hl-sexp-in-comment ()
  "Return non-nil if point is in a string.
\[This is an internal function.]"
  (let ((orig (point)))
    (save-excursion
      (beginning-of-defun)
      (nth 4 (parse-partial-sexp (point) orig)))))

(eval-after-load "hl-sexp"
  '(progn
     (defun hl-sexp-highlight ()
       "Active the Hl-Sexp overlay on the current sexp in the current window.
\(Unless it's a minibuffer window.)"
       (when hl-sexp-mode               ; Could be made buffer-local.
         (unless (window-minibuffer-p (selected-window)) ; silly in minibuffer
           (unless hl-sexp-overlay
             (setq hl-sexp-overlay (make-overlay 1 1)) ; to be moved
             (overlay-put hl-sexp-overlay 'face 'hl-sexp-face))
           (unless bs-hl-sexp-beginning-endcap-overlay
             (setq bs-hl-sexp-beginning-endcap-overlay (make-overlay 1 1)) ; to be moved
             (overlay-put bs-hl-sexp-beginning-endcap-overlay 'face 'bs-hl-sexp-endcaps-face))
           (unless bs-hl-sexp-ending-endcap-overlay
             (setq bs-hl-sexp-ending-endcap-overlay (make-overlay 1 1)) ; to be moved
             (overlay-put bs-hl-sexp-ending-endcap-overlay 'face 'bs-hl-sexp-endcaps-face))
           (overlay-put hl-sexp-overlay 'window (selected-window))
           (overlay-put bs-hl-sexp-beginning-endcap-overlay 'window (selected-window))
           (overlay-put bs-hl-sexp-ending-endcap-overlay 'window (selected-window))
           (save-excursion
             (condition-case nil
                 (backward-up-list 1)
               (error nil))
             (let ((bounds (bounds-of-thing-at-point 'sexp)))
               (when bounds
                 (move-overlay hl-sexp-overlay
                               (car bounds) (cdr bounds)
                               (current-buffer))
                 (when (and (not (in-string-p))
                            (not (bs-hl-sexp-in-comment))
                            (< (car bounds) (cdr bounds)))
                   (move-overlay bs-hl-sexp-beginning-endcap-overlay
                                 (car bounds) (+ 1 (car bounds))
                                 (current-buffer)))
                 ;; (message "Region starts: %d, end at: %d" (car bounds) (cdr bounds))
                 ;; (message "Region starts: %d, end at: %d" (car bounds) (+ 1 (car bounds)))
                 (when (and (not (in-string-p))
                            (not (bs-hl-sexp-in-comment))
                            (< (car bounds) (cdr bounds)))
                   (move-overlay bs-hl-sexp-ending-endcap-overlay
                                 (- (cdr bounds) 1) (cdr bounds)
                                 (current-buffer)))
                 ))))))

     (defun hl-sexp-unhighlight ()
       "Deactivate the Hl-Sexp overlay on the current sexp in the current window."
       (if hl-sexp-overlay
           (delete-overlay hl-sexp-overlay))
       (if bs-hl-sexp-beginning-endcap-overlay
           (delete-overlay bs-hl-sexp-beginning-endcap-overlay))
       (if bs-hl-sexp-ending-endcap-overlay
           (delete-overlay bs-hl-sexp-ending-endcap-overlay)))))

(provide 'hl-sexp-overrides-bs)
