(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-auto-show-menu nil)
 '(ac-auto-start nil)
 '(ac-use-quick-help nil)
 '(ahs-default-range (quote ahs-range-whole-buffer))
 '(ahs-idle-interval 0.33)
 '(ahs-include
   (quote
    ((clojure-mode . "^[0-9A-Za-z/_.,:;*+=&%|$#@!^?'>-]+$"))))
 '(ahs-modes
   (quote
    (actionscript-mode apache-mode bat-generic-mode c++-mode c-mode csharp-mode css-mode dos-mode emacs-lisp-mode ini-generic-mode java-mode javascript-mode js-mode lisp-interaction-mode lua-mode latex-mode makefile-mode makefile-gmake-mode markdown-mode moccur-edit-mode outline-mode perl-mode cperl-mode php-mode python-mode rc-generic-mode reg-generic-mode ruby-mode sgml-mode sh-mode squirrel-mode tcl-mode visual-basic-mode clojure-mode)))
 '(ahs-plugin-bod-modes
   (quote
    (emacs-lisp-mode lisp-interaction-mode c++-mode nil clojure-mode)))
 '(align-c++-modes
   (quote
    (c++-mode c-mode java-mode coffee-mode javascript-mode js2-mode)))
 '(align-lisp-modes
   (quote
    (emacs-lisp-mode lisp-interaction-mode lisp-mode scheme-mode)))
 '(align-text-modes (quote (text-mode outline-mode)))
 '(ange-ftp-ftp-program-args (quote ("-i" "-n" "-g" "-v")))
 '(archive-zip-expunge (quote ("/Users/bstiles/bin/irise-zip" "-d" "-q")))
 '(archive-zip-extract (quote ("/Users/bstiles/bin/irise-unzip" "-qq" "-c")))
 '(archive-zip-update (quote ("/Users/bstiles/bin/irise-zip" "-q")))
 '(archive-zip-update-case (quote ("/Users/bstiles/bin/irise-zip" "-q" "-k")))
 '(blink-cursor-blinks 0)
 '(blink-cursor-interval 0.5)
 '(bookmark-default-file (expand-file-name ".emacs.bmk" user-emacs-directory))
 '(browse-url-browser-function (quote browse-url-chrome-browser))
 '(browse-url-firefox-program "/Applications/Firefox.app/Contents/MacOS/firefox-bin")
 '(canlock-password "e7415257d290faf90e7bedf1524d44d0fb6b3a2c")
 '(cider-auto-jump-to-error nil)
 '(cider-macroexpansion-suppress-namespaces nil)
 '(clojure-defun-indents (quote (apply interpose run run* with-precision fresh)))
 '(clojure-defun-style-default-indent t)
 '(coffee-command (concat (getenv "HOME") "/bin/coffee"))
 '(coffee-tab-width 2)
 '(column-number-mode t)
 '(comment-auto-fill-only-comments t)
 '(company-idle-delay nil)
 '(company-tooltip-minimum-width 30)
 '(compilation-scroll-output t)
 '(completion-ignored-extensions
   (quote
    (".svn/" "CVS/" ".o" "~" ".bin" ".lbin" ".so" ".a" ".ln" ".blg" ".bbl" ".elc" ".lof" ".glo" ".idx" ".lot" ".dvi" ".fmt" ".tfm" ".pdf" ".class" ".fas" ".lib" ".mem" ".x86f" ".sparcf" ".fasl" ".ufsl" ".fsl" ".dxl" ".pfsl" ".dfsl" ".lo" ".la" ".gmo" ".mo" ".toc" ".aux" ".cp" ".fn" ".ky" ".pg" ".tp" ".cps" ".fns" ".kys" ".pgs" ".tps" ".vrs" ".pyc" ".pyo" ".DS_Store")))
 '(completion-styles
   (quote
    (basic partial-completion emacs22 partial-completion)))
 '(confirm-kill-emacs (quote yes-or-no-p))
 '(dabbrev-check-all-buffers t)
 '(dired-guess-shell-alist-user (quote (("[.]pdf" "open"))))
 '(dired-omit-files "^\\.?#\\|^\\.$\\|^\\.\\.$\\|.*~\\|CVS\\|.DS_Store")
 '(dired-recursive-copies (quote top))
 '(ediff-diff3-options "--strip-trailing-cr")
 '(ediff-diff3-program "gdiff3")
 '(ediff-keep-variants nil)
 '(ediff-split-window-function (quote split-window-horizontally))
 '(emerge-diff-options "--strip-trailing-cr")
 '(emerge-diff3-program "gdiff3")
 '(eshell-ask-to-save-history nil)
 '(eshell-cmpl-cycle-completions nil)
 '(eshell-cmpl-expand-before-complete t)
 '(eshell-cmpl-ignore-case t)
 '(eshell-exit-hook nil)
 '(eshell-history-size 128000)
 '(eshell-output-filter-functions
   (quote
    (eshell-postoutput-scroll-to-bottom eshell-handle-control-codes eshell-watch-for-password-prompt)))
 '(eshell-save-history-on-exit nil)
 '(explicit-bash-args (quote ("--noediting" "--login" "-i")))
 '(fci-rule-color "SlateGray")
 '(fci-rule-column 80)
 '(find-exec-terminator "\\;")
 '(find-ls-option (quote ("-exec ls -ld {} \\;" . "-ld")))
 '(global-auto-highlight-symbol-mode t)
 '(global-hl-line-mode t)
 '(global-hl-sexp-mode nil)
 '(global-whitespace-mode nil)
 '(graphviz-dot-view-command "open -a \"OmniGraffle Professional 5.app\" \"%s\"")
 '(grep-find-command (quote ("find . -type f -exec grep -nH -e  {} +" . 34)))
 '(grep-find-ignored-directories
   (quote
    ("SCCS" "RCS" "CVS" "MCVS" ".svn" ".git" ".hg" ".bzr" "_MTN" "_darcs" "{arch}" "build.output" "node_modules")))
 '(grep-find-ignored-files
   (quote
    (".#*" "*.o" "*~" "*.bin" "*.lbin" "*.so" "*.a" "*.ln" "*.blg" "*.bbl" "*.elc" "*.lof" "*.glo" "*.idx" "*.lot" "*.fmt" "*.tfm" "*.class" "*.fas" "*.lib" "*.mem" "*.x86f" "*.sparcf" "*.dfsl" "*.pfsl" "*.d64fsl" "*.p64fsl" "*.lx64fsl" "*.lx32fsl" "*.dx64fsl" "*.dx32fsl" "*.fx64fsl" "*.fx32fsl" "*.sx64fsl" "*.sx32fsl" "*.wx64fsl" "*.wx32fsl" "*.fasl" "*.ufsl" "*.fsl" "*.dxl" "*.lo" "*.la" "*.gmo" "*.mo" "*.toc" "*.aux" "*.cp" "*.fn" "*.ky" "*.pg" "*.tp" "*.vr" "*.cps" "*.fns" "*.kys" "*.pgs" "*.tps" "*.vrs" "*.pyc" "*.pyo")))
 '(grep-highlight-matches nil)
 '(grep-setup-hook
   (quote
    ((lambda nil
       (set-variable
        (quote truncate-lines)
        t)))))
 '(helm-buffers-fuzzy-matching t)
 '(helm-ff-history-max-length 500)
 '(helm-grep-max-length-history 500)
 '(helm-imenu-fuzzy-match t)
 '(helm-truncate-lines t)
 '(highlight-symbol-idle-delay 0.5)
 '(highlight-symbol-on-navigation-p t)
 '(hl-paren-background-colors (quote ("black" "black" "black")))
 '(hl-paren-colors (quote ("green" "red" "wheat" "wheat" "wheat" "wheat")))
 '(ibuffer-default-sorting-mode (quote recency))
 '(ibuffer-filter-group-name-face (quote font-lock-function-name-face))
 '(ibuffer-fontification-alist
   (quote
    ((5
      (buffer-modified-p)
      font-lock-warning-face)
     (10 buffer-read-only font-lock-constant-face)
     (15
      (and buffer-file-name
           (string-match ibuffer-compressed-file-name-regexp buffer-file-name))
      font-lock-doc-face)
     (20
      (string-match "^*"
                    (buffer-name))
      font-lock-keyword-face)
     (25
      (and
       (string-match "^ "
                     (buffer-name))
       (null buffer-file-name))
      italic)
     (30
      (memq major-mode ibuffer-help-buffer-modes)
      font-lock-comment-face)
     (35
      (eq major-mode
          (quote dired-mode))
      font-lock-function-name-face))))
 '(ibuffer-formats
   (quote
    ((mark modified read-only " "
           (name 32 32 :left :elide)
           " "
           (size 9 -1 :right)
           " "
           (mode 16 16 :left :elide)
           " " filename-and-process)
     (mark " "
           (name 32 32 :left :elide)
           " " filename))))
 '(ibuffer-old-time 72)
 '(ibuffer-show-empty-filter-groups t)
 '(ibuffer-use-other-window t)
 '(ido-max-prospects 50)
 '(ido-max-window-height 0.5)
 '(imenu-auto-rescan t)
 '(indent-tabs-mode nil)
 '(indicate-buffer-boundaries (quote left))
 '(inferior-js-program-command "/Users/bstiles/bin/rhino.py")
 '(ispell-program-name "aspell")
 '(jka-compr-compression-info-list
   (quote
    (["\\.i[Dd]oc\\'" "saving iDoc" "cat" nil "stripping iDoc header" "tail"
      ("-c" "+17")
      nil nil "iRise iDoc"]
     ["\\.i[Bb]loc\\'" "saving iBloc" "cat" nil "stripping iBloc header" "tail"
      ("-c" "+16")
      nil nil "iRise iBloc"]
     ["\\.plist\\'" "converting text XML to binary plist" "/Users/bstiles/bin/jka-compr-plutil-wrapper.sh"
      ("-convert binary1")
      "converting binary plist to text XML" "/Users/bstiles/bin/jka-compr-plutil-wrapper.sh"
      ("-convert xml1")
      nil nil "bplist"]
     ["\\.Z\\(~\\|\\.~[0-9]+~\\)?\\'" "compressing" "compress"
      ("-c")
      "uncompressing" "gzip"
      ("-c" "-q" "-d")
      nil t "\235"]
     ["\\.bz2\\(~\\|\\.~[0-9]+~\\)?\\'" "bzip2ing" "bzip2" nil "bunzip2ing" "bzip2"
      ("-d")
      nil t "BZh"]
     ["\\.tbz2?\\'" "bzip2ing" "bzip2" nil "bunzip2ing" "bzip2"
      ("-d")
      nil nil "BZh"]
     ["\\.\\(?:tgz\\|svgz\\|sifz\\)\\(~\\|\\.~[0-9]+~\\)?\\'" "compressing" "gzip"
      ("-c" "-q")
      "uncompressing" "gzip"
      ("-c" "-q" "-d")
      t nil "\213"]
     ["\\.g?z\\(~\\|\\.~[0-9]+~\\)?\\'" "compressing" "gzip"
      ("-c" "-q")
      "uncompressing" "gzip"
      ("-c" "-q" "-d")
      t t "\213"]
     ["\\.xz\\(~\\|\\.~[0-9]+~\\)?\\'" "XZ compressing" "xz"
      ("-c" "-q")
      "XZ uncompressing" "xz"
      ("-c" "-q" "-d")
      t t "\3757zXZ "]
     ["\\.dz\\'" nil nil nil "uncompressing" "gzip"
      ("-c" "-q" "-d")
      nil t "\213"])))
 '(jka-compr-load-suffixes (quote (".gz")))
 '(js-indent-level 2)
 '(js2-basic-offset 2)
 '(locate-command "mdfind")
 '(major-mode (quote text-mode))
 '(markdown-coding-system (quote utf-8))
 '(markdown-command "multimarkdown")
 '(markdown-css-path "")
 '(markdown-xhtml-header-content
   "<style type=\"text/css\">
body {
  font-family: Helvetica, arial, sans-serif;
  font-size: 14px;
  line-height: 1.6;
  padding-top: 10px;
  padding-bottom: 10px;
  background-color: white;
  padding: 30px; }

body > *:first-child {
  margin-top: 0 !important; }
body > *:last-child {
  margin-bottom: 0 !important; }

a {
  color: #4183C4; }
a.absent {
  color: #cc0000; }
a.anchor {
  display: block;
  padding-left: 30px;
  margin-left: -30px;
  cursor: pointer;
  position: absolute;
  top: 0;
  left: 0;
  bottom: 0; }

h1, h2, h3, h4, h5, h6 {
  margin: 20px 0 10px;
  padding: 0;
  font-weight: bold;
  -webkit-font-smoothing: antialiased;
  cursor: text;
  position: relative; }

h1:hover a.anchor, h2:hover a.anchor, h3:hover a.anchor, h4:hover a.anchor, h5:hover a.anchor, h6:hover a.anchor {
  background: url(\"../../images/modules/styleguide/para.png\") no-repeat 10px center;
  text-decoration: none; }

h1 tt, h1 code {
  font-size: inherit; }

h2 tt, h2 code {
  font-size: inherit; }

h3 tt, h3 code {
  font-size: inherit; }

h4 tt, h4 code {
  font-size: inherit; }

h5 tt, h5 code {
  font-size: inherit; }

h6 tt, h6 code {
  font-size: inherit; }

h1 {
  font-size: 28px;
  color: black; }

h2 {
  font-size: 24px;
  border-bottom: 1px solid #cccccc;
  color: black; }

h3 {
  font-size: 18px; }

h4 {
  font-size: 16px; }

h5 {
  font-size: 14px; }

h6 {
  color: #777777;
  font-size: 14px; }

p, blockquote, ul, ol, dl, li, table, pre {
  margin: 15px 0; }

hr {
  background: transparent url(\"../../images/modules/pulls/dirty-shade.png\") repeat-x 0 0;
  border: 0 none;
  color: #cccccc;
  height: 4px;
  padding: 0; }

body > h2:first-child {
  margin-top: 0;
  padding-top: 0; }
body > h1:first-child {
  margin-top: 0;
  padding-top: 0; }
  body > h1:first-child + h2 {
    margin-top: 0;
    padding-top: 0; }
body > h3:first-child, body > h4:first-child, body > h5:first-child, body > h6:first-child {
  margin-top: 0;
  padding-top: 0; }

a:first-child h1, a:first-child h2, a:first-child h3, a:first-child h4, a:first-child h5, a:first-child h6 {
  margin-top: 0;
  padding-top: 0; }

h1 p, h2 p, h3 p, h4 p, h5 p, h6 p {
  margin-top: 0; }

li p.first {
  display: inline-block; }

ul, ol {
  padding-left: 30px; }

ul :first-child, ol :first-child {
  margin-top: 0; }

ul :last-child, ol :last-child {
  margin-bottom: 0; }

dl {
  padding: 0; }
  dl dt {
    font-size: 14px;
    font-weight: bold;
    font-style: italic;
    padding: 0;
    margin: 15px 0 5px; }
    dl dt:first-child {
      padding: 0; }
    dl dt > :first-child {
      margin-top: 0; }
    dl dt > :last-child {
      margin-bottom: 0; }
  dl dd {
    margin: 0 0 15px;
    padding: 0 15px; }
    dl dd > :first-child {
      margin-top: 0; }
    dl dd > :last-child {
      margin-bottom: 0; }

blockquote {
  border-left: 4px solid #dddddd;
  padding: 0 15px;
  color: #777777; }
  blockquote > :first-child {
    margin-top: 0; }
  blockquote > :last-child {
    margin-bottom: 0; }

table {
  padding: 0; }
  table tr {
    border-top: 1px solid #cccccc;
    background-color: white;
    margin: 0;
    padding: 0; }
    table tr:nth-child(2n) {
      background-color: #f8f8f8; }
    table tr th {
      font-weight: bold;
      border: 1px solid #cccccc;
      text-align: left;
      margin: 0;
      padding: 6px 13px; }
    table tr td {
      border: 1px solid #cccccc;
      text-align: left;
      margin: 0;
      padding: 6px 13px; }
    table tr th :first-child, table tr td :first-child {
      margin-top: 0; }
    table tr th :last-child, table tr td :last-child {
      margin-bottom: 0; }

img {
  max-width: 100%; }

span.frame {
  display: block;
  overflow: hidden; }
  span.frame > span {
    border: 1px solid #dddddd;
    display: block;
    float: left;
    overflow: hidden;
    margin: 13px 0 0;
    padding: 7px;
    width: auto; }
  span.frame span img {
    display: block;
    float: left; }
  span.frame span span {
    clear: both;
    color: #333333;
    display: block;
    padding: 5px 0 0; }
span.align-center {
  display: block;
  overflow: hidden;
  clear: both; }
  span.align-center > span {
    display: block;
    overflow: hidden;
    margin: 13px auto 0;
    text-align: center; }
  span.align-center span img {
    margin: 0 auto;
    text-align: center; }
span.align-right {
  display: block;
  overflow: hidden;
  clear: both; }
  span.align-right > span {
    display: block;
    overflow: hidden;
    margin: 13px 0 0;
    text-align: right; }
  span.align-right span img {
    margin: 0;
    text-align: right; }
span.float-left {
  display: block;
  margin-right: 13px;
  overflow: hidden;
  float: left; }
  span.float-left span {
    margin: 13px 0 0; }
span.float-right {
  display: block;
  margin-left: 13px;
  overflow: hidden;
  float: right; }
  span.float-right > span {
    display: block;
    overflow: hidden;
    margin: 13px auto 0;
    text-align: right; }

code, tt {
  margin: 0 2px;
  padding: 0 5px;
  white-space: nowrap;
  border: 1px solid #eaeaea;
  background-color: #f8f8f8;
  border-radius: 3px; }

pre code {
  margin: 0;
  padding: 0;
  white-space: pre;
  border: none;
  background: transparent; }

.highlight pre {
  background-color: #f8f8f8;
  border: 1px solid #cccccc;
  font-size: 13px;
  line-height: 19px;
  overflow: auto;
  padding: 6px 10px;
  border-radius: 3px; }

pre {
  background-color: #f8f8f8;
  border: 1px solid #cccccc;
  font-size: 13px;
  line-height: 19px;
  overflow: auto;
  padding: 6px 10px;
  border-radius: 3px; }
  pre code, pre tt {
    background-color: transparent;
    border: none; }
</style>")
 '(mode-line-format
   (quote
    ("%e" mode-line-front-space mode-line-mule-info mode-line-client mode-line-modified mode-line-remote mode-line-frame-identification mode-line-buffer-identification "   " mode-line-position "  " mode-line-modes mode-line-misc-info mode-line-end-spaces)))
 '(mode-require-final-newline t)
 '(mouse-wheel-scroll-amount (quote (1 ((shift) . 1) ((control)))))
 '(ns-alternate-modifier (quote none))
 '(ns-pop-up-frames nil)
 '(org-agenda-custom-commands
   (quote
    (("x" "Describe command here" tags "" nil)
     ("P" "Show Projects" tags "Type=\"project\"" nil))))
 '(org-agenda-files (quote ("~/org/")))
 '(org-agenda-fontify-priorities (quote cookies))
 '(org-agenda-sorting-strategy
   (quote
    ((agenda habit-down time-up priority-down category-keep)
     (todo priority-down todo-state-down)
     (tags priority-down category-keep)
     (search category-keep))))
 '(org-agenda-todo-keyword-format "%-6s")
 '(org-babel-load-languages
   (quote
    ((emacs-lisp . t)
     (dot . t)
     (python . t)
     (clojure . t)
     (sh . t)
     (java . t))))
 '(org-babel-post-tangle-hook nil)
 '(org-babel-results-keyword "results")
 '(org-catch-invisible-edits (quote error))
 '(org-clock-into-drawer 3)
 '(org-confirm-babel-evaluate nil)
 '(org-default-priority 67)
 '(org-drawers (quote ("PROPERTIES" "CLOCK" "LOGBOOK" "DATA")))
 '(org-export-backends (quote (ascii html icalendar latex md)))
 '(org-html-head
   "<style type=\"text/css\">
  body {
    font-family: \"avenir next\", \"verdana\", \"helvetica neue\", \"helvetica\", \"arial unicode\", \"arial\", sans-serif;
    /*font-family: \"georgia\", \"times new roman\", serif;*/
    font-size: larger;
    padding-left: 1.4em;
  }
  table.org-info-js_info-navigation {
    //margin-left: -1em;
  }
  h1,h2,h3,h4,h5,h6 {
    color: rgb(7, 70, 140);
    //margin-left: -1em;
  }
  p {
    max-width: 60rem;
  }
  pre.src {
    color: #f5deb3;
    background-color: #2f4f4f;
    font-family: \"menlo\", \"lucida sans typewriter\", \"courier\", monospace;
    font-size: smaller;
    overflow-x: scroll;
  }
  code {
    font-family: \"menlo\", \"lucida sans typewriter\", \"courier\", monospace;
    color: #600;
  }
  blockquote {
    background-color: #ffd;
    border-left: 5px solid red;
    padding-left: 5px;
    font-family: \"futura\", \"helvetica\", \"arial\", sans-serif;
  }
  li > code, p > code {
    background-color: #eee;
    border: 1px solid #aaa;
  }
  table {
    margin: 1.2em;
    border: 1px solid #000000;
  }
  th {
    vertical-align: middle;
    text-align: left;
    background-color: rgba(100,150,250,0.2);
    border: 1px solid #000000;
    font-family: \"menlo\", \"lucida sans typewriter\", \"courier\", monospace;
    font-size: smaller;
  }
  td {
    vertical-align: middle;
    border: 1px solid #000000;
    text-align: left;
    padding: 7px;
    font-family: \"menlo\", \"lucida sans typewriter\", \"courier\", monospace;
    font-weight: normal;
    font-size: smaller;
  }
  td:first-child {
    background-color: rgba(100,150,250,0.1);
  }
  .moore td:nth-child(2) {
    background-color: rgba(150,150,150,0.1);
  }
  .moore td:nth-child(3) {
    background-color: rgba(150,150,150,0.1);
  }
  .moore th:nth-child(2) {
    background-color: rgba(150,150,150,0.2);
    font-weight: bolder;
  }
  .moore th:nth-child(3) {
    background-color: rgba(150,150,150,0.2);
    font-weight: bolder;
  }
  .procedure th:first-child, .scenario th:first-child {
    background-color: rgba(150,150,150,0.2);
    font-weight: bolder;
  }
  .procedure td:first-child, .scenario td:first-child {
    background-color: rgba(150,150,150,0.1);
  }
  dl {
    max-width: 60rem;
  }
  dt {
    min-width: 5em;
    clear: left;
    float: left;
    margin-right: 1em;
  }
  dd {
    margin-left: 6em;
  }
  caption {
    text-align: left;
    margin-bottom: 1em;
    font-style: italic;
    white-space: nowrap;
  }
  caption::after {
    font-size: smaller;
  }
  .mealy caption::after {
    content: \" (type=mealy)\";
  }
  .moore caption::after {
    content: \" (type=moore)\";
  }
  .procedure caption::after {
    content: \" (type=procedure)\";
  }
  .constructor caption::after {
    content: \" (type=constructor)\";
  }
  .scenario caption::after {
    content: \" (type=scenario)\";
  }
  #postamble {
    font-size: smaller;
    color: #999;
  }
  #postamble :link, #postamble :visited {
    color: #999;
  }
</style>")
 '(org-indent-boundary-char 166)
 '(org-load-hook
   (quote
    ((lambda nil
       (org-babel-lob-ingest
        (concat
         (getenv "HOME")
         "/org/lob.org"))))))
 '(org-md-headline-style (quote setext))
 '(org-mobile-directory "~/Dropbox/Apps/MobileOrg")
 '(org-mode-hook
   (quote
    (#[nil "\300\301\302\303\304$\207"
           [org-add-hook change-major-mode-hook org-show-block-all append local]
           5]
     #[nil "\300\301\302\303\304$\207"
           [org-add-hook change-major-mode-hook org-babel-show-result-all append local]
           5]
     org-babel-result-hide-spec org-babel-hide-all-hashes auto-fill-mode)))
 '(org-priority-faces
   (quote
    ((65 . font-lock-warning-face)
     (66 . font-lock-warning-face))))
 '(org-refile-targets (quote ((org-agenda-files :level . 1))))
 '(org-refile-use-outline-path (quote file))
 '(org-src-fontify-natively t)
 '(org-startup-folded nil)
 '(org-startup-indented t)
 '(org-structure-template-alist
   (quote
    (("s" "#+begin_src ?

#+end_src" "<src lang=\"?\">

</src>")
     ("e" "#+begin_example
?
#+end_example" "<example>
?
</example>")
     ("q" "#+begin_quote
?
#+end_quote" "<quote>
?
</quote>")
     ("v" "#+begin_verse
?
#+end_verse" "<verse>
?
</verse>")
     ("V" "#+begin_verbatim
?
#+end_verbatim" "<verbatim>
?
</verbatim>")
     ("c" "#+BEGIN_COMMENT
?
#+END_COMMENT")
     ("l" "#+begin_latex
?
#+end_latex" "<literal style=\"latex\">
?
</literal>")
     ("L" "#+latex: " "<literal style=\"latex\">?</literal>")
     ("h" "#+begin_html
?
#+end_html" "<literal style=\"html\">
?
</literal>")
     ("H" "#+html: " "<literal style=\"html\">?</literal>")
     ("a" "#+begin_ascii
?
#+end_ascii")
     ("A" "#+ascii: ")
     ("i" "#+index: ?" "#+index: ?")
     ("I" "#+include: %file ?" "<include file=%file markup=\"?\">"))))
 '(org-tags-column -88)
 '(org-time-stamp-custom-formats (quote ("<%m/%d/%y %a>" . "<%m/%d %a>")))
 '(org-todo-keyword-faces
   (quote
    (("IDEA" . "Gray")
     ("NEXT" :foreground "Red" :background "Black" :weight bold :inverse-video t)
     ("DELEGATED" :foreground "Gold" :background "Black" :weight bold :inverse-video t)
     ("ACTIVE" :foreground "Yellow" :background "Black" :weight bold :inverse-video t)
     ("PAUSED" :foreground "pink" :background "black" :weight bold :inverse-video t)
     ("WAIT" :foreground "pink" :weight bold :inverse-video t))))
 '(org-todo-keywords
   (quote
    ((type "IDEA(i)" "TODO(t)" "NEXT(n)" "WAIT(w)" "ACTIVE(a)" "DELEGATED(D)" "PAUSED(p!)" "DONE(d!)"))))
 '(oz-prefix "/Applications/Mozart.app/Contents/Resources")
 '(package-archives
   (quote
    (("gnu" . "http://elpa.gnu.org/packages/")
     ("marmalade" . "http://marmalade-repo.org/packages/")
     ("org" . "http://orgmode.org/elpa/")
     ("melpa-stable" . "http://melpa-stable.milkbox.net/packages/")
     ("melpa" . "http://melpa.milkbox.net/packages/"))))
 '(projectile-globally-ignored-directories
   (quote
    (".idea" ".eunit" ".git" ".hg" ".fslckout" ".bzr" "_darcs" ".tox" ".svn" "build" "tmp")))
 '(projectile-project-root-files
   (quote
    ("rebar.config" "project.clj" "pom.xml" "build.sbt" "build.gradle" "Gemfile" "requirements.txt" "package.json" "gulpfile.js" "Gruntfile.js" "bower.json" "composer.json" ".git" ".projectile")))
 '(projectile-project-root-files-bottom-up nil)
 '(projectile-switch-project-action (quote projectile-dired))
 '(py-default-interpreter (quote jython))
 '(py-jython-command (concat (getenv "HOME") "/bin/jython"))
 '(py-shell-switch-buffers-on-execute nil)
 '(read-buffer-completion-ignore-case t)
 '(safe-local-variable-values
   (quote
    ((eval load-file "../../irml-mode.el")
     (eval load-file "../../ob-irml.el")
     (eval load-file "../../ob-jsinclude.el")
     (eval load-file "../../ob-nxml.el")
     (eval load-file "../../ob-css.el")
     (eval load-file "../../aquarium-mode.el")
     (TeX-command-default . "ConTeXt-XeTeX")
     (show-trailing-whitespace . t))))
 '(scroll-bar-mode nil)
 '(send-mail-function (quote mailclient-send-it))
 '(show-paren-mode t)
 '(show-trailing-whitespace nil)
 '(slime-net-coding-system (quote utf-8-unix))
 '(sql-sqlite-program "sqlite3")
 '(tramp-verbose 2)
 '(truncate-partial-width-windows nil)
 '(uniquify-buffer-name-style (quote post-forward) nil (uniquify))
 '(uniquify-separator nil)
 '(use-dialog-box nil)
 '(visual-line-fringe-indicators (quote (left-curly-arrow right-curly-arrow)))
 '(whitespace-global-modes t)
 '(whitespace-style
   (quote
    (face tabs trailing space-before-tab newline indentation empty space-after-tab lines-tail))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:foreground "Wheat" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 170 :width normal :family "Menlo"))))
 '(ahs-definition-face ((((background dark)) (:background "#bb3222" :underline t)) (((background light)) (:background "Yellow" :underline t))))
 '(ahs-face ((((background dark)) (:background "#992000")) (((background light)) (:background "Yellow"))))
 '(ahs-plugin-defalt-face ((t (:background "#206600"))))
 '(ahs-plugin-whole-buffer-face ((((background dark)) (:background "#662000")) (((background light)) (:background "#edda00"))))
 '(bs-hl-sexp-endcaps-face ((t (:foreground "white" :weight bold))))
 '(c-annotation-face ((t (:foreground "grey"))))
 '(col-highlight ((t (:background "Black"))))
 '(comint-highlight-input ((t (:foreground "orange" :weight bold))))
 '(comint-highlight-prompt ((t (:background "gray90" :foreground "black"))))
 '(company-tooltip ((t (:background "light yellow" :foreground "black"))))
 '(company-tooltip-selection ((t (:inherit company-tooltip :background "gold"))))
 '(cursor ((t (:background "#ff00aa"))))
 '(ecb-token-header-face ((((class color) (background dark)) (:underline t))))
 '(ediff-current-diff-B ((t (:background "#1f7f3f"))))
 '(ediff-fine-diff-A ((t (:background "Red" :foreground "black"))))
 '(ediff-fine-diff-B ((t (:background "Green" :foreground "black"))))
 '(flx-highlight-face ((t (:inherit warning :underline t :weight bold))))
 '(font-lock-builtin-face ((((class color) (background dark)) (:foreground "LightSteelBlue")) (((class color) (background light)) (:foreground "LightSteelBlue4"))))
 '(font-lock-comment-face ((((class color) (background dark)) (:foreground "Gray")) (((class color) (background light)) (:foreground "Gray40"))))
 '(font-lock-constant-face ((((class color) (background dark)) (:foreground "Aquamarine")) (((class color) (background light)) (:foreground "Black" :weight bold))))
 '(font-lock-function-name-face ((((class color) (background dark)) (:foreground "White" :weight bold)) (((class color) (background light)) (:foreground "Red" :weight bold))))
 '(font-lock-keyword-face ((((class color) (background dark)) (:foreground "Cyan")) (((class color) (background light)) (:foreground "SteelBlue3"))))
 '(font-lock-preprocessor-face ((t (:inherit font-lock-type-face))))
 '(font-lock-regexp-grouping-backslash ((((background dark)) (:foreground "DarkSeaGreen3")) (((background light)) (:foreground "SpringGreen3"))))
 '(font-lock-regexp-grouping-construct ((((background dark)) (:inherit bold :foreground "DarkSeaGreen1")) (((background light)) (:foreground "SpringGreen4"))))
 '(font-lock-string-face ((((class color) (background dark)) (:foreground "Goldenrod")) (((class color) (background light)) (:foreground "Firebrick"))))
 '(font-lock-type-face ((((class grayscale) (background light)) (:foreground "Gray90" :weight bold)) (((class grayscale) (background dark)) (:foreground "DimGray" :weight bold)) (((class color) (min-colors 88) (background light)) (:foreground "DarkGoldenrod")) (((class color) (min-colors 88) (background dark)) (:foreground "PaleGreen")) (((class color) (min-colors 16) (background light)) (:foreground "ForestGreen")) (((class color) (min-colors 16) (background dark)) (:foreground "PaleGreen")) (((class color) (min-colors 8)) (:foreground "green")) (t (:underline t :weight bold))))
 '(font-lock-variable-name-face ((((class color) (background dark)) (:foreground "Khaki" :weight bold)) (((class color) (background light)) (:foreground "DarkGreen" :weight bold))))
 '(font-lock-warning-face ((((class color) (background dark)) (:bold t :foreground "Salmon")) (((class color) (background light)) (:bold t :foreground "Red"))))
 '(gnus-header-content-face ((((class color) (background dark)) (:italic t :foreground "green"))) t)
 '(gnus-header-name-face ((((class color) (background dark)) (:foreground "YellowGreen"))) t)
 '(gnus-header-subject-face ((((class color) (background dark)) (:foreground "Yellow"))) t)
 '(helm-buffer-directory ((t (:inherit font-lock-function-name-face))))
 '(highlight ((t (:background "gray10"))))
 '(highlight-80+ ((t (:underline "yellow"))))
 '(highlight-indent-face ((t (:background "#254545"))))
 '(highlight-symbol-face ((((class color) (background dark)) (:background "#992000"))))
 '(hl-line ((((background dark)) (:background "#292929")) (((background light)) (:background "#ddd8c0"))))
 '(hl-paren-face ((t (:weight bold))) t)
 '(hl-sexp-endcaps-face ((((class color) (background dark)) (:background "green"))))
 '(hl-sexp-face ((((type ns) (background light)) (:background "#ddd8c0")) (((type ns) (background dark)) (:background "#0d302f")) (nil (:background "gray15"))))
 '(jde-java-font-lock-modifier-face ((((class color) (background dark)) (:foreground "LightSteelBlue")) (((class color) (background light)) (:foreground "LightSteelBlue"))))
 '(js2-function-param-face ((t (:foreground "Green"))))
 '(message-cited-text-face ((((class color) (background dark)) (:foreground "gray"))) t)
 '(message-header-cc-face ((((class color) (background dark)) (:bold t :foreground "green2"))) t)
 '(message-header-name-face ((((class color) (background dark)) (:foreground "YellowGreen"))) t)
 '(message-header-other-face ((((class color) (background dark)) (:foreground "LightGreen"))) t)
 '(message-header-subject-face ((((class color) (background dark)) (:foreground "Yellow"))) t)
 '(message-header-to-face ((((class color) (background dark)) (:bold t :foreground "green"))) t)
 '(message-mml-face ((((class color) (background dark)) (:foreground "LimeGreen"))) t)
 '(message-separator-face ((((class color) (background dark)) (:foreground "lightblue"))) t)
 '(modelinepos-column-warning ((t (:background "Yellow" :foreground "Black"))))
 '(nxml-attribute-local-name-face ((nil (:inherit font-lock-warning-face))))
 '(nxml-comment-content-face ((t (:inherit font-lock-comment-face :slant italic))))
 '(nxml-delimiter-face ((((class color) (background dark)) (:inherit font-lock-preprocessor-face))))
 '(nxml-name-face ((((class color) (background dark)) (:inherit font-lock-constant-face))))
 '(org-block-background ((t (:inherit hl-sexp-face))))
 '(org-block-begin-line ((t (:inherit org-meta-line :weight normal))) t)
 '(org-block-end-line ((t (:inherit org-meta-line :underline t :weight normal))) t)
 '(org-date ((((class color) (background dark)) (:foreground "gray"))))
 '(org-done ((t (:foreground "White" :inverse-video t :weight bold))))
 '(org-indent ((((background dark)) (:foreground "gray40")) (((background light)) (:foreground "gray"))) t)
 '(org-link ((t (:underline "Grey"))))
 '(org-meta-line ((t (:foreground "#80af9f" :weight normal))))
 '(org-special-keyword ((((background dark)) (:foreground "Gray70")) (((background light)) (:foreground "gray"))))
 '(org-table ((t (:inherit hl-sexp-face))))
 '(org-tag ((t (:foreground "gray"))))
 '(org-todo ((t (:foreground "Brown" :weight bold))))
 '(outline-1 ((((class color) (background dark)) (:foreground "White" :weight bold)) (((class color) (background light)) (:foreground "Red" :weight bold))))
 '(outline-2 ((((background dark)) (:foreground "yellow")) (((background light)) (:foreground "DarkGreen" :weight bold))))
 '(outline-4 ((t (:inherit font-lock-type-face))))
 '(outline-5 ((t (:inherit font-lock-string-face))))
 '(outline-8 ((t (:inherit font-lock-comment-face))))
 '(sh-heredoc ((((class color) (min-colors 88) (background dark)) (:foreground "yellow1")) (((class color) (background dark)) (:foreground "yellow")) (((class color) (background light)) (:foreground "tan1")) (t nil)))
 '(trailing-whitespace ((((class color) (background dark)) (:background "red1" :box (:line-width 1 :color "red")))))
 '(variable-pitch ((t (:weight light :height 1.1 :width normal :family "Helvetica Neue"))))
 '(whitespace-line ((t (:background "gray20" :underline "Yellow")))))
