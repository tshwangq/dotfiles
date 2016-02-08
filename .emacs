(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default)))
 '(save-place t nil (saveplace))
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(debug-on-error t)
 '(initial-frame-alist (quote ((fullscreen . maximized)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(menu-bar-mode 0)
(tool-bar-mode 0)


(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)


(eval-after-load 'php-mode
  '(require 'php-ext))

(load-theme 'solarized-light)

; Load the default configuration
(require 'auto-complete-config)
; Make sure we can find the dictionaries
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
; Use dictionaries by default
(setq-default ac-sources (add-to-list 'ac-sources 'ac-source-dictionary))
(global-auto-complete-mode t)
; Start auto-completion after 2 characters of a word
(setq ac-auto-start 2)
; case sensitivity is important when finding matches
(setq ac-ignore-case nil)


;; Load the library
(require 'yasnippet)
;; Let's have snippets in the auto-complete dropdown
(add-to-list 'ac-sources 'ac-source-yasnippet)
;(yas-global-mode 1)


;;;
;;; Org Mode
;;;
;;
;; Standard key bindings
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

;; The following lines are always needed. Choose your own keys.
(add-hook 'org-mode-hook 'turn-on-font-lock) ; not needed when global-font-lock-mode is on
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
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
    '((sequence "TODO(t!)" "NEXT(n)" "WAITTING(w)" "SOMEDAY(s)" "|" "DONE(d@/!)" "ABORT(a@/!)")
     ))  

(setq org-directory "~/workspace/gtd") 
(setq org-remember-templates 
      '(("New" ?n "* %? %t \n %i\n %a" "~/workspace/gtd/journal.org" ) 
	("Task" ?t "** TODO %?\n %i\n %a" "~/workspace/gtd/gtd.org" "Tasks") 
	("Calendar" ?c "** TODO %?\n %i\n %a" "~/workspace/gtd/gtd.org" "Tasks") 
	("Todo" ?t "* TODO %^{Brief Description} %^g\n%?\nAdded: %U" "~/workspace/gtd.org" "Tasks") 
	("Idea" ?i "** %?\n %i\n %a" "~/workspace/gtd/someday.org" "Ideas") 
	("Note" ?r "* %?\n %i\n %a" "~/workspace/gtd/journal.org" ) 
 ("Daily Review" ?a "** %t :COACH: \n%[~/workspace/gtd/.daily_review.txt]\n" 
    "~/workspace/journal.org")
 ("Daily Baby Review" ?b "** %t :Daily: \n%[~/workspace/gtd/.daily_baby_review.txt]\n" 
    "~/workspace/baby.org")
	("Project" ?p "** %?\n %i\n %a" "~/workspace/gtd/gtd.org" %g) )) 

(setq org-default-notes-file (concat org-directory "journal.org"))

(setq org-agenda-files (list "~/workspace/gtd/gtd.org"
                     "~/workspace/gtd/journal.org"
                     "~/workspace/gtd/birthday.org"
	         "~/workspace/gtd/someday.org"))

(setq org-agenda-custom-commands
'(("k" "work haha"
((agenda "")
(tags-todo "work")
(tags-todo "支持")))))
(add-to-list 'load-path "~/org-8.3.3/contrib/lisp" t)
(require 'ox-taskjuggler)
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

;(setq url-proxy-services '(("no_proxy" . "work\\.com")
;                           ("http" . "127.0.0.1:8123")))

(setq browse-url-browser-function 'w3m-goto-url-new-session)
(setq w3m-user-agent "Mozilla/5.0 (Linux; U; Android 2.3.3; zh-tw; HTC_Pyramid Build/GRI40) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.")
(defun hn ()
  (interactive)
  (browse-url "http://news.ycombinator.com"))

(defun toggle-env-http-proxy ()
  "set/unset the environment variable http_proxy which w3m uses"
  (interactive)
  (let ((proxy "http://127.0.0.1:8123"))
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
