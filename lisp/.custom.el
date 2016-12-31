;; http://blog.binchen.org/posts/how-to-use-ctags-in-emacs-effectively-3.html
(if (file-exists-p (expand-file-name "~/bemetoy_svn/BemeNew/poppy/BemetoyServer"))
(setq tags-table-list '("~/bemetoy_svn/BemeNew/poppy/BemetoyServer/common/TAGS" "~/bemetoy_svn/BemeNew/poppy/common/TAGS" "~/bemetoy_svn/BemeNew/poppy/BemetoyServer/proto/TAGS")))

;; http://blog.binchen.org/posts/emacs-as-c-ide-easy-way.html
;; Please note `file-truename' must be used!
(setenv "GTAGSLIBPATH" (concat
                        (file-truename "~/bemetoy_svn/BemeNew/poppy/common")
                        ":"
                        (file-truename "~/bemetoy_svn/BemeNew/poppy/BemetoyServer/common")))
(setenv "MAKEOBJDIRPREFIX" (file-truename "~/obj/"))
(setq company-backends '((company-dabbrev-code company-gtags)))

