;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/orgroam/") ;; TOCONF

(use-package! rainbow-delimiters
    :hook (prog-mode . rainbow-delimiters-mode))
(defun efs/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package! lsp-mode
  :hook (lsp-mode . efs/lsp-mode-setup))

(global-set-key "\C-s" 'swiper)

;; (setq projectile-indexing-method 'native)
(setq projectile-globally-ignored-files
      (append '(
        ".DS_Store"
        "*.wav"
        "*.npy"
        "*.tar.gz"
        "*.tgz"
        "*.zip"
        )
          projectile-globally-ignored-files))

(exec-path-from-shell-initialize)

(use-package! org-roam
  :config
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  ;; If using org-roam-protocol
  (require 'org-roam-protocol)
  :custom
  (org-roam-completion-everywhere t)
  (org-roam-directory "~/orgroam") ;; TOCONF
  (org-roam-capture-templates
   '(("d" "default" plain "%?" :target
      (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
      :unnarrowed t)))
  :bind (:map org-mode-map
         ("C-M-i"    . completion-at-point)))

(use-package! websocket
    :after org-roam)

(use-package! ivy-bibtex
  :config
  (setq bibtex-completion-bibliography "~/material/paper.bib" ;; TOCONF
        bibtex-completion-notes-path "~/orgroam/paper.org" ;; TOCONF
        bibtex-completion-display-formats '((t . " ${title:*} ${year:4} ${domain:13} ${pubon:11} ${dataset:50} ${=has-pdf=:1}${=has-note=:1}"))
        bibtex-completion-notes-template-one-file "\n* (${year}) - ${title} :${domain}:\n  :PROPERTIES:\n  :Custom_ID: ${=key=}\n  :NOTER_DOCUMENT: ${pdf}\n  :END:\n** Overview\n"
        bibtex-completion-pdf-field "pdf"
        bibtex-completion-additional-search-fields '(domain dataset pubon))
  :custom
  (ivy-height 25)
  :bind
  ("C-c n B" . ivy-bibtex))

(use-package! org-noter
  :custom
  (org-noter-default-notes-file-names '("~/orgroam/paper.org")))

(add-hook 'org-mode-hook 'valign-mode)

;; allow for export=>beamer by placing
;; #+LaTeX_CLASS: beamer in org files
(unless (boundp 'org-export-latex-classes)
  (setq org-export-latex-classes nil))
(add-to-list 'org-export-latex-classes
  ;; beamer class, for presentations
  '("beamer"
     "\\documentclass[11pt]{beamer}\n
      \\mode<{{{beamermode}}}>\n
      \\usetheme{{{{beamertheme}}}}\n
      \\usecolortheme{{{{beamercolortheme}}}}\n
      \\beamertemplateballitem\n
      \\setbeameroption{show notes}
      \\usepackage[utf8]{inputenc}\n
      \\usepackage[T1]{fontenc}\n
      \\usepackage{hyperref}\n
      \\usepackage{color}
      \\usepackage{listings}
      \\lstset{numbers=none,language=[ISO]C++,tabsize=4,
  frame=single,
  basicstyle=\\small,
  showspaces=false,showstringspaces=false,
  showtabs=false,
  keywordstyle=\\color{blue}\\bfseries,
  commentstyle=\\color{red},
  }\n
      \\usepackage{verbatim}\n
      \\institute{{{{beamerinstitute}}}}\n
       \\subject{{{{beamersubject}}}}\n"

     ("\\section{%s}" . "\\section*{%s}")

     ("\\begin{frame}[fragile]\\frametitle{%s}"
       "\\end{frame}"
       "\\begin{frame}[fragile]\\frametitle{%s}"
       "\\end{frame}")))


;;(use-package! bibtex
;;  :config
;;  ;; Change fields and format
;;  (setq bibtex-user-optional-fields
;;        '(("keywords" "Keywords to describe the entry" "")
;;          ("file" "Link to document file." ":"))
;;        bibtex-align-at-equal-sign t
;;        bib-files-directory (directory-files
;;                             (concat (getenv "HOME") "/Bib") t
;;                             "^[A-Z|a-z].+.bib$")
;;        pdf-files-directory (concat (getenv "HOME") "/Pdf")))
;;
;;
;;(use-package! helm-bibtex
;;  :config
;;  (setq bibtex-completion-bibliography bib-files-directory
;;        bibtex-completion-library-path pdf-files-directory
;;        bibtex-completion-pdf-field "File"
;;        bibtex-completion-notes-path org-directory
;;        bibtex-completion-additional-search-fields '(keywords))
;;  :bind
;;  (("C-c n B" . helm-bibtex)))
;;
;;;;Spell checking (requires the ispell software)
;;(add-hook 'bibtex-mode-hook 'flyspell-mode)
;;
;;(use-package! org-roam-bibtex
;;  :after (org-roam helm-bibtex)
;;  :bind (:map org-mode-map ("C-c n b" . orb-note-actions))
;;  :config
;;  (require 'org-ref))
;;
;;(org-roam-bibtex-mode)
;;(map! :after helm
;;           :map helm-map
;;           "TAB"      #'helm-select-action
;;            [tab]      #'helm-select-action
;;            "C-z"      #'helm-execute-persistent-action)
;;;; helm-bibtex related stuff
;;(after! helm
;;  (use-package! helm-bibtex
;;    :custom
;;    ;; In the lines below I point helm-bibtex to my default library file.
;;    (bibtex-completion-bibliography '("/Users/hoo/Desktop/hello.bib"))
;;    ;; The line below tells helm-bibtex to find the path to the pdf
;;    ;; in the "file" field in the .bib file.
;;    (bibtex-completion-pdf-field "file")
;;    :hook (Tex . (lambda () (define-key Tex-mode-map "\C-ch" 'helm-bibtex))))
;;  ;; I also like to be able to view my library from anywhere in emacs, for example if I want to read a paper.
;;  ;; I added the keybind below for that.
;;  (map! :leader
;;        :desc "Open literature database"
;;        "o l" #'helm-bibtex)
;;  ;; And I added the keybinds below to make the helm-menu behave a bit like the other menus in emacs behave with evil-mode.
;;  ;; Basically, the keybinds below make sure I can scroll through my list of references with C-j and C-k.
;;  (map! :map helm-map
;;        "C-j" #'helm-next-line
;;        "C-k" #'helm-previous-line)
;;)
;;
;; ;; Set up org-ref stuff
;; (use-package! org-ref
;;    :custom
;;    ;; Again, we can set the default library
;;    (org-ref-default-bibliography "/ssdhome/xzw521/hello.bib"))
;;    ;; The default citation type of org-ref is cite:, but I use citep: much more often
;;    ;; I therefore changed the default type to the latter.
;;    ;; (org-ref-default-citation-link "citep")

 ;; The function below allows me to consult the pdf of the citation I currently have my cursor on.
;; (defun my/org-ref-open-pdf-at-point ()
;;  "Open the pdf for bibtex key under point if it exists."
;;  (interactive)
;;  (let* ((results (org-ref-get-bibtex-key-and-file))
;;         (key (car results))
;;         (pdf-file (funcall org-ref-get-pdf-filename-function key)))
;;    (if (file-exists-p pdf-file)
;;        (find-file pdf-file)
;;      (message "No PDF found for %s" key))))
;;
;; (setq org-ref-completion-library 'org-ref-ivy-cite
;;       org-export-latex-format-toc-function 'org-export-latex-no-toc
;;       org-ref-get-pdf-filename-function
;;       (lambda (key) (car (bibtex-completion-find-pdf key)))
;;       ;; See the function I defined above.
;;       org-ref-open-pdf-function 'my/org-ref-open-pdf-at-point
;;       ;; For pdf export engines.
;;       org-latex-pdf-process (list "latexmk -pdflatex='%latex -shell-escape -interaction nonstopmode' -pdf -bibtex -f -output-directory=%o %f")
;;       ;; I use orb to link org-ref, helm-bibtex and org-noter together (see below for more on org-noter and orb).
;;       org-ref-notes-function 'orb-edit-notes)

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
