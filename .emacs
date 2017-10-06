
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
 '(package-selected-packages
   (quote
    (xref-js2 jump-tree ace-link avy-zap paredit expand-region ob-redis indium counsel-dash jedi circe circle elfeed company ycmd helm-zhihu-daily groovy-mode gradle-mode company-anaconda anaconda-mode virtualenvwrapper plantuml-mode docker hackernews helm-ag ag popup auto-complete-auctex auto-complete zygospore youdao-dictionary yaml-mode ws-butler web-mode w3m volatile-highlights use-package tern-auto-complete tagedit sr-speedbar solarized-theme smartparens smart-mode-line scss-mode restclient popwin peep-dired paradox ox-twbs org nyan-mode nginx-mode markdown-preview-eww markdown-mode lenlen-theme iedit helm-swoop helm-projectile helm-gtags helm-descbinds haml-mode gitignore-mode ggtags function-args flycheck-package exec-path-from-shell emmet-mode duplicate-thing dtrt-indent dockerfile-mode dired-subtree dired+ company-irony comment-dwim-2 color-identifiers-mode clean-aindent-mode beacon bash-completion anzu)))
 '(protect-buffer-bury-p nil)
 '(save-place t nil (saveplace))
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(tramp-default-method "ssh"))

(server-start)

(add-to-list 'load-path (expand-file-name "~/emacs.d/"))
(require 'base)
(require 'base-extensions)
(require 'ycmd)
(require 'init-dired)
(require 'init-web)
(require 'init-php)
(require 'init-org)
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

(setq w3m-user-agent "Mozilla/5.0 (Linux; U; Android 2.3.3; zh-tw; HTC_Pyramid Build/GRI40) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.")
(defun hn ()
  (interactive)
  (browse-url "http://news.ycombinator.com"))

(defun toggle-eww-proxy ()
  "set/unset eww proxy"
  (interactive)
  (setq socks-server '("Default server" "127.0.0.1" 1080 5))
  (let ((gateway 'socks))
    (if (eq url-gateway-method gateway)
        ;; clear the gateway
        (progn
          (setq url-gateway-method 'native)
          (message "url gateway method is empty now")
          )

      ;; set the gateway
      (setq url-gateway-method gateway)
      (message "url gateway method is %s now" gateway)
        )
    )
  )

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
(setq projectile-switch-project-action 'helm-projectile)
;; Package zygospore
(global-set-key (kbd "C-x 1") 'zygospore-toggle-delete-other-windows)

(use-package bash-completion
  :ensure t
  :init
  (bash-completion-setup))


(use-package ag
  :ensure t
  :init
  )


(setq-local imenu-create-index-function #'ggtags-build-imenu-index)
(require 'cc-mode)
(require 'semantic)

(global-semanticdb-minor-mode 1)
(global-semantic-idle-scheduler-mode 1)

(semantic-mode 1)

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

(require 'run-assoc)
(setq associated-program-alist
      '(("gnochm" "\\.chm$")
        ("evince" "\\.pdf$")
        ("mplayer" "\\.mp3$")
        ("evince" "\\.ps$")
        ((lambda (file)
           (browse-url (concat "file:///" (expand-file-name file)))) "\\.html?$")))

(defun ange-ftp-set-passive ()
  "Function to send a PASV command to hosts not named in the variable
  `ange-ft-hosts-no-pasv'. Intended to be called from the hook variable
  `ange-ftp-process-startup-hook'."	; rephrased significantly // era
  (if (not (member host ange-ftp-hosts-no-pasv))
      (ange-ftp-raw-send-cmd proc "passive")))
(add-hook 'ange-ftp-process-startup-hook 'ange-ftp-set-passive)



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



(set-variable 'ycmd-server-command '("python" "/home/qun/ycmd/ycmd"))
(company-ycmd-setup)
                                        ; Jedi
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)


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


(setq python-shell-prompt-detect-failure-warning nil)


(unless (package-installed-p 'indium)
  (package-install 'indium))
(require 'indium)



(use-package elfeed
  :ensure t
  :commands (elfeed-search-mode elfeed-show-mode)
  :init
  (setq elfeed-feeds
    '(
       ("https://xueqiu.com/hots/topic/rss"             xueqiu)
       ("http://www.360doc.com/rssperson/32953612.aspx"    r360)
       ;; software
       ;; Hacker News
       ("https://news.ycombinator.com/rss"                sw news)
       ("https://www.reddit.com/r/emacs/.rss"             sw emacs)
       ;; The Setup
       ("http://usesthis.com/feed/"                       sw)
       ("http://endlessparentheses.com/atom.xml"          sw emacs)
       ;; Emacs Horrors
       ("http://emacshorrors.com/feed.atom"               sw emacs)
       ;; Emacs Ninja
       ("http://emacsninja.com/feed.atom"                 sw emacs)
       ;; Coding Horror
       ("http://feeds.feedburner.com/codinghorror"        sw)
       ;; The Daily WTF
       ("http://syndication.thedailywtf.com/TheDailyWtf"  sw)
       ;; This Developer's Life
       ("http://feeds.feedburner.com/thisdeveloperslife"  sw)
       ;; One Thing Well
       ("http://onethingwell.org/rss"                     sw tech)
       ;; The Daily WTF
       ("http://syndication.thedailywtf.com/TheDailyWtf"  sw)
       ;; Github Engineering
       ("http://githubengineering.com/atom.xml"           sw tech)
       ;; Google Testing Blog
       ("http://feeds.feedburner.com/blogspot/RLXA"       sw google tech)
       ("http://feeds.feedburner.com/blogspot/sBff")
       ;; SMBC
       ("http://feeds.feedburner.com/smbc-comics/PvLb" comic)
       ;; Wondermark
       ("http://feeds.feedburner.com/wondermark"       comic)))
  (setq elfeed-max-connections 10)
  (setq url-queue-timeout 30)
  :config
  (with-eval-after-load 'evil
      (progn
        (add-to-list 'evil-emacs-state-modes 'elfeed-search-mode)
        (add-to-list 'evil-emacs-state-modes 'elfeed-show-mode)))
  (bind-keys :map elfeed-search-mode-map
             ("<SPC>" . next-line)
             ("U"     . elfeed-unjam))
  (bind-key "S-<SPC>" 'scroll-down-command elfeed-show-mode-map)

  (set-face-attribute
   'elfeed-search-unread-title-face
   nil
   :weight 'normal
   :foreground (face-attribute 'default :foreground))
  (set-face-attribute
   'elfeed-search-title-face
   nil
   :foreground (face-attribute 'font-lock-comment-face :foreground)))

(setq holiday-bahai-holidays nil)
(setq holiday-hebrew-holidays nil)
(setq holiday-islamic-holidays nil)
(setq org-agenda-span 10)
(require 'cal-china-x)
(setq mark-holidays-in-calendar t)
(setq cal-china-x-important-holidays cal-china-x-chinese-holidays)
(setq calendar-holidays cal-china-x-important-holidays)
(defun my/fix-inline-images ()
  (when org-inline-image-overlays
    (org-redisplay-inline-images)))
(add-hook 'org-babel-after-execute-hook 'my/fix-inline-images)

(use-package treemacs
  :ensure t
  :defer t
  :config
  (progn
    (setq treemacs-follow-after-init          t
          treemacs-width                      35
          treemacs-indentation                2
          treemacs-git-integration            t
          treemacs-collapse-dirs              3
          treemacs-silent-refresh             nil
          treemacs-change-root-without-asking nil
          treemacs-sorting                    'alphabetic-desc
          treemacs-show-hidden-files          t
          treemacs-never-persist              nil
          treemacs-is-never-other-window      nil
          treemacs-goto-tag-strategy          'refetch-index)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t))
  :bind
  (:map global-map
        ([f8]        . treemacs-toggle)
        ("<C-M-tab>" . treemacs-toggle)
        ("M-0"       . treemacs-select-window)
        ("C-c 1"     . treemacs-delete-other-windows)
))
(use-package treemacs-projectile
  :defer t
  :ensure t
  :config
  (setq treemacs-header-function #'treemacs-projectile-create-header)
  :bind (:map spacemacs-default-map
              ("fP" . treemacs-projectile)
              ("fp" . treemacs-projectile-toggle)))


(use-package jump-tree
  :config
  (setq global-jump-tree-mode t))
(setq browse-url-browser-function 'eww-browse-url)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
