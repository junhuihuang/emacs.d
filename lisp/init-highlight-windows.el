(require 'hi-lock)

;; list to store what had been highlighted
(defvar highlight-list* nil)

(defun unhighlight-all-of-a-window (win)
"Clear all highlight of current buffer, called by
`unhighlit-windows-all' when iterating all windows. When a
buffer is being burry, this funciton also will be called to
clear all highlight"
(select-window win)
(dolist (item highlight-list*)
(unhighlight-regexp (regexp-quote item))))

(defun unhighlit-windows-all ()
"Clear all highlights of all windows "
(interactive)
;; 1) walk all windows and unhighlight all
(walk-windows 'unhighlight-all-of-a-window)
;; 2) clear *highlight-list* to nil
(setq highlight-list* nil))

(defun highlight-windows-toogle ()
(interactive)
(let ((thing-to-highlight ; get what to search
(if (use-region-p) ; 1) region active, use region content
(buffer-substring-no-properties
(region-beginning) (region-end))
(if (thing-at-point 'symbol)
(buffer-substring-no-properties
(car (bounds-of-thing-at-point 'symbol))
(cdr (bounds-of-thing-at-point 'symbol)))))))
(if (stringp thing-to-highlight)
;; toogle highlight, 2 cases
;; 1) thing already unlighlight and stored in list, unhighight it
;; 2) new highlight, highlight it and add it to list
(if (member thing-to-highlight highlight-list*)
(progn ; 1)
;; 1.1) delete it from list
(setq highlight-list*
(delete thing-to-highlight highlight-list*))
;; 1.2) unhighlight it
(walk-windows
(lambda (win)
(select-window win)
(unhighlight-regexp
(regexp-quote thing-to-highlight)))))
(progn ; 2)
(push thing-to-highlight highlight-list*)
(walk-windows
(lambda (win)
(select-window win)
(highlight-regexp
(regexp-quote (car highlight-list*))))
'ignore-minibuffer)))
(message "No vaidate region, or no validate symbol under curosr!"))))

(provide 'init-highlight-windows)
