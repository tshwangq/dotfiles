(use-package haml-mode :ensure t :defer t)
(use-package restclient :ensure t :defer t)
(use-package scss-mode
  :ensure t
  :mode "\\.scss\\'"
  :config
  (setq scss-compile-at-save nil))
(use-package sass-mode
  :disabled t
  :ensure t
  :mode "\\.scss\\'")
(use-package markdown-mode
  :ensure t
  :mode "\\.md\\'")
(use-package emmet-mode
  :ensure t
  :commands emmet-mode
  :config
  (add-hook 'web-mode-hook #'emmet-mode)
  (add-hook 'html-mode-hook #'emmet-mode))
(use-package web-mode
  :ensure t
  :commands web-mode
  :mode ("\\.hbs\\'"
         "\\.jsx\\'"
         "\\.vue\\'"
         "/\\([Vv]iews\\|[Hh]tml\\|[Vv]ue\\|[Tt]emplates\\)/.*\\.php\\'")
  :config
  (setq sgml-basic-offset 4)
  (setq indent-tabs-mode t
        tab-width 4
        web-mode-code-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-markup-indent-offset 4)

  (subword-mode)
  (emmet-mode)
  (add-hook 'before-save-hook 'delete-trailing-whitespace)

  (add-hook 'web-mode-before-auto-complete-hooks
            '(lambda ()
               (let ((web-mode-cur-language (web-mode-language-at-pos)))
                 (if (string= web-mode-cur-language "php")
                     (yas-activate-extra-mode 'php-mode)
                   (yas-deactivate-extra-mode 'php-mode))
                 (if (string= web-mode-cur-language "javascript")
                     (yas-activate-extra-mode 'js2-mode)
                   (yas-deactivate-extra-mode 'js2-mode))
                 (if (string= web-mode-cur-language "css")
                     (setq emmet-use-css-transform t)
                   (setq emmet-use-css-transform nil)))))

(add-hook 'html-mode-hook 'web-mode))

(use-package tagedit
  :ensure t
  :commands tagedit-mode
  :config
  (tagedit-add-paredit-like-keybindings)

  (add-hook 'sgml-mode-hook 'tagedit-mode)
  (add-hook 'html-mode-hook 'tagedit-mode)
  ;; (add-hook 'web-mode-hook 'tagedit-mode)
  )


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
(add-hook 'js2-mode-hook (lambda () (tern-mode t)(company-mode t)))
                                        ;(setq tern-command (cons (executable-find "tern") '()))
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
;; Better imenu
(add-hook 'js2-mode-hook #'js2-imenu-extras-mode)
(use-package color-identifiers-mode
  :ensure t
  :init
  (add-hook 'js2-mode-hook 'color-identifiers-mode))

(use-package js2-refactor
  :ensure t
  :init   (add-hook 'js2-mode-hook 'js2-refactor-mode)
  :config (js2r-add-keybindings-with-prefix "C-c ."))

(use-package xref-js2
  :ensure t
  :init (add-hook 'js2-mode-hook (lambda ()
                                   (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t))))


(js2r-add-keybindings-with-prefix "C-c C-r")
(define-key js2-mode-map (kbd "C-k") #'js2r-kill)

;; js-mode (which js2 is based on) binds "M-." which conflicts with xref, so
;; unbind it.
(define-key js-mode-map (kbd "M-.") nil)

(add-hook 'js2-mode-hook (lambda ()
                           (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t)))

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
(require 'company-tern)
(define-key tern-mode-keymap (kbd "M-.") nil)
(define-key tern-mode-keymap (kbd "M-,") nil)


(use-package css-mode
  :commands css-mode
  :init
  (setq css-indent-offset 2)
  :config
  (use-package rainbow-mode
    :init
    (dolist (hook '(css-mode-hook html-mode-hook sass-mode-hook))
      (add-hook hook 'rainbow-mode)))

  (use-package css-eldoc))

(provide 'init-web)
