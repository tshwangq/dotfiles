;;; phpcbf-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "phpcbf" "phpcbf.el" (0 0 0 0))
;;; Generated autoloads from phpcbf.el

(autoload 'phpcbf "phpcbf" "\
Format the current buffer according to the phpcbf.

\(fn)" t nil)

(autoload 'phpcbf-enable-on-save "phpcbf" "\
Run pbpcbf when this buffer is saved.

\(fn)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "phpcbf" '("phpcbf-")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; phpcbf-autoloads.el ends here
