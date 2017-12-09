;; (use-package php-extras
;;  :ensure t
;;  :commands php-mode)

(use-package php-mode
  :ensure t
  :bind ("C--" . cmack/php-quick-arrow)
  :mode "\\.php[345]?\\'"
  :config
  (defun cmack/php-quick-arrow ()
    "Inserts -> at point"
    (interactive)
    (insert "->"))

  (defun cmack/php-mode-hook ()
    (emmet-mode 1)
    (flycheck-mode 1)
    ;; (ggtags-mode 1)
    (turn-on-auto-fill)
    (electric-indent-mode)
    (electric-pair-mode)
    (electric-layout-mode)

    ;; Experiment with highlighting keys in assoc. arrays
    (font-lock-add-keywords
     'php-mode
     '(("\\s\"\\([^\s;]+\\)\\s\"\\s-+=>\\s-+" 1 'font-lock-variable-name-face t))))

  (setq php-executable "/usr/bin/php")
  (setq php-mode-coding-style 'psr2)
  (setq tab-width 4
        fill-column 119
        indent-tabs-mode nil)

  (add-hook 'php-mode-hook #'cmack/php-mode-hook))

(unless (package-installed-p 'ac-php )
  (package-refresh-contents)
  (package-install 'ac-php ))

(require 'cl)
(require 'php-mode)
(use-package php-extras :ensure t)

(use-package auto-complete
  :ensure t
  :demand
  :config
  (ac-config-default)
  (ac-flyspell-workaround)
  (use-package fuzzy
    :config
    (setq ac-fuzzy-enable 1 )
    )
  )

(add-hook 'php-mode-hook
          '(lambda ()
             (auto-complete-mode t)
             (require 'ac-php)
             (setq ac-sources  '(ac-source-php ) )
             (yas-global-mode 1)
             (define-key php-mode-map  (kbd "C-]") 'ac-php-find-symbol-at-point)   ;goto define
             (define-key php-mode-map  (kbd "C-t") 'ac-php-location-stack-back   ) ;go back
             ))

;;(add-hook 'php-mode-hook
;;         '(lambda ()
;;           (require 'company-php)
;;          (company-mode t)
;;         (add-to-list 'company-backends 'company-ac-php-backend )))
(provide 'init-php)
