;;; init-org.el --- Qun's org-mode configuation

;; Copyright (c) 2017, Qun Wang

;; Author: Qun Wang <tshwangq@gmail.com>
;; Version: 0.0.1

;;; Commentary:

;; my personal org mode configuration

;;; License:

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:
;;;
;;; Org Mode
;;;
;;
;; Standard key bindings
(use-package org
  :ensure t
  :defer t
  :ensure org-plus-contrib
  :init
  (setq org-replace-disputed-keys t
        org-default-notes-file (expand-file-name "notes.org" (getenv "HOME")))
  :bind (("C-c l" . org-store-link)
         ("C-c a" . org-agenda)
         ("C-c b" . org-iswitchb)
         ("C-c c" . org-capture)
         ("C-c M-p" . org-babel-previous-src-block)
         ("C-c M-n" . org-babel-next-src-block)
         ("C-c S" . org-babel-previous-src-block)
         ("C-c s" . org-babel-next-src-block))
  :config
  (progn
    (setq org-highest-priority ?1)
    (setq org-default-priority ?2)
    (setq org-lowest-priority ?3)
    (setq org-confirm-babel-evaluate nil
          org-src-fontify-natively t
          org-src-tab-acts-natively t)
    ))

;; The following lines are always needed. Choose your own keys.
(add-hook 'org-mode-hook 'turn-on-font-lock) ; not needed when global-font-lock-mode is on
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
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
              (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING"))))


(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
              ("NEXT" :foreground "blue" :weight bold)
              ("DONE" :foreground "forest green" :weight bold)
              ("WAITING" :foreground "orange" :weight bold)
              ("HOLD" :foreground "magenta" :weight bold)
              ("CANCELLED" :foreground "forest green" :weight bold)
              ("MEETING" :foreground "forest green" :weight bold)
              ("PHONE" :foreground "forest green" :weight bold))))
(setq org-directory "~/workspace/workspace/")
(setq org-default-notes-file (concat org-directory "notes.org"))
(global-set-key (kbd "C-c c") 'org-capture)
(setq org-agenda-include-diary t)
;; Capture templates for: TODO tasks, Notes, appointments, phone calls, meetings, and org-protocol
(setq org-capture-templates
      (quote (("t" "todo" entry (file+headline "~/workspace/workspace/inbox.org" "Tasks")
               "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
              ("r" "respond" entry (file (concat org-directory "notes.org"))
               "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
              ("n" "note" entry (file (concat org-directory "notes.org"))
               "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
              ("j" "Journal" entry (file+datetree (concat org-directory "diary.org"))
               "* %?\n%U\n" :clock-in t :clock-resume t)
              ("w" "org-protocol" entry (file (concat org-directory "inbox.org"))
               "* TODO Review %c\n%U\n" :immediate-finish t)
              ("m" "Meeting" entry (file (concat org-directory "inbox.org"))
               "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t)
              ("p" "Phone call" entry (file (concat org-directory "inbox.org"))
               "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
              ("h" "Habit" entry (file (concat org-directory "inbox.org"))
               "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))

(setq org-agenda-files (list "~/workspace/workspace/gtd.org"
                             "~/workspace/workspace/inbox.org"
                             "~/workspace/workspace/journal.org"
                             "~/workspace/workspace/notes.org"
                             "~/workspace/workspace/dairy.org"
                             "~/workspace/workspace/finance.org"
                             "~/workspace/awesome-smoking/README.org"
                             ))

(setq org-refile-targets '((org-agenda-files :maxlevel . 3)))
(setq org-refile-use-outline-path 'file)
(setq org-outline-path-complete-in-steps nil)
(setq org-todo-keyword-faces
      '(("TODO" . org-warning) ("STARTED" . "red")
        ("CANCELED" . (:foreground "blue" :weight bold))))

(setq org-agenda-custom-commands
      '(("k" "work haha"
         ((agenda "")
          (tags-todo "work")
          (tags-todo "支持")))))
(add-to-list 'load-path "~/org-8.3.3/contrib/lisp" t)
                                        ;(require 'ox-taskjuggler)
(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)


(global-set-key (kbd "C-c o")
                (lambda () (interactive) (find-file "~/workspace/workspace/notes.org")))
(global-set-key (kbd "C-c g")
                (lambda () (interactive) (find-file "~/workspace/workspace/gtd.org")))


;; active Org-babel languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '(;; other Babel languages
   (plantuml . t)))
(use-package ob-plantuml
  :ensure nil
  :config
  (setq org-plantuml-jar-path "~/plantuml.jar"))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((sh         . t)
   (js         . t)
   (sql        . t)
   (emacs-lisp . t)
   (perl       . t)
   (scala      . t)
   (clojure    . t)
   (python     . t)
   (ruby       . t)
   (dot        . t)
   (css        . t)
   (plantuml   . t)))
(setq org-publish-project-alist
      '(("www"
         :base-directory "~/workspace/www/"
         :publishing-directory "~/public_html/"
         :publishing-function org-twbs-publish-to-html
         :with-sub-superscript nil
         )))
(defun my-org-publish-buffer ()
  (interactive)
  (save-buffer)
  (save-excursion (org-publish-current-file))
  (let* ((proj (org-publish-get-project-from-filename buffer-file-name))
         (proj-plist (cdr proj))
         (rel (file-relative-name buffer-file-name
                                  (plist-get proj-plist :base-directory)))
         (dest (plist-get proj-plist :publishing-directory)))
    (browse-url (concat "file://"
                        (file-name-as-directory (expand-file-name dest))
                        (file-name-sans-extension rel)
                        ".html"))))
(setq org-agenda-custom-commands
      '(("h" "Daily habits"
         ((agenda ""))
         ((org-agenda-show-log t)
          (org-agenda-ndays 7)
          (org-agenda-log-mode-items '(state))
          (org-agenda-skip-function '(org-agenda-skip-entry-if 'notregexp ":smoking:"))))
        ;; other commands here
        ))
(add-to-list 'org-modules 'org-habit)


(require 'org-habit)

;;;###autoload(require 'init-org)
(provide 'init-org)

;; Local Variables:
;; coding: utf-8-unix
;; End:

;;; init-org.el ends here
