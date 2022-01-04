(menu-bar-mode 0)
(tool-bar-mode 0)
(setq load-prefer-newer 0)

;; Core settings
;; UTF-8 please
(set-charset-priority 'unicode)
(setq locale-coding-system   'utf-8)   ; pretty
(set-terminal-coding-system  'utf-8)   ; pretty
(set-keyboard-coding-system  'utf-8)   ; pretty
(set-selection-coding-system 'utf-8)   ; please
(prefer-coding-system        'utf-8)   ; with sugar on top
(setq default-process-coding-system '(utf-8-unix . utf-8-unix))

(setq package-archives '(("gnu" . "http://elpa.emacs-china.org/gnu/")
                    ;   ("marmalade" . "http://elpa.emacs-china.org/marmalade/")
		       ;("org" . "http://elpa.emacs-china.org/org/")
                         ("melpa" . "http://elpa.emacs-china.org/melpa/")
                         ))

;(when (not package-archive-contents)
  ;(package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))


(eval-when-compile
  (require 'use-package))


;; Emacs customizations
(setq confirm-kill-emacs                  'y-or-n-p
      confirm-nonexistent-file-or-buffer  t
      save-interprogram-paste-before-kill t
      mouse-yank-at-point                 t
      require-final-newline               t
      visible-bell                        nil
      ring-bell-function                  'ignore
      ;; http://ergoemacs.org/emacs/emacs_stop_cursor_enter_prompt.html
      minibuffer-prompt-properties
      '(read-only t point-entered minibuffer-avoid-prompt face minibuffer-prompt)

      ;; Disable non selected window highlight
      cursor-in-non-selected-windows     nil
      highlight-nonselected-windows      nil
      ;; PATH
      exec-path                          (append exec-path '("/usr/local/bin/"))
      indent-tabs-mode                   nil
      inhibit-startup-message            t
      fringes-outside-margins            t
      x-select-enable-clipboard          t
      use-package-always-ensure          t)

(use-package solarized-theme
  :init
  (load-theme 'solarized-light)
  )

;; Use variable width font faces in current buffer
(defun my-buffer-face-mode-variable ()
  "Set font to a variable width (proportional) fonts in current buffer"
  (interactive)
  (setq buffer-face-mode-face '(:family "Symbola" :height 100 :width semi-condensed))
  (buffer-face-mode))

;; Use monospaced font faces in current buffer
(defun my-buffer-face-mode-fixed ()
  "Sets a fixed width (monospace) font in current buffer"
  (interactive)
  (setq buffer-face-mode-face '(:family "Consolas" :height 100))
  (buffer-face-mode))

;; Set default font faces for Info and ERC modes
;(add-hook 'erc-mode-hook 'my-buffer-face-mode-variable)
(add-hook 'w3m-mode-hook 'my-buffer-face-mode-fixed)

(use-package dumb-jump
  :bind (("M-g o" . dumb-jump-go-other-window)
         ("M-g j" . dumb-jump-go)
         ("M-g i" . dumb-jump-go-prompt)
         ("M-g x" . dumb-jump-go-prefer-external)
         ("M-g z" . dumb-jump-go-prefer-external-other-window))
  :config (setq dumb-jump-selector 'helm)
  :ensure)

;; Package: projejctile
(use-package projectile
  :ensure t
  :config
  (projectile-global-mode)
  ;; static string for mode-line to fix slow in tramp mode issue.
  (setq projectile-mode-line "Projectile")
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (setq projectile-enable-caching t)
  )

(use-package helm-projectile
  :ensure t
  :config
  (helm-projectile-on)
  (setq projectile-completion-system 'helm)
  (setq projectile-indexing-method 'alien)
  (setq projectile-switch-project-action 'helm-projectile)
  )


(use-package lsp-mode
  :ensure t
  :commands lsp
  ;; :disabled nil
  :config
  (add-hook 'lsp-after-open-hook 'lsp-enable-imenu)
  (setq lsp-response-timeout 25
        lsp-enable-flycheck t
        lsp-enable-eldoc t
        lsp-enable-completion-at-point t))

(use-package lsp-ui
  :ensure t
  :after lsp-mode
  :hook ((lsp-mode . lsp-ui-mode)))
(setq straight-disable-native-compile t)
(defvar comp-deferred-compilation-deny-list ())
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(use-package bug-hunter)

(provide 'base)
