;;; base-extensions.el --- basice extension configuration
(defun make-obsolete (obsolete-name current-name &optional when)
  "Make the byte-compiler warn that function OBSOLETE-NAME is obsolete.
OBSOLETE-NAME should be a function name or macro name (a symbol).

The warning will say that CURRENT-NAME should be used instead.
If CURRENT-NAME is a string, that is the `use instead' message
\(it should end with a period, and not start with a capital).
WHEN should be a string indicating when the function
was first made obsolete, for example a date or a release number."
  (declare (advertised-calling-convention
            ;; New code should always provide the `when' argument.
            (obsolete-name current-name when) "23.1"))
  (put obsolete-name 'byte-obsolete-info
       ;; The second entry used to hold the `byte-compile' handler, but
       ;; is not used any more nowadays.
       (purecopy (list current-name nil when)))
  obsolete-name)

(defmacro define-obsolete-function-alias (obsolete-name current-name
                                                        &optional when docstring)
  "Set OBSOLETE-NAME's function definition to CURRENT-NAME and mark it obsolete.

\(define-obsolete-function-alias \\='old-fun \\='new-fun \"22.1\" \"old-fun's doc.\")

is equivalent to the following two lines of code:

\(defalias \\='old-fun \\='new-fun \"old-fun's doc.\")
\(make-obsolete \\='old-fun \\='new-fun \"22.1\")

WHEN should be a string indicating when the function was first
made obsolete, for example a date or a release number.

See the docstrings of `defalias' and `make-obsolete' for more details."
  (declare (doc-string 4)
           (advertised-calling-convention
            ;; New code should always provide the `when' argument.
            (obsolete-name current-name when &optional docstring) "23.1"))
  `(progn
     (defalias ,obsolete-name ,current-name ,docstring)
     (make-obsolete ,obsolete-name ,current-name ,when)))

(defun make-obsolete-variable (obsolete-name current-name &optional when access-type)
  "Make the byte-compiler warn that OBSOLETE-NAME is obsolete.
The warning will say that CURRENT-NAME should be used instead.
If CURRENT-NAME is a string, that is the `use instead' message.
WHEN should be a string indicating when the variable
was first made obsolete, for example a date or a release number.
ACCESS-TYPE if non-nil should specify the kind of access that will trigger
  obsolescence warnings; it can be either `get' or `set'."
  (declare (advertised-calling-convention
            ;; New code should always provide the `when' argument.
            (obsolete-name current-name when &optional access-type) "23.1"))
  (put obsolete-name 'byte-obsolete-variable
       (purecopy (list current-name access-type when)))
  obsolete-name)

(defmacro define-obsolete-variable-alias (obsolete-name current-name
						        &optional when docstring)
  "Make OBSOLETE-NAME a variable alias for CURRENT-NAME and mark it obsolete.
This uses `defvaralias' and `make-obsolete-variable' (which see).
See the Info node `(elisp)Variable Aliases' for more details.

If CURRENT-NAME is a defcustom or a defvar (more generally, any variable
where OBSOLETE-NAME may be set, e.g. in an init file, before the
alias is defined), then the define-obsolete-variable-alias
statement should be evaluated before the defcustom, if user
customizations are to be respected.  The simplest way to achieve
this is to place the alias statement before the defcustom (this
is not necessary for aliases that are autoloaded, or in files
dumped with Emacs).  This is so that any user customizations are
applied before the defcustom tries to initialize the
variable (this is due to the way `defvaralias' works).

WHEN should be a string indicating when the variable was first
made obsolete, for example a date or a release number.

For the benefit of Customize, if OBSOLETE-NAME has
any of the following properties, they are copied to
CURRENT-NAME, if it does not already have them:
`saved-value', `saved-variable-comment'."
  (declare (doc-string 4)
           (advertised-calling-convention
            ;; New code should always provide the `when' argument.
            (obsolete-name current-name when &optional docstring) "23.1"))
  `(progn
     (defvaralias ,obsolete-name ,current-name ,docstring)
     ;; See Bug#4706.
     (dolist (prop '(saved-value saved-variable-comment))
       (and (get ,obsolete-name prop)
            (null (get ,current-name prop))
            (put ,current-name prop (get ,obsolete-name prop))))
     (make-obsolete-variable ,obsolete-name ,current-name ,when)))
(defvar native-comp-deferred-compilation-deny-list nil)

;(setq straight-use-package-by-default t)
(require 'org-macs)
;; Install org early before builtin version gets loaded
;(straight-use-package 'org)

;; Copyright (C) 2018, tshwangq

;; Author: Qun Wang <tshwangq@gmail.com>
;; Keywords: configuration
;; Version: 1.0.0

;;; Commentary:

;; basic extension

;;; Code:

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(setq comp-deferred-compilation t)
;(package-initialize)
(setq package-check-signature nil)
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
;(require 'org-macs)
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
   '("4c56af497ddf0e30f65a7232a8ee21b3d62a8c332c6b268c81e9ea99b11da0d3" "285d1bf306091644fb49993341e0ad8bafe57130d9981b680c1dbd974475c5c7" "51ec7bfa54adf5fff5d466248ea6431097f5a18224788d0bd7eb1257a4f7b773" "13a8eaddb003fd0d561096e11e1a91b029d3c9d64554f8e897b2513dbf14b277" "00445e6f15d31e9afaa23ed0d765850e9cd5e929be5e8e63b114a3346236c44c" "c433c87bd4b64b8ba9890e8ed64597ea0f8eb0396f4c9a9e01bd20a04d15d358" "d91ef4e714f05fff2070da7ca452980999f5361209e679ee988e3c432df24347" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "4cf3221feff536e2b3385209e9b9dc4c2e0818a69a1cdb4b522756bcdf4e00a4" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default))
 '(debug-on-error nil)
 '(eww-search-prefix "http://www.google.com/search?q=")
 '(helm-ag-base-command "rg --smart-case --no-heading --line-number")
 '(initial-frame-alist '((fullscreen . maximized)))
 '(org-agenda-files
   '("/home/qun/workspace/workspace/gtd.org" "/home/qun/workspace/workspace/inbox.org" "/home/qun/workspace/workspace/journal.org" "/home/qun/workspace/workspace/notes.org" "/home/qun/workspace/workspace/dairy.org" "/home/qun/workspace/workspace/finance.org" "/home/qun/workspace/awesome-smoking/README.org"))
 '(package-selected-packages
   '(websocket justify-kp nov org-ref deft org-noter-pdftools org-pdftools org-noter pdf-tools org-pdfview helm-gtags flycheck-package company-quickhelp helm-projectile org-roam-server org-roam helm-dictionary css-mode flyspell ediff magit-popup lsp-python-ms dired-quick-sort rainbow-mode web-mode treemacs virtualenvwrapper elfeed projectile lsp-python lsp-ui smartparens-config lsp-php phpunit php-extras phpcbf md4rd true tide org-plus-contrib lsp-vue company-lsp helm-flx py-autopep8 php-mode company-tern js2-refactor ace-pinyin undo-tree multiple-cursors magit dashboard dumb-jump company-ycmd helm-tramp fuzzy mmm-vars css-eldoc xref-js2 jump-tree ace-link avy-zap paredit expand-region indium counsel-dash jedi circe circle ycmd helm-zhihu-daily groovy-mode gradle-mode company-anaconda anaconda-mode plantuml-mode docker hackernews helm-ag ag auto-complete zygospore yaml-mode ws-butler w3m volatile-highlights use-package tern-auto-complete tagedit sr-speedbar solarized-theme smart-mode-line scss-mode restclient popwin peep-dired paradox ox-twbs nyan-mode nginx-mode markdown-preview-eww markdown-mode lenlen-theme iedit helm-swoop helm-descbinds haml-mode gitignore-mode ggtags function-args exec-path-from-shell emmet-mode duplicate-thing dtrt-indent dockerfile-mode dired-subtree company-irony comment-dwim-2 color-identifiers-mode clean-aindent-mode beacon bash-completion anzu))
 '(paradox-github-token t)
 '(protect-buffer-bury-p nil)
 '(safe-local-variable-values
   '((eval progn
           (setq-local org-roam-directory
                       (expand-file-name "./"))
           (setq-local org-roam-db-location
                       (concat org-roam-directory "org-roam.db")))
     (eval setq-local org-roam-directory
           (expand-file-name "./"))
     (eval progn
           (setq-local org-roam-directory
                       (locate-dominating-file default-directory ".dir-locals.el"))
           (setq-local org-roam-db-location
                       (concat org-roam-directory "org-roam.db")))
     (eval setq-local org-roam-db-location
           (expand-file-name "org-roam.db" org-roam-directory))
     (eval setq-local org-roam-directory
           (expand-file-name
            (locate-dominating-file default-directory ".dir-locals.el")))))
 '(save-place t nil (saveplace))
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(tramp-default-method "ssh")
 '(warning-suppress-types '((comp))))

(server-start)

(add-to-list 'load-path (expand-file-name "~/emacs.d/"))
(require 'base)
(require 'base-extensions)
(require 'setup-helm)
(use-package ycmd)
(require 'init-dired)
(require 'init-web)
(require 'init-php)
(require 'init-python)
(require 'init-org)

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
    helm-swoop
    helm-descbinds
    ;; function-args
    clean-aindent-mode
    comment-dwim-2
    dtrt-indent
    ws-butler
    sr-speedbar
    iedit

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


;(require 'setup-helm-gtags)
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
;(require 'smartparens-config)
;(setq sp-base-key-bindings 'paredit)
;(setq sp-autoskip-closing-pair 'always)
;(setq sp-hybrid-kill-entire-symbol nil)
;(sp-use-paredit-bindings)

;(show-smartparens-global-mode +1)
;(smartparens-global-mode 1)

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
(column-number-mode 1)

(use-package yaml-mode
  :mode ("\\.yml$" . yaml-mode))

(use-package popwin
  :config (popwin-mode 1))
(use-package windmove
  :config (windmove-default-keybindings 'shift))

(use-package smart-mode-line
  :ensure t
  :config
  (setq sml/name-width 20)
  (setq sml/mode-width 'full)
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
(use-package company-ycmd
  :init
  (company-ycmd-setup)
)

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

;(require 'albin-music-mode)



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
;; Configure Elfeed with org mode
(use-package elfeed-org
  :ensure t
  :config
  (setq elfeed-show-entry-switch 'display-buffer)
  (setq rmh-elfeed-org-files (list "~/workspace/.dotfiles/elfeed.org"))
  (elfeed-org))

(use-package elfeed-web
  :ensure t)

(setq holiday-bahai-holidays nil)
(setq holiday-hebrew-holidays nil)
(setq holiday-islamic-holidays nil)
(setq org-agenda-span 10)
(require 'cal-china-x)
(setq mark-holidays-in-calendar t)
(setq cal-china-x-important-holidayxs cal-china-x-chinese-holidays)
(setq calendar-holidays cal-china-x-important-holidays)
(defun my/fix-inline-images ()
  (when org-inline-image-overlays
    (org-redisplay-inline-images)))
(add-hook 'org-babel-after-execute-hook 'my/fix-inline-images)
(setq httpd-port 8182)
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

(use-package jump-tree
  :config
  (setq global-jump-tree-mode t))
(setq browse-url-browser-function 'eww-browse-url)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-table ((t (:foreground "#6c71c4" :family "Ubuntu Mono")))))

(setq elfeed-use-curl nil)

(use-package md4rd)
(setq md4rd-subs-active '(lisp+Common_Lisp emacs prolog ripple))
(setq x-wait-for-event-timeout nil)
(server-start)
