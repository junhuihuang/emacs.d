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
(setq tags-table-list '("~/bemetoy_svn/BemeNew/poppy/BemetoyServer/common/TAGS" "~/bemetoy_svn/BemeNew/poppy/common/TAGS"))
(setq tags-table-list '("~/Dropbox/project/bemetoy_svn/BemeNew/poppy/BemetoyServer/common/TAGS" "~/Dropbox/project/bemetoy_svn/BemeNew/poppy/common/TAGS")))

(provide 'init-ctags)
