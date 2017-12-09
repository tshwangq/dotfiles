(use-package company
  :config
  (add-hook 'after-init-hook 'global-company-mode)
  (setq company-tooltip-limit 10)
  (setq company-idle-delay 0.5)
  (setq company-echo-delay 0)
  (setq company-begin-commands '(self-insert-command))
  (setq company-require-match nil))


(use-package dashboard
  :config
  (setq dashboard-items '((recents  . 30)
                          (bookmarks . 5)
                          (projects . 15)
                          (agenda . 5)))
  (dashboard-setup-startup-hook))


(use-package ediff
  :config
  (setq ediff-window-setup-function 'ediff-setup-windows-plain)
  (setq-default ediff-highlight-all-diffs 'nil)
  (setq ediff-diff-options "-w"))


(use-package expand-region
  :config
  (global-set-key (kbd "C-~") 'er/expand-region)
)
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
  :init (add-hook 'after-init-hook 'ace-pinyin-global-mode))

(provide 'base-extensions)
