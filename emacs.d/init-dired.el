(use-package dired+
  :ensure t
  :defer t
  :config
  (progn
    (defun file-delete-trailing-whitespace (file-path)
      "Removes trailing whitespace from file at FILE-PATH."
      (with-temp-file file-path
        (insert-file-contents file-path)
        (delete-trailing-whitespace 1 nil)))

    (defun dired-bulk-delete-trailing-whitespace ()
      "Removes trailing whitespace from all files marked."
      (interactive)
      (mapc 'file-delete-trailing-whitespace (dired-get-marked-files)))))

(use-package dired-subtree :ensure t
  :after dired
  :config
  (bind-key "<tab>" #'dired-subtree-toggle dired-mode-map)
  (bind-key "<backtab>" #'dired-subtree-cycle dired-mode-map))
(add-hook 'dired-mode-hook 'hl-line-mode)
;;preview files in dired
(use-package peep-dired
  :ensure t
  :defer t ; don't access `dired-mode-map' until `peep-dired' is loaded
  :bind (:map dired-mode-map
              ("P" . peep-dired)))
(setq dired-dwim-target t)
(defun dired-open-file ()
  "In dired, open the file named on this line."
  (interactive)
  (let* ((file (dired-get-filename nil t)))
    (message "Opening %s..." file)
    (call-process "gnome-open" nil 0 nil file)
    (message "Opening %s done" file)))


(with-eval-after-load 'dired
(define-key dired-mode-map (kbd "C-c o") 'dired-open-file)  
(define-key dired-mode-map [s-return] 'sudo-edit-current-file)
)

(defun sudo-edit-current-file ()
  (interactive)
  (let ((my-file-name) ; fill this with the file to open
        (position))    ; if the file is already open save position
    (if (equal major-mode 'dired-mode) ; test if we are in dired-mode
        (progn
          (setq my-file-name (dired-get-file-for-visit))
          (find-alternate-file (prepare-tramp-sudo-string my-file-name)))
      (setq my-file-name (buffer-file-name); hopefully anything else is an already opened file
            position (point))
      (find-alternate-file (prepare-tramp-sudo-string my-file-name))
      (goto-char position))))

(provide 'init-dired)
