;;; base-extensions.el --- basice extension configuration

;; Copyright (C) 2018, tshwangq

;; Author: Qun Wang <tshwangq@gmail.com>
;; Keywords: configuration
;; Version: 1.0.0

;;; Commentary:

;; basic extension

;;; Code:

(use-package company-quickhelp :ensure)

(use-package company-lsp
  :ensure
  :config
  ;; 开启yasnippet支持
;;  (push 'company-lsp company-backends)
  (setq company-lsp-enable-snippet t))

(use-package company
  :ensure t
  :commands company-mode
  :config
  (setq company-minimum-prefix-length 2)
  (setq company-dabbrev-downcase nil)
  (setq company-tooltip-limit 5200)
  (setq company-idle-delay 0.2)
  (setq company-echo-delay 0)
  (setq company-begin-commands '(self-insert-command))
  (setq company-require-match nil)
  (add-hook 'company-mode-hook 'company-quickhelp-mode)
  (add-hook 'after-init-hook 'global-company-mode)  )

(use-package company-lsp
  :ensure t
  :after (company lsp-mode)
  :config
  (add-to-list 'company-backends 'company-lsp)
  :bind (("C-c C-y" . company-yasnippet)
         :map company-active-map
         ("C-n" . company-select-next)
         ("C-p" . company-select-previous))
  :custom
  (company-lsp-async t)
  (company-lsp-enable-snippet t))

(use-package dashboard
  :config
  (setq dashboard-items '((recents  . 30)
                          (bookmarks . 5)
                          (projects . 15)
                          (agenda . 5)))
  (dashboard-setup-startup-hook))


(require 'ediff)
  (setq ediff-window-setup-function 'ediff-setup-windows-plain)
  (setq-default ediff-highlight-all-diffs 'nil)
  (setq ediff-diff-options "-w")


(use-package expand-region
  :config
  (global-set-key (kbd "C-~") 'er/expand-region)
  )

(require 'flyspell)
(dolist (hook '(text-mode-hook))
  (add-hook hook (lambda () (flyspell-mode 1))))
    ;; Enable spell check in program comments
    (add-hook 'prog-mode-hook 'flyspell-prog-mode)
    ;; Enable spell check in plain text / org-mode
    (add-hook 'text-mode-hook 'flyspell-mode)
    (add-hook 'org-mode-hook 'flyspell-mode)
    (setq flyspell-issue-welcome-flag nil)
    (setq flyspell-issue-message-flag nil)
    ;; ignore repeated words
    (setq flyspell-mark-duplications-flag nil)
    (setq-default ispell-list-command "list")
    (setq ispell-extra-args '("--sug-mode=ultra" "--lang=en_US"))
    ;; Make spell check on right click.
    (define-key flyspell-mouse-map [down-mouse-3] 'flyspell-correct-word)
    (define-key flyspell-mouse-map [mouse-3] 'undefined)
    (define-key flyspell-mode-map (kbd "C-;") nil)

(use-package flycheck-package)

(use-package flycheck
  :ensure t
  :diminish flycheck-mode
  :init  (global-flycheck-mode)
  :config
  ;; disable jshint since we prefer eslint checking
  (setq-default flycheck-disabled-checkers
                (append flycheck-disabled-checkers
                        '(javascript-jshint)))
                                        ; (setq flycheck-checkers '(javascript-eslint))
  (setq flycheck-eslint-eslintrc "~/.eslintrc")
  ;; use eslint with web-mode for jsx files
  (flycheck-add-mode 'javascript-eslint 'web-mode)
  (flycheck-add-mode 'javascript-eslint 'js2-mode)
  (flycheck-add-mode 'javascript-eslint 'js-mode)
  ;; disable json-jsonlist checking for json files
  (setq-default flycheck-disabled-checkers
                (append flycheck-disabled-checkers
                        '(json-jsonlist)))
)

(add-hook 'after-init-hook #'global-flycheck-mode)

(use-package magit
  :config
  :bind
  ;; Magic
  ("C-x g s" . magit-status)
  ("C-x g x" . magit-checkout)
  ("C-x g c" . magit-commit)
  ("C-x g p" . magit-push)
  ("C-x g u" . magit-pull)
  ("C-x g e" . magit-ediff-resolve)
  ("C-x g r" . magit-rebase-interactive))

(use-package magit-popup)
(use-package youdao-dictionary)
(use-package multiple-cursors
  :bind
  ("C-S-c C-S-c" . mc/edit-lines)
  ("C->" . mc/mark-next-like-this)
  ("C-<" . mc/mark-previous-like-this)
  ("C-c C->" . mc/mark-all-like-this))

(setq magit-repository-directories `("~/workspace", user-emacs-directory))


(use-package undo-tree
  :config
  ;; Remember undo history
  (global-undo-tree-mode 1))


;; Jump to things in Emacs tree-style
(use-package avy
  :bind (("C-:" . avy-goto-char)
         ("C-'" . avy-goto-char-2)
         ("M-g f" . avy-goto-line)
         ("M-g w" . avy-goto-word-1)
         ("M-g e" . avy-goto-word-0))
  :init (add-hook 'after-init-hook 'avy-setup-default)
  :config (setq avy-background t))

;; Kill text between the point and the character CHAR
(use-package avy-zap
  :bind (("M-z" . avy-zap-to-char-dwim)
         ("M-Z" . avy-zap-up-to-char-dwim)))

;; Quickly follow links
(use-package ace-link
  :bind (("M-o" . ace-link-addr))
  :init (add-hook 'after-init-hook 'ace-link-setup-default))

;; Jump to Chinese characters
(use-package ace-pinyin
  :diminish ace-pinyin-mode
  :init)
(use-package helm-dictionary)
(provide 'base-extensions)
