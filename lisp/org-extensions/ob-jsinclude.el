;;; ob-jsinclude.el --- org-babel functions for jsinclude evaluation

;; Copyright (C) your name here

;; Author: your name here
;; Keywords: literate programming, reproducible research
;; Homepage: http://orgmode.org
;; Version: 0.01

;;; License:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;;; Requirements:

;; Use this section to list the requirements of this language.  Most
;; languages will require that at least the language be installed on
;; the user's system, and the Emacs major mode relevant to the
;; language be installed as well.

;;; Code:
(require 'ob)
(require 'ob-ref)
(require 'ob-comint)
(require 'ob-eval)
;; possibly require modes required for your language

;; optionally define a file extension for this language
(add-to-list 'org-babel-tangle-lang-exts '("jsinclude" . "js"))

;; optionally declare default header arguments for this language
(defvar org-babel-default-header-args:jsinclude '())

(defun org-babel-variable-assignments:jsinclude (params))

(defalias 'jsinclude-mode 'javascript-mode)

;; This function expands the body of a source code block by doing
;; things like prepending argument definitions to the body, it should
;; be called by the `org-babel-execute:jsinclude' function below.
(defun org-babel-expand-body:jsinclude (body params &optional processed-params)
  (let ((closure-params (cdr (assoc :closure-params params)))
        (closure-args (cdr (assoc :closure-args params)))
        (closure-inline (assoc :closure-inline params))
        (source (cdr (assoc :src-loc params))))
    (concat
     (if (or closure-params closure-args)
         (format "(function(%s) {\n%s\n})(%s)%s\n"
                 (or closure-params "")
                 body
                 (or closure-args closure-params)
                 (if closure-inline "" ";"))
       body)
     ;; "\n//@ sourceURL="
     ;; (replace-regexp-in-string
     ;;  "%[A-F0-9][A-F0-9]" "_"
     ;;  (url-hexify-string (org-no-properties (org-get-heading)) url-path-allowed-chars))
     ;; ".js\n"
     (cond
      ((null source) (format "\n// source=%s\n"
                             (org-no-properties (org-get-heading))))
      ((string-equal source "no") "")
      ((format "\n// source=%s"\n source)))))) 

;; This is the main function which is called to evaluate a code
;; block.
;;
;; This function will evaluate the body of the source code and
;; return the results as emacs-lisp depending on the value of the
;; :results header argument
;; - output means that the output to STDOUT will be captured and
;;   returned
;; - value means that the value of the last statement in the
;;   source code block will be returned
;;
;; The most common first step in this function is the expansion of the
;; PARAMS argument using `org-babel-process-params'.
;;
;; Please feel free to not implement options which aren't appropriate
;; for your language (e.g. not all languages support interactive
;; "session" evaluation).  Also you are free to define any new header
;; arguments which you feel may be useful -- all header arguments
;; specified by the user will be available in the PARAMS variable.
(defun org-babel-execute:jsinclude (body params)
  "Execute a block of jsinclude code with org-babel.  This function is
called by `org-babel-execute-src-block'"
  (let* ((processed-params (org-babel-process-params params))
         ;; set the session if the session variable is non-nil
         ;; (session (org-babel-jsinclude-initiate-session (first processed-params)))
         ;; variables assigned for use in the block
         (vars (second processed-params))
         (result-params (third processed-params))
         ;; either OUTPUT or VALUE which should behave as described above
         (result-type (fourth processed-params))
         ;; expand the body with `org-babel-expand-body:jsinclude'
         (full-body (org-babel-expand-body:jsinclude
                     body params processed-params)))
    ;; actually execute the source-code block either in a session or
    ;; possibly by dropping it to a temporary file and evaluating the
    ;; file.
    ;; 
    ;; for session based evaluation the functions defined in
    ;; `org-babel-comint' will probably be helpful.
    ;;
    ;; for external evaluation the functions defined in
    ;; `org-babel-eval' will probably be helpful.
    ;;
    ;; when forming a shell command, or a fragment of code in some
    ;; other language, please preprocess any file names involved with
    ;; the function `org-babel-process-file-name'. (See the way that
    ;; function is used in the language files)
    full-body
    ))

;; ;; This function should be used to assign any variables in params in
;; ;; the context of the session environment.
;; (defun org-babel-prep-session:jsinclude (session params)
;;   "Prepare SESSION according to the header arguments specified in PARAMS."
;;   )

;; (defun org-babel-jsinclude-var-to-jsinclude (var)
;;   "Convert an elisp var into a string of jsinclude source code
;; specifying a var of the same value."
;;   (format "%S" var))

;; (defun org-babel-jsinclude-table-or-string (results)
;;   "If the results look like a table, then convert them into an
;; Emacs-lisp table, otherwise return the results as a string."
;;   )

;; (defun org-babel-jsinclude-initiate-session (&optional session)
;;   "If there is not a current inferior-process-buffer in SESSION
;; then create.  Return the initialized session."
;;   (unless (string= session "none")
;;     ))

(provide 'ob-jsinclude)
;;; ob-jsinclude.el ends here
