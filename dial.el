;;; dial.el --- Busy now? Do it all later

;;; Commentary:
;; An Emacs package for storing media that you want to read, watch, and more at a better time.

;;; Code:
(defvar dial-dials '())

(defun www-get-page-title (url)
  "Get the page title from URL.
Code from https://lists.gnu.org/archive/html/help-gnu-emacs/2010-07/msg00291.html"
  (let ((title))
    (with-current-buffer (url-retrieve-synchronously url)
      (goto-char (point-min))
      (re-search-forward "<title>\\([^<]*\\)</title>" nil t 1)
      (setq title (match-string 1))
      (goto-char (point-min))
      (re-search-forward "charset=\\([-0-9a-zA-Z]*\\)" nil t 1)
      (decode-coding-string title (intern (match-string 1))))))

;;;###autoload
(defun dial-in ()
  "Insert a link to dial."
  (interactive)
  (let* ((link (read-string "Link: "))
	 (dial (list (www-get-page-title link) link)))
    (setq dial-dials (cons dial dial-dials))))

(defun dial-insert-list ()
  "Insert helper."
  (insert "\n")
  (let ((lists dial-dials))
    (while lists
      (let* ((list (car lists))
	     (title (car list))
	     (link (nth 1 list)))
	(insert
	 (propertize title 'font-lock-face '(:foreground "white"))
	 " - "
	 (propertize link 'font-lock-face '(:foreground "cadet blue"))
	 "\n"
	 "\n")
      (setq lists (cdr lists))))))

;;;###autoload
(defun dial-list ()
  "List out the dials."
  (interactive)
  (let ((temp-buffer-show-hook 'dial-insert-list))
    (with-output-to-temp-buffer "Dial List")))



;;; Provide:
(provide 'dial)
;;; dial.el ends here
