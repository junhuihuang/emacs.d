;; Don't ask before rereading the TAGS files if they have changed
(setq tags-revert-without-query t)
;; Do case-sensitive tag searches
(setq tags-case-fold-search nil) ;; t=case-insensitive, nil=case-sensitive
;; Don't warn when TAGS files are large
(setq large-file-warning-threshold nil)

(if *is-a-mac*
  ; Mac's default ctags does not support -e option
  ; If you install Emacs by homebrew, another version of etags is already installed which does not need -e too
  ;; the best option is to install latest ctags from sf.net
  (setq ctags-command "/usr/local/bin/ctags -e -R "))

;; {{ etags-select
(autoload 'etags-select-find-tag-at-point "etags-select" "" t nil)
(autoload 'etags-select-find-tag "etags-select" "" t nil)
;; }}

;; stevens
;; http://blog.binchen.org/posts/how-to-use-ctags-in-emacs-effectively-3.html
(if (file-exists-p (expand-file-name "~/bemetoy_svn/BemeNew/poppy/BemetoyServer"))
(setq tags-table-list '("~/bemetoy_svn/BemeNew/poppy/BemetoyServer/common/TAGS" "~/bemetoy_svn/BemeNew/poppy/common/TAGS" "~/bemetoy_svn/BemeNew/poppy/BemetoyServer/proto/TAGS")))


;; stevens
;; https://www.emacswiki.org/emacs/EmacsTags#toc2
;;; View tags other window
(defun view-tag-other-window (tagname &optional next-p regexp-p)
  "Same as `find-tag-other-window' but doesn't move the point"
  (interactive (find-tag-interactive "View tag other window: "))
  (let ((window (get-buffer-window)))
    (find-tag-other-window tagname next-p regexp-p)
    (recenter 0)
    (select-window window)))

(defun view-tag-other-window-at-point (&optional next-p regexp-p)
  "Same as `find-tag-other-window' but doesn't move the point"
  (interactive)
  (let ((window (get-buffer-window)))
    (find-tag-other-window (thing-at-point 'symbol) next-p regexp-p)
    (recenter 0)
    (select-window window)))

(provide 'init-ctags)
