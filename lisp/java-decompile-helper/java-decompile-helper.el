;;; java-decompile-helper.el --- Decompiles Java .class files automatically

;; Copyright (C) 2001 Brian Stiles <bstiles@bstiles.net>

;; Emacs Lisp Archive Entry
;; Filename: java-decompile-helper.el
;; Version: 0.0
;; Keywords: java
;; Author: Brian Stiles <bstiles@bstiles.net>
;; Maintainer: Brian Stiles <bstiles@bstiles.net>
;; Description: Decompiles Java .class files automatically
;; URL: http://sourceforge.net/projects/brianselgoodies/
;; Compatibility: Emacs20, ???

;; This file is not part of GNU Emacs.

;; This is free software; you can redistribute it and/or modify it under
;; the terms of the GNU General Public License as published by the Free
;; Software Foundation; either version 2, or (at your option) any later
;; version.
;;
;; This is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
;; FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
;; for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
;; MA 02111-1307, USA.

;;; Commentary:

;; This is a very simple pseudo-mode that takes effect when opening a
;; compiled Java .class file.  It calls the jd-cli decompiler on the class file
;; to produce a decompiled version of the source and displays that in the
;; buffer and switches to 'jde-mode'.  If the .class file has already been
;; decompiled and is being displayed in a buffer, this process will be
;; short-circuited and that buffer will be displayed instead (actually this
;; happens in any case if a buffer of the same name exists).  By the way,
;; this works when opening .class files from within .jar and .zip files
;; using Zip-Archive mode.

;; There are a number of limitations as is, stemming from the fact that this
;; is just a quick hack so I could browse the source of Java classes whether or
;; not I had the source immediately available.

;; - jd-cli is from https://github.com/kwart/jd-cli

;; - the location to jd-cli is hard-coded

;; - the temporary output directory is hard-coded to /tmp

;; - temporary output files don't get cleaned up

;; - the mode is changed to jde-mode explicitly instead of using what would be
;;   the normal mode for the .java file.

;; In order to install, put java-decompile-helper.el on you load-path, and add
;; the following to your .emacs file:

;; (setq auto-mode-alist (cons '("\\.class$" . java-decompile-mode) auto-mode-alist))

;;; Code:


(defun java-decompile-mode ()
  "Runs the java-decompiler (FernFlower) Java decompiler and puts the output into a new buffer named appropriately based on the file being decompiled."
  (interactive)
  (string-match "\\([^ ]*\\).class" (buffer-name))
  (unless (file-directory-p "/tmp/java-decompiler/")
    (make-directory "/tmp/java-decompiler"))
  (let ((coding-system-for-write 'binary)
        (tmpfile (concat (make-temp-name "/tmp/java-decompiler/") ".class"))
	(newbufname (format "%s.java" (match-string 1 (buffer-name))))
	(thisbuf (get-buffer (buffer-name))))
    (if (get-buffer newbufname)
	(progn
	  (switch-to-buffer (get-buffer newbufname))
	  (kill-buffer thisbuf))
      (write-region nil nil tmpfile nil t)
      (erase-buffer)
      (shell-command (format (concat (getenv "HOME") "/bin/java-decompiler/java-decompiler %s") tmpfile) t)
      (rename-buffer newbufname)
      (read-only-mode)
      (set-buffer-modified-p nil)
      (java-mode))))
