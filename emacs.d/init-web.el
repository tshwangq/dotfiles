;;; package --- Summary
;;; Commentary:
;;; Code:

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
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init
  :config
  (add-hook 'markdown-mode-hook 'undo-tree-mode)
  )
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
        tab-width 2
        web-mode-code-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-markup-indent-offset 2)
	(setq javascript-indent-level 2)
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
                js2-auto-indent-p t
                js2-cleanup-whitespace t
                js2-enter-indents-newline t
                js2-indent-on-enter-key t
                js2-global-externs (list "window" "module" "require" "buster" "sinon" "assert" "refute" "setTimeout" "clearTimeout" "setInterval" "clearInterval" "location" "__dirname" "console" "JSON" "jQuery" "$")))
(setq js2-strict-missing-semi-warning nil)
(add-hook 'js2-mode-hook
          (lambda ()
            (push '("function" . ?ƒ) prettify-symbols-alist)))
;(add-hook 'js2-mode-hook (lambda () (tern-mode t)(company-mode t)))
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
;(add-hook 'web-mode-hook (lambda () (tern-mode t)))
;(add-to-list 'company-backends 'company-tern)
;(use-package company-tern)
;(define-key tern-mode-keymap (kbd "M-.") nil)
;(define-key tern-mode-keymap (kbd "M-,") nil)


(require 'css-mode)
  (setq css-indent-offset 2)
  (use-package rainbow-mode
    :init
    (dolist (hook '(css-mode-hook html-mode-hook sass-mode-hook))
      (add-hook hook 'rainbow-mode))

  (use-package css-eldoc))

(defun cesco/tide-checker ()

  (flycheck-def-option-var flycheck-typescript-tsconfig
      nil typescript-tslint-cesco
    "The path of tsconfig.json ."
    :type '(choice (const :tag "No custom tsconfig file" nil)
		   (directory :tag "Custom tsconfig.json"))
    :safe #'stringp
    :package-version '(flycheck . "27"))

  (flycheck-define-checker typescript-tslint-cesco
    "TypeScript style checker using TSLint."
    :command ("tslint" "--format" "json"
	      (config-file "--config" flycheck-typescript-tslint-config)
	      (config-file "--project" flycheck-typescript-tsconfig)
	      (option "--rules-dir" flycheck-typescript-tslint-rulesdir)
	      (eval flycheck-tslint-args)
	      source-inplace)
    :error-parser flycheck-parse-tslint
    :modes (typescript-mode web-mode))
  )

(defun cesco/custom-tslint ()
  (if (projectile-project-p)
      (progn
	(setq flycheck-tslint-args . ("--type-check"))
	(setq flycheck-typescript-tsconfig . ( (concat projectile-project-root "tsconfig.json" )))
	(flycheck-select-checker 'typescript-tslint-cesco))))


(defun cesco/tslint ()
  (setq flycheck-tslint-args . (nil))
  (flycheck-add-mode 'typescript-tslint 'web-mode)
  (flycheck-select-checker 'typescript-tslint)
  )

(defun cesco/tide-mode ()
  (interactive)
  (tide-setup)
  (cesco/custom-tslint)
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (add-hook 'before-save-hook 'tide-format-before-save)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (add-to-list 'company-backends '(company-tide :with company-yasnippet))
  )

(defun cesco/tide-evil ()
  (evil-leader/set-key-for-mode 'web-mode
    "j" (lambda () (interactive)(tide-jump-to-definition))
    )
  )


(use-package tide
  :diminish tide-mode
  :after (flycheck evil-leader)
  :config
  (cesco/tide-evil)
  (cesco/tide-checker)
  (add-hook 'typescript-mode-hook #'cesco/tide-mode) )

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (flycheck-add-next-checker 'javascript-eslint 'jsx-tide 'append)
  (flycheck-add-next-checker 'typescript-tide '(t . typescript-tslint) 'append)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; formats the buffer before saving
(add-hook 'before-save-hook 'tide-format-before-save)
(add-hook 'typescript-mode-hook #'setup-tide-mode)
(add-hook 'js2-mode-hook #'setup-tide-mode)

(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "jsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))
;; configure jsx-tide checker to run after your default jsx checker
(flycheck-add-mode 'javascript-eslint 'web-mode)


(use-package tide
  :ensure t
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)
         (before-save . tide-format-before-save)))

;; remove padding after script tag in vue mode
(defun maybe-use-twig-settings ()
  (when (and (buffer-file-name)
             (equal (file-name-extension (buffer-file-name)) "vue"))
    (setq web-mode-script-padding 0)))
(setq tide-format-options '(:insertSpaceAfterFunctionKeywordForAnonymousFunctions t :placeOpenBraceOnNewLineForFunctions nil :indentSize 2 :tabSize 2))
(add-hook 'web-mode-hook 'maybe-use-twig-settings)
(provide 'init-web)

;;; init-web ends here
