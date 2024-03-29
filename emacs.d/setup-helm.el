(add-to-list 'load-path "~/emacs.d")

(use-package helm-flx
  :ensure t
  :init
  (setq helm-flx-for-helm-find-files nil)
  (helm-flx-mode 1))

(use-package helm
  :ensure helm
  :demand t
  :diminish helm-mode
  :bind (("M-x" . helm-M-x)
         ("C-M-z" . helm-resume)
         ("C-x C-f" . helm-find-files)
         ("C-x b" . helm-mini)
         ("C-c p o" . helm-occur)
         ("M-y" . helm-show-kill-ring)
         ("C-h a" . helm-apropos)
         ("C-h m" . helm-man-woman)
         ("C-h SPC" . helm-all-mark-rings)
         ("C-x C-i" . helm-semantic-or-imenu)
         ("C-x C-m" . helm-M-x)
         ("C-x C-b" . helm-buffers-list)
         ("C-c p g" . helm-google-suggest)
         ("C-c p p" . helm-projectile)
         ("C-c p f" . helm-projectile-find-file)
         ("C-c p n" . helm-do-ag-project-root)
         :map helm-map
         ("<tab>" . helm-execute-persistent-action)
         ("C-i"   . helm-execute-persistent-action)
         ("C-z"   . helm-select-action))
  :init
  :config
  (setq

   helm-split-window-in-side-p t
   helm-move-to-line-cycle-in-source t ; move to end or beginning of source when reaching top or bottom of source.
   helm-ff-search-library-in-sexp t ; search for library in `require' and `declare-function' sexp.
   helm-scroll-amount 4 ; scroll 4 lines other window using M-<next>/M-<prior>
   helm-split-window-default-side 'below
   helm-ff-file-name-history-use-recentf t
   helm-candidate-number-limit 500 ; limit the number of displayed canidates
   helm-buffers-fuzzy-matching t          ; fuzzy matching buffer names when non-nil
   helm-M-x-fuzzy-matching t
                                        ; useful in helm-mini that lists buffers
   helm-idle-delay 0.0
   helm-input-idle-delay 0.01
   helm-quick-update t
   helm-ff-skip-boring-files t)
  (helm-mode 1)
  (helm-autoresize-mode t))

(require 'helm-grep)

;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))

(define-key helm-grep-mode-map (kbd "<return>")  'helm-grep-mode-jump-other-window)
(define-key helm-grep-mode-map (kbd "n")  'helm-grep-mode-jump-other-window-forward)
(define-key helm-grep-mode-map (kbd "p")  'helm-grep-mode-jump-other-window-backward)

(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

(add-to-list 'helm-sources-using-default-as-input 'helm-source-man-pages)

; (global-set-key (kbd "C-c h C-c w") 'helm-wikipedia-suggest)
; (global-set-key (kbd "C-c h x") 'helm-register)
; (global-set-key (kbd "C-x r j") 'jump-to-register)

(define-key 'help-command (kbd "C-f") 'helm-apropos)
(define-key 'help-command (kbd "r") 'helm-info-emacs)
(define-key 'help-command (kbd "C-l") 'helm-locate-library)

;; use helm to list eshell history
(add-hook 'eshell-mode-hook
          #'(lambda ()
              (define-key eshell-mode-map (kbd "M-l")  'helm-eshell-history)))

;;; Save current position to mark ring
(add-hook 'helm-goto-line-before-hook 'helm-save-current-pos-to-mark-ring)

;; show minibuffer history with Helm
(define-key minibuffer-local-map (kbd "M-p") 'helm-minibuffer-history)
(define-key minibuffer-local-map (kbd "M-n") 'helm-minibuffer-history)

(define-key global-map [remap find-tag] 'helm-etags-select)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PACKAGE: helm-swoop                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Locate the helm-swoop folder to your path
(require 'helm-swoop)

;; Change the keybinds to whatever you like :)
;(global-set-key (kbd "C-c h o") 'helm-swoop)
(global-set-key (kbd "C-c s") 'helm-multi-swoop-all)

;; When doing isearch, hand the word over to helm-swoop
(define-key isearch-mode-map (kbd "M-i") 'helm-swoop-from-isearch)

;; From helm-swoop to helm-multi-swoop-all
(define-key helm-swoop-map (kbd "M-i") 'helm-multi-swoop-all-from-helm-swoop)

;; Save buffer when helm-multi-swoop-edit complete
(setq helm-multi-swoop-edit-save t)

;; If this value is t, split window inside the current window
(setq helm-swoop-split-with-multiple-windows t)

;; Split direcion. 'split-window-vertically or 'split-window-horizontally
(setq helm-swoop-split-direction 'split-window-vertically)

;; If nil, you can slightly boost invoke speed in exchange for text color
(setq helm-swoop-speed-or-color t)

(eval-after-load 'shell
  '(define-key shell-mode-map  (kbd "C-c C-l") 'helm-comint-input-ring)); [(\C-z)] 'clear-shell-buffer))
(add-hook 'shell-mode-hook 'my-shell-mode-hook)
(defun my-shell-mode-hook ()
  (setq comint-input-ring-file-name "~/.bash_eternal_history")  ;; or bash_history
  (comint-read-input-ring t))
(setq history-delete-duplicates t)
(setq
 helm-gtags-ignore-case t
 helm-gtags-auto-update t
 helm-gtags-use-input-at-cursor t
 helm-gtags-pulse-at-cursor t
 helm-gtags-prefix-key "\C-cg"
 helm-gtags-suggested-key-mapping t
 )
(require 'helm-descbinds)
(helm-descbinds-mode)
(use-package helm-comint
  :ensure t
)
(use-package helm-ag
  :ensure t
  :init
  (custom-set-variables
   '(helm-ag-base-command "rg --vimgrep --smart-case --no-heading --line-number"))
                                        :bind ("M-p s" . helm-do-ag-project-root))

(setq helm-mini-default-sources '(helm-source-buffers-list
                                  helm-source-recentf
                                  helm-source-bookmarks
                                  helm-source-buffer-not-found))
(require 'helm-shell-history)
(add-hook 'term-mode-hook (lambda () (define-key term-raw-map (kbd "C-r") 'helm-shell-history)))


(use-package helm-zhihu-daily
  :ensure t
  :config)

;(use-package docker-tramp
 ; :ensure t)

(use-package helm-tramp)
(provide 'setup-helm)
