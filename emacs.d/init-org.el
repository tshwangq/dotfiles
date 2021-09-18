;;; init-org.el --- Qun's org-mode configuation

;; Copyright (c) 2017, 2020 Qun Wang

;; Author: Qun Wang <tshwangq@gmail.com>
;; Version: 0.0.2

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
  :ensure org-plus-contrib
  :defer t
;  :ensure org-plus-contrib
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
(setq Tex-auto-save t) ;I forget what these do, I've
(setq TeX-parse-self t) ;always had them
                                        ;(require 'tex-mik)
                                        ;(load "auctex.el" nil t t) ;Now necessary with latest
                                        ;version of AucTeX
(setq org-export-with-LaTeX-fragments "dvipng") ;Now necessary with
                                        ;orgmove version 7.4
                                        ;or later
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-table ((t (:foreground "#6c71c4" :family "Ubuntu Mono"))))
 )

;; font config for org table showing.

;(set-default-font "monospace-11")

;(dolist (charset '(kana han symbol cjk-misc bopomofo))

 ; (set-fontset-font (frame-parameter nil 'font)
                    ;charset
                    ;(font-spec :family "WenQuanYi Micro Hei")))

;; tune rescale so that Chinese character width = 2 * English character width
;(setq face-font-rescale-alist '(("monospace" . 1.0) ("WenQuanYi" . 1.23)))

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
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)" "CANCELLED(c)")
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
(setq org-directory "~/workspace/workspace")
(setq org-default-notes-file (concat org-directory "notes.org"))
(global-set-key (kbd "C-c c") 'org-capture)

(require 'org-protocol)
(setq org-agenda-include-diary t)
;; Capture templates for: TODO tasks, Notes, appointments, phone calls, meetings, and org-protocol
(setq org-capture-templates
      (quote (
              ("d" "default" plain (function org-roam--capture-get-point)
               "%?"
               :file-name "%<%Y%m%d%H%M%S>-${slug}"
               :head "#+title: ${title}\n"
               :unnarrowed t)
	          ("p" "Protocol" entry (file+headline ,(concat org-directory "notes.org") "Inbox")
               "* %^{Title}\nSource: %u, %c\n #+BEGIN_QUOTE\n%i\n#+END_QUOTE\n\n\n%?")
	          ("L" "Protocol Link" entry (file+headline ,(concat org-directory "notes.org") "Inbox")
               "* %? [[%:link][%:description]] \nCaptured On: %U")
              ("t" "todo" entry (file+headline "~/workspace/workspace/inbox.org" "Tasks")
               "* TODO %?\n%U\n")
              ("T" "Tickler" entry
               (file+headline "~/gtd/tickler.org" "Tickler")
               "* %i%? \n %U")
              ("r" "respond" entry (file (concat org-directory "notes.org"))
               "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
              ("n" "note" entry (file (concat org-directory "notes.org"))
               "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
              ("j" "Journal" entry (file+datetree (concat org-directory "diary.org"))
               "* %?\n%U\n" :clock-in t :clock-resume t)
              ("w"   "Default template" entry (file+headline "~/capture.org" "Notes")
               "* %^{Title}\n\n  Source: %u, %c\n\n  %i"
               :empty-lines 1)
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
      '(("o" "At the office" tags-todo "@office"
         ((org-agenda-overriding-header "Office")))))
(setq org-agenda-custom-commands
      '(("k" "work haha"
         ((agenda "")
          (tags-todo "work")
          (tags-todo "支持")))))
(setq bh/hide-scheduled-and-waiting-next-tasks t)

(setq org-agenda-custom-commands
      '(("h" "Daily habits"
         ((agenda ""))
         ((org-agenda-show-log t)
          (org-agenda-ndays 7)
          (org-agenda-log-mode-items '(state))
          (org-agenda-skip-function '(org-agenda-skip-entry-if 'notregexp ":smoking:"))))
        ;; other commands here
        ))

;; Custom agenda command definitions
(setq org-agenda-custom-commands
      (quote (("N" "Notes" tags "NOTE"
               ((org-agenda-overriding-header "Notes")
                (org-tags-match-list-sublevels t)))
              ("h" "Habits" tags-todo "STYLE=\"habit\""
               ((org-agenda-overriding-header "Habits")
                (org-agenda-sorting-strategy
                 '(todo-state-down effort-up category-keep))))
              ("w" "Agenda"
               ((agenda "" nil)
                (tags "inbox"
                      ((org-agenda-overriding-header "Tasks to Refile")
                       (org-tags-match-list-sublevels 3)))
                (tags-todo "-CANCELLED/!"
                           ((org-agenda-overriding-header "Stuck Projects")
                            (org-agenda-skip-function 'bh/skip-non-stuck-projects)
                            (org-agenda-sorting-strategy
                             '(category-keep))))
                (tags-todo "-HOLD-CANCELLED/!"
                           ((org-agenda-overriding-header "Projects")
                            (org-agenda-skip-function 'bh/skip-non-projects)
                            (org-tags-match-list-sublevels 'indented)
                            (org-agenda-sorting-strategy
                             '(category-keep))))
                (tags-todo "-CANCELLED/!NEXT"
                           ((org-agenda-overriding-header (concat "Project Next Tasks"
                                                                  (if bh/hide-scheduled-and-waiting-next-tasks
                                                                      ""
                                                                    " (including WAITING and SCHEDULED tasks)")))
                            (org-agenda-skip-function 'bh/skip-projects-and-habits-and-single-tasks)
                            (org-tags-match-list-sublevels t)
                            (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-sorting-strategy
                             '(todo-state-down effort-up category-keep))))
                (tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
                           ((org-agenda-overriding-header (concat "Project Subtasks"
                                                                  (if bh/hide-scheduled-and-waiting-next-tasks
                                                                      ""
                                                                    " (including WAITING and SCHEDULED tasks)")))
                            (org-agenda-skip-function 'bh/skip-non-project-tasks)
                            (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-sorting-strategy
                             '(category-keep))))
                (tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
                           ((org-agenda-overriding-header (concat "Standalone Tasks"
                                                                  (if bh/hide-scheduled-and-waiting-next-tasks
                                                                      ""
                                                                    " (including WAITING and SCHEDULED tasks)")))
                            (org-agenda-skip-function 'bh/skip-project-tasks)
                            (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-sorting-strategy
                             '(category-keep))))
                (tags-todo "-CANCELLED+WAITING|HOLD/!"
                           ((org-agenda-overriding-header (concat "Waiting and Postponed Tasks"
                                                                  (if bh/hide-scheduled-and-waiting-next-tasks
                                                                      ""
                                                                    " (including WAITING and SCHEDULED tasks)")))
                            (org-agenda-skip-function 'bh/skip-non-tasks)
                            (org-tags-match-list-sublevels nil)
                            (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)))
                (tags "-REFILE/"
                      ((org-agenda-overriding-header "Tasks to Archive")
                       (org-agenda-skip-function 'bh/skip-non-archivable-tasks)
                       (org-tags-match-list-sublevels nil))))
               nil))))

(require 'ox-taskjuggler)
(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)

(global-set-key (kbd "C-c o")
                (lambda () (interactive) (find-file "~/workspace/workspace/notes.org")))
(global-set-key (kbd "C-c g")
                (lambda () (interactive) (find-file "~/workspace/workspace/gtd.org")))

(use-package ob-plantuml
  :ensure nil
  :config
  (setq org-plantuml-jar-path "~/plantuml.jar"))

;(use-package org-bullets
 ; :config
  ;(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
  ;)
(org-babel-do-load-languages
 'org-babel-load-languages
 '(
                                        ;(restclient . t)
   (shell         . t)
   (js         . t)
   (sql        . t)
   (emacs-lisp . t)
   (perl       . t)
   (redis      . t)
;   (scala      . t)
 ;  (clojure    . t)
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

(add-to-list 'org-modules 'org-habit)

(require 'ox-latex)
(add-to-list 'org-latex-classes
             '("ctexart"
               "\\documentclass[fontset=ubuntu,UTF8]{ctexart}
        \\usepackage{amsmath,latexsym,amssymb,mathrsfs,pifont}
        \\usepackage[T1]{fontenc}
        \\usepackage{fixltx2e}
        \\usepackage{graphicx}
        \\usepackage{subfig}
        \\usepackage{grffile}
        \\usepackage{longtable}
        \\usepackage{wrapfig}
        \\usepackage{rotating}
         \\usepackage[colorlinks=true]{hyperref}
        \\tolerance=1000
        [NO-DEFAULT-PACKAGES]
        [NO-PACKAGES]"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(setq org-latex-pdf-process
      '("xelatex -interaction nonstopmode %f"
        "xelatex -interaction nonstopmode %f")) ;; for multiple passes
(require 'org-habit)

(use-package org-roam
  :after org
  :init (setq org-roam-v2-ack t)
  :ensure t
  :hook
  (after-init . org-roam-mode)
  :custom
  (org-roam-directory "~/workspace/workspace")
  :config
  (org-roam-setup)
  :bind (:map org-roam-mode-map
              (("C-c n r" . org-roam-node-random)
               ("C-c n f" . org-roam-node-find)
               ("C-c n g" . org-roam-graph))
              :map org-mode-map
              (("C-c n i" . org-roam-insert))
              (("C-c n I" . org-roam-insert-immediate))))

(require 'org-roam-protocol)
(setq org-roam-capture-ref-templates
      '(("r" "ref" plain (function org-roam-capture--get-point)
         ""
         :file-name "${slug}"
         :head "#+title: ${title}\n#+roam_key: ${ref}\n"
         :unnarrowed t)))

(add-to-list 'org-roam-capture-ref-templates
             '("a" "Annotation" plain (function org-roam-capture--get-point)
               "%U ${body}\n"
               :file-name "${slug}"
               :head "#+title: ${title}\n#+roam_key: ${ref}\n#+roam_alias:\n"
               :immediate-finish t
               :unnarrowed t))

(use-package org-ref
    :config
    (setq
         org-ref-completion-library 'org-ref-ivy-cite
         org-ref-get-pdf-filename-function 'org-ref-get-pdf-filename-helm-bibtex
         org-ref-default-bibliography (list "~/workspace/workspace/init.bib")
         org-ref-bibliography-notes "~/workspace/workspace/bibnotes.org"
         org-ref-note-title-format "* TODO %y - %t\n :PROPERTIES:\n  :Custom_ID: %k\n  :NOTER_DOCUMENT: %F\n :ROAM_KEY: cite:%k\n  :AUTHOR: %9a\n  :JOURNAL: %j\n  :YEAR: %y\n  :VOLUME: %v\n  :PAGES: %p\n  :DOI: %D\n  :URL: %U\n :END:\n\n"
         org-ref-notes-directory "~/workspace/workspace/Notes/"
         org-ref-notes-function 'orb-edit-notes
         ))

(use-package nov
  :config
  (setq nov-text-width 80)
  (setq nov-text-width t)
  (setq visual-fill-column-center-text t)
  (add-hook 'nov-mode-hook 'visual-line-mode)
  (add-hook 'nov-mode-hook 'visual-fill-column-mode)
  )

(use-package deft
  :config
  (setq deft-directory org-directory
        deft-recursive t
        deft-strip-summary-regexp ":PROPERTIES:\n\\(.+\n\\)+:END:\n"
        deft-use-filename-as-title t)
  :bind
  ("C-c n d" . deft))

(add-to-list 'load-path "~/org-roam-ui")
(load-library "org-roam-ui")



;;;###autoload(require 'init-org)
(provide 'init-org)

;; Local Variables:
;; coding: utf-8-unix
;; End:

;;; init-org.el ends here
