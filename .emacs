
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(comint-buffer-maximum-size 20000)
 '(comint-completion-addsuffix t)
 '(comint-get-old-input (lambda nil "") t)
 '(comint-input-ignoredups t)
 '(comint-input-ring-size 5000)
 '(comint-prompt-read-only nil)
 '(comint-scroll-show-maximum-output t)
 '(comint-scroll-to-bottom-on-input t)
 '(comint-scroll-to-bottom-on-output nil)
 '(custom-safe-themes
   (quote
    ("a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "4cf3221feff536e2b3385209e9b9dc4c2e0818a69a1cdb4b522756bcdf4e00a4" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default)))
 '(debug-on-error t)
 '(helm-ag-base-command "rg --smart-case --no-heading --line-number")
 '(initial-frame-alist (quote ((fullscreen . maximized))))
 '(org-agenda-files
   (quote
    ("~/workspace/workspace/gtd.org" "~/workspace/workspace/finance.org" "~/workspace/workspace/notes.org" "~/workspace/workspace/someday.org")))
 '(package-selected-packages
   (quote
    (paredit expand-region ob-redis indium counsel-dash jedi circe circle elfeed company ycmd helm-zhihu-daily groovy-mode gradle-mode company-anaconda anaconda-mode virtualenvwrapper plantuml-mode docker hackernews helm-ag ag popup auto-complete-auctex auto-complete zygospore youdao-dictionary yaml-mode ws-butler web-mode w3m volatile-highlights use-package tern-auto-complete tagedit sr-speedbar solarized-theme smartparens smart-mode-line scss-mode restclient popwin peep-dired paradox ox-twbs org nyan-mode nginx-mode markdown-preview-eww markdown-mode lenlen-theme json-mode js2-refactor iedit helm-swoop helm-projectile helm-gtags helm-descbinds haml-mode gitignore-mode ggtags function-args flycheck-package exec-path-from-shell emmet-mode duplicate-thing dtrt-indent dockerfile-mode dired-subtree dired+ company-irony comment-dwim-2 color-identifiers-mode clean-aindent-mode beacon bash-completion anzu)))
 '(protect-buffer-bury-p nil)
 '(save-place t nil (saveplace))
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(tramp-default-method "ssh"))

(server-start)

(add-to-list 'load-path (expand-file-name "~/emacs.d/"))
(require 'base)
(require 'base-extensions)
(require 'init-dired)
(require 'init-web)
(require 'init-php)

;;;
;;; Org Mode
;;;
;;
;; Standard key bindings
(use-package org
  :ensure t
  :defer t
  :ensure org-plus-contrib
  :init
  (setq org-replace-disputed-keys t
        org-default-notes-file (expand-file-name "notes.org" (getenv "HOME")))
  :bind (("C-c l" . org-store-link)
         ("C-c a" . org-agenda)
         ("C-c b" . org-iswitchb)
         ("C-c c" . org-capture)
         ("C-c M-p" . org-babel-previous-src-block)
         ("C-c M-n" . org-babel-next-src-block)
         ("C-c S" . org-babel-previous-src-block)
         ("C-c s" . org-babel-next-src-block))
  :config
  (progn
    (setq org-highest-priority ?1)
    (setq org-default-priority ?2)
    (setq org-lowest-priority ?3)
    (setq org-confirm-babel-evaluate nil
          org-src-fontify-natively t
          org-src-tab-acts-natively t)
    ))

;; The following lines are always needed. Choose your own keys.
(add-hook 'org-mode-hook 'turn-on-font-lock) ; not needed when global-font-lock-mode is on
;(require 'org-latex)
(unless (boundp 'org-export-latex-classes)
  (setq org-export-latex-classes nil))
(add-to-list 'org-export-latex-classes
             '("article"
               "\\documentclass{article}"
               ("\\section{%s}" . "\\section*{%s}")))

(setq Tex-auto-save t) ;I forget what these do, I've
(setq TeX-parse-self t) ;always had them
;(require 'tex-mik)
;(load "auctex.el" nil t t) ;Now necessary with latest
            ;version of AucTeX
(setq org-export-with-LaTeX-fragments "dvipng") ;Now necessary with
            ;orgmove version 7.4
            ;or later

(setq org-log-done 'time)
(setq org-log-done 'note)
(setq org2blog/wp-blog-alist
       '(("ruili"
          :url "http://beta.rui.li/xmlrpc.php"
          :username "tshwangq"
          :default-title "Hello World"
          :default-categories ("org2blog" "emacs")
          :tags-as-categories nil)
         ))
 (setq org2blog/wp-buffer-template
  "-----------------------
 #+TITLE: %s
 #+DATE: %s
 -----------------------\n")

 (defun my-format-function (format-string)
    (format format-string
            org2blog/wp-default-title
            (format-time-string "%d-%m-%Y" (current-time))))
 (setq org2blog/wp-buffer-format-function 'my-format-function)


(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
              (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING"))))


(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
              ("NEXT" :foreground "blue" :weight bold)
              ("DONE" :foreground "forest green" :weight bold)
              ("WAITING" :foreground "orange" :weight bold)
              ("HOLD" :foreground "magenta" :weight bold)
              ("CANCELLED" :foreground "forest green" :weight bold)
              ("MEETING" :foreground "forest green" :weight bold)
              ("PHONE" :foreground "forest green" :weight bold))))
(setq org-directory "~/workspace/workspace/")
(setq org-default-notes-file (concat org-directory "notes.org"))
(global-set-key (kbd "C-c c") 'org-capture)
(setq org-agenda-include-diary t)
;; Capture templates for: TODO tasks, Notes, appointments, phone calls, meetings, and org-protocol
(setq org-capture-templates
      (quote (("t" "todo" entry (file (concat org-directory "inbox.org"))
               "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
              ("r" "respond" entry (file (concat org-directory "notes.org"))
               "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
              ("n" "note" entry (file (concat org-directory "notes.org"))
               "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
              ("j" "Journal" entry (file+datetree (concat org-directory "diary.org"))
               "* %?\n%U\n" :clock-in t :clock-resume t)
              ("w" "org-protocol" entry (file (concat org-directory "inbox.org"))
               "* TODO Review %c\n%U\n" :immediate-finish t)
              ("m" "Meeting" entry (file (concat org-directory "inbox.org"))
               "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t)
              ("p" "Phone call" entry (file (concat org-directory "inbox.org"))
               "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
              ("h" "Habit" entry (file (concat org-directory "inbox.org"))
               "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))

(setq org-agenda-files (list "~/workspace/workspace/gtd.org"
                             "~/workspace/workspace/inbox.org"
                     "~/workspace/workspace/journal.org"
                     "~/workspace/workspace/notes.org"
                     "~/workspace/workspace/dairy.org"
                     "~/workspace/workspace/finance.org"
                     "~/workspace/awesome-smoking/README.org"
                    ))

(setq org-refile-targets (list "~/workspace/workspace/gtd.org"
                             "~/workspace/workspace/journal.org"
                             "~/workspace/workspace/notes.org"
                             "~/workspace/workspace/dairy.org"
                             "~/workspace/workspace/finance.org"
                             "~/workspace/awesome-smoking/README.org"
                             "~/workspace/workspace/someday.org"))

(setq org-todo-keyword-faces
      '(("TODO" . org-warning) ("STARTED" . "red")
        ("CANCELED" . (:foreground "blue" :weight bold))))

(setq org-agenda-custom-commands
'(("k" "work haha"
((agenda "")
(tags-todo "work")
(tags-todo "支持")))))
(add-to-list 'load-path "~/org-8.3.3/contrib/lisp" t)
;(require 'ox-taskjuggler)
(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)
(defun turn-on-flyspell () (flyspell-mode 1))
(add-hook 'find-file-hooks 'turn-on-flyspell)
(setq ispell-extra-args '("--sug-mode=ultra" "--lang=en_US"))

(defun sudo-edit (&optional arg)
  "Edit currently visited file as root.

With a prefix ARG prompt for a file to visit.
Will also prompt for a file to visit if current
buffer is not visiting a file."
  (interactive "P")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:"
                         (ido-read-file-name "Find file(as root): ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

(global-set-key (kbd "C-x C-r") 'sudo-edit)

(setq browse-url-browser-function 'w3m-goto-url-new-session)
(setq w3m-user-agent "Mozilla/5.0 (Linux; U; Android 2.3.3; zh-tw; HTC_Pyramid Build/GRI40) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.")
(defun hn ()
  (interactive)
  (browse-url "http://news.ycombinator.com"))
;; export HTTP_PROXY=127.0.0.1:8888
;; eww
;(setq url-proxy-services '(("no_proxy" . "work\\.com")
                           ;("http" . "127.0.0.1:8888")
                           ;("https" . "127.0.0.1:8888")))
(setq url-gateway-method 'socks)
(setq socks-server '("Default server" "127.0.0.1" 1080 5))
(defun toggle-env-http-proxy ()
  "set/unset the environment variable http_proxy which w3m uses"
  (interactive)
  (let ((proxy "127.0.0.1:8888"))
    (if (string= (getenv "http_proxy") proxy)
        ;; clear the proxy
        (progn
          (setenv "http_proxy" "")
          (message "env http_proxy is empty now")
          )
      ;; set the proxy
      (setenv "http_proxy" proxy)
      (message "env http_proxy is %s now" proxy)
        )
    ))

(setq gc-cons-threshold 100000000)
(setq inhibit-startup-message t)

(defalias 'yes-or-no-p 'y-or-n-p)

(defconst demo-packages
  '(anzu
    duplicate-thing
    ggtags
    helm-gtags
    helm-projectile
    helm-swoop
    helm-descbinds
    ;; function-args
    clean-aindent-mode
    comment-dwim-2
    dtrt-indent
    ws-butler
    sr-speedbar
    iedit
    smartparens
    projectile
    volatile-highlights
    zygospore
    js2-mode
    ))

(defun install-packages ()
  "Install all required packages."
  (interactive)
  (unless package-archive-contents
    (package-refresh-contents))
  (dolist (package demo-packages)
    (unless (package-installed-p package)
      (package-install package))))

(install-packages)

(require 'setup-helm)
(require 'setup-helm-gtags)
;; (require 'setup-ggtags)
(require 'setup-cedet)
(require 'setup-editing)

(windmove-default-keybindings)

;; function-args
;; (require 'function-args)
;; (fa-config-default)
;; (define-key c-mode-map  [(tab)] 'company-complete)
;; (define-key c++-mode-map  [(tab)] 'company-complete)

;; show unncessary whitespace that can mess up your diff
(add-hook 'prog-mode-hook (lambda () (interactive) (setq show-trailing-whitespace 1)))

;; use space to indent by default
(setq-default indent-tabs-mode nil)

;; set appearance of a tab that is represented by 4 spaces
(setq-default tab-width 4)

;; Compilation
(global-set-key (kbd "<f5>") (lambda ()
                               (interactive)
                               (setq-local compilation-read-command nil)
                               (call-interactively 'compile)))

;; setup GDB
(setq
 ;; use gdb-many-windows by default
 gdb-many-windows t

 ;; Non-nil means display source file containing the main routine at startup
 gdb-show-main t
 )

;; Package: clean-aindent-mode
(require 'clean-aindent-mode)
(add-hook 'prog-mode-hook 'clean-aindent-mode)

;; Package: dtrt-indent
(require 'dtrt-indent)
(dtrt-indent-mode 1)

;; Package: ws-butler
(require 'ws-butler)
(add-hook 'prog-mode-hook 'ws-butler-mode)

(use-package yasnippet
  :ensure t
  :init
  (progn
    (yas-global-mode 1)
))
;; Add yasnippet support for all company backends
;; https://github.com/syl20bnr/spacemacs/pull/179
(defvar company-mode/enable-yas t
  "Enable yasnippet for all backends.")

(defun company-mode/backend-with-yas (backend)
  (if (or (not company-mode/enable-yas) (and (listp backend) (member 'company-yasnippet backend)))
      backend
    (append (if (consp backend) backend (list backend))
            '(:with company-yasnippet))))

(setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))

;; Package: smartparens
(require 'smartparens-config)
(setq sp-base-key-bindings 'paredit)
(setq sp-autoskip-closing-pair 'always)
(setq sp-hybrid-kill-entire-symbol nil)
(sp-use-paredit-bindings)

(show-smartparens-global-mode +1)
(smartparens-global-mode 1)

;; Package: projejctile
(require 'projectile)
(projectile-global-mode)
(setq projectile-enable-caching t)

(require 'helm-projectile)
(helm-projectile-on)
(setq projectile-completion-system 'helm)
(setq projectile-indexing-method 'alien)

;; Package zygospore
(global-set-key (kbd "C-x 1") 'zygospore-toggle-delete-other-windows)

(require 'org)
(let ((current-prefix-arg 1))
  (call-interactively 'org-reload))

(global-set-key (kbd "C-c o")
                (lambda () (interactive) (find-file "~/workspace/workspace/notes.org")))
(global-set-key (kbd "C-c g")
                (lambda () (interactive) (find-file "~/workspace/workspace/gtd.org")))


(use-package bash-completion
  :ensure t
  :init
  (bash-completion-setup))
;; active Org-babel languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '(;; other Babel languages
   (plantuml . t)))
;(require 'eh-org)
(use-package ob-plantuml
  :ensure nil
  :config
  (setq org-plantuml-jar-path "~/plantuml.jar"))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((sh         . t)
   (js         . t)
   (sql        . t)
   (emacs-lisp . t)
   (perl       . t)
   (scala      . t)
   (clojure    . t)
   (python     . t)
   (ruby       . t)
   (dot        . t)
   (css        . t)
   (plantuml   . t)))
(setq org-publish-project-alist
      '(("www"
         :base-directory "~/workspace/www/"
         :publishing-directory "~/public_html/"
         :publishing-function org-twbs-publish-to-html
         :with-sub-superscript nil
         )))
(defun my-org-publish-buffer ()
  (interactive)
  (save-buffer)
  (save-excursion (org-publish-current-file))
  (let* ((proj (org-publish-get-project-from-filename buffer-file-name))
         (proj-plist (cdr proj))
         (rel (file-relative-name buffer-file-name
                                  (plist-get proj-plist :base-directory)))
         (dest (plist-get proj-plist :publishing-directory)))
    (browse-url (concat "file://"
                        (file-name-as-directory (expand-file-name dest))
                        (file-name-sans-extension rel)
                        ".html"))))

;; javascript
(use-package js2-mode
  :ensure t
  :init
  (setq js-basic-indent 2)
  (setq-default js2-basic-indent 2
                js2-basic-offset 2
                js2-auto-indent-p t
                js2-cleanup-whitespace t
                js2-enter-indents-newline t
                js2-indent-on-enter-key t
                js2-global-externs (list "window" "module" "require" "buster" "sinon" "assert" "refute" "setTimeout" "clearTimeout" "setInterval" "clearInterval" "location" "__dirname" "console" "JSON" "jQuery" "$")))

  (add-hook 'js2-mode-hook
            (lambda ()
              (push '("function" . ?ƒ) prettify-symbols-alist)))
  ;(add-hook 'js2-mode-hook (lambda () (tern-mode t)))
  ;(setq tern-command (cons (executable-find "tern") '()))
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

(use-package ag
  :ensure t
  :init
  )


(use-package color-identifiers-mode
  :ensure t
  :init
  (add-hook 'js2-mode-hook 'color-identifiers-mode))

(use-package js2-refactor
  :ensure t
  :init   (add-hook 'js2-mode-hook 'js2-refactor-mode)
  :config (js2r-add-keybindings-with-prefix "C-c ."))


(setq-local imenu-create-index-function #'ggtags-build-imenu-index)
(require 'cc-mode)
(require 'semantic)

(global-semanticdb-minor-mode 1)
(global-semantic-idle-scheduler-mode 1)

(semantic-mode 1)

(use-package dired-subtree :ensure t
  :after dired
  :config
  (bind-key "<tab>" #'dired-subtree-toggle dired-mode-map)
  (bind-key "<backtab>" #'dired-subtree-cycle dired-mode-map))
(add-hook 'dired-mode-hook 'hl-line-mode)
;;preview files in dired
(use-package peep-dired
  :ensure t
  :defer t ; don't access `dired-mode-map' until `peep-dired' is loaded
  :bind (:map dired-mode-map
              ("P" . peep-dired)))
(use-package yaml-mode
  :mode ("\\.yml$" . yaml-mode))

(use-package popwin
  :config (popwin-mode 1))
(use-package windmove
  :config (windmove-default-keybindings 'shift))

(use-package smart-mode-line
  :ensure t
  :init
  (progn
    (setq sml/no-confirm-load-theme t)
    (sml/setup)))

(use-package beacon
  :ensure t
  :defer t
  :init (beacon-mode 1))


(use-package hackernews
  :ensure t
  :defer t
  :init )
(use-package docker
  :ensure t
  :init)
(use-package gradle-mode
  :ensure t
  :init)
(use-package groovy-mode
  :ensure t
  :init)

(use-package plantuml-mode
  :ensure t
  :init)
;(use-package mode-icons
;  :ensure t
;  :defer t
;  :init (mode-icons-mode))
(defun dired-open-file ()
  "In dired, open the file named on this line."
  (interactive)
  (let* ((file (dired-get-filename nil t)))
    (message "Opening %s..." file)
    (call-process "gnome-open" nil 0 nil file)
    (message "Opening %s done" file)))

(require 'run-assoc)
(setq associated-program-alist
      '(("gnochm" "\\.chm$")
        ("evince" "\\.pdf$")
        ("mplayer" "\\.mp3$")
        ("evince" "\\.ps$")
        ((lambda (file)
           (browse-url (concat "file:///" (expand-file-name file)))) "\\.html?$")))

; (require 'org-drill)
(defun ange-ftp-set-passive ()
  "Function to send a PASV command to hosts not named in the variable
  `ange-ft-hosts-no-pasv'. Intended to be called from the hook variable
  `ange-ftp-process-startup-hook'."	; rephrased significantly // era
  (if (not (member host ange-ftp-hosts-no-pasv))
      (ange-ftp-raw-send-cmd proc "passive")))
(add-hook 'ange-ftp-process-startup-hook 'ange-ftp-set-passive)
(defun dired-open-file ()
  "In dired, open the file named on this line."
  (interactive)
  (let* ((file (dired-get-filename nil t)))
    (message "Opening %s..." file)
    (call-process "gnome-open" nil 0 nil file)
    (message "Opening %s done" file)))


(setq org-agenda-custom-commands
      '(("h" "Daily habits"
         ((agenda ""))
         ((org-agenda-show-log t)
          (org-agenda-ndays 7)
          (org-agenda-log-mode-items '(state))
          (org-agenda-skip-function '(org-agenda-skip-entry-if 'notregexp ":smoking:"))))
        ;; other commands here
        ))
(add-to-list 'org-modules 'org-habit)


(require 'org-habit)

(with-eval-after-load 'eww
  (custom-set-variables
   '(eww-search-prefix "http://www.google.com/search?q="))

  (define-key eww-mode-map (kbd "h") 'backward-char)
  (define-key eww-mode-map (kbd "n") 'next-line)
  (define-key eww-mode-map (kbd "s") 'forward-char)
  (define-key eww-mode-map (kbd "t") 'previous-line)

  (define-key eww-mode-map (kbd "H") 'eww-back-url)
  (define-key eww-mode-map (kbd "S") 'eww-forward-url)

  (define-key eww-mode-map (kbd "b") 'eww-history-browse)
  (define-key eww-mode-map (kbd "c") 'eww-browse-with-external-browser)
  (define-key eww-mode-map (kbd "i") 'eww)
  (define-key eww-mode-map (kbd "m") 'eww-lnum-follow)
  (define-key eww-mode-map (kbd "z") 'eww-lnum-universal)

  (define-key eww-mode-map (kbd "M-n") 'nil)
  (define-key eww-mode-map (kbd "M-p") 'nil)

  (define-key eww-mode-map (kbd "<C-S-iso-lefttab>") 'eww-previous-buffer)
  (define-key eww-mode-map (kbd "<C-tab>")           'eww-next-buffer)
)

(setq dired-dwim-target t)
(add-to-list 'load-path (expand-file-name "~/.emacs.d/init"))
;(require 'init-python)

(setq recentf-auto-cleanup 'never) ;; disable before we start recentf!
(recentf-mode 1)
(setq recentf-max-menu-items 2500)
(run-at-time nil (* 5 60) 'recentf-save-list)


(setq display-time-world-list '(("Asia/Shanghai" "China")
                                ("Australia/Melbourne" "Melbourne")))

(defun setup-windows ()
  "Organize a series of windows for ultimate distraction."
  (interactive)
  (delete-other-windows)

  ;; Start with the Stack Overflow interface
  (sx-tab-frontpage t nil)

  ;; Put IRC on the other side
  (split-window-horizontally)
  (other-window 1)
  (circe-connect-all)

  ;; My RSS Feed goes on top:
  (split-window-vertically)
  (elfeed)

  ;; And start up the Twitter interface above that:
  (other-window 2)
  (split-window-vertically)
  (twit)

  (window-configuration-to-register ?w))

(add-to-list 'auto-mode-alist '("\\.jsx?$" . web-mode))

(require 'ycmd)
(set-variable 'ycmd-server-command '("python" "/home/qun/ycmd/ycmd"))
(company-ycmd-setup)
                                        ; Jedi
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)


(define-derived-mode react-mode web-mode "React-IDE"
  "Major mode for eding jsx code.")
(add-hook 'react-mode-hook 'ycmd-mode)
(add-hook 'react-mode-hook
          '(lambda
             ()
             (web-mode-set-content-type "jsx")
             (message "set web-mode-content-type %s" web-mode-content-type))

          (add-to-list 'ycmd-file-type-map '(react-mode . ("javascript")))
          (add-to-list 'auto-mode-alist '("\\.jsx$" . react-mode)))
(add-hook 'web-mode-hook (lambda () (tern-mode t)))
(add-to-list 'company-backends 'company-tern)

(use-package circe
  :ensure t
  :init
  (setq circe-network-options
        '(("Freenode"
           :tls t
           :nick "qun"
           ;:sasl-username "my-nick"
           ;:sasl-password "my-password"
           :channels ("#emacs")
           )))
  )

(require 'albin-music-mode)

(defun sudo-edit-current-file ()
  (interactive)
  (let ((my-file-name) ; fill this with the file to open
        (position))    ; if the file is already open save position
    (if (equal major-mode 'dired-mode) ; test if we are in dired-mode
        (progn
          (setq my-file-name (dired-get-file-for-visit))
          (find-alternate-file (prepare-tramp-sudo-string my-file-name)))
      (setq my-file-name (buffer-file-name); hopefully anything else is an already opened file
            position (point))
      (find-alternate-file (prepare-tramp-sudo-string my-file-name))
      (goto-char position))))


(defun prepare-tramp-sudo-string (tempfile)
  (if (file-remote-p tempfile)
      (let ((vec (tramp-dissect-file-name tempfile)))

        (tramp-make-tramp-file-name
         "sudo"
         (tramp-file-name-user nil)
         (tramp-file-name-host vec)
         (tramp-file-name-localname vec)
         (format "ssh:%s@%s|"
                 (tramp-file-name-user vec)
                 (tramp-file-name-host vec))))
    (concat "/sudo:root@localhost:" tempfile)))

(define-key dired-mode-map [s-return] 'sudo-edit-current-file)
(setq python-shell-prompt-detect-failure-warning nil)


(unless (package-installed-p 'indium)
  (package-install 'indium))
(require 'indium)
(provide '.emacs)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
