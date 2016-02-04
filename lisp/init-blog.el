(require 'ox-publish)

;; http://orgmode.org/manual/Export-settings.html
;; 禁止下划线转义，在每个org文件头加上 #+OPTIONS: ^:nil 或者使用下面命令全局控制
(setq org-export-with-sub-superscripts nil)
(setq org-export-with-author nil)

;; http://orgmode.org/worg/org-tutorials/org-publish-html-tutorial.html
(setq org-publish-project-alist
      '(
		("blog-index"
         :base-directory "~/Dropbox/blog/notes/"
         :base-extension "org"
         :include ("index.org")
         :publishing-directory "~/Dropbox/blog/"
         :recursive t
         :publishing-function org-html-publish-to-html
         :headline-levels 4 ; Just the default for this project.
         :auto-preamble t
         :auto-sitemap t ; Generate sitemap.org automagically...
         :sitemap-filename "sitemap.org"
         :sitemap-title "Sitemap" ; ... with title 'Sitemap'.
         :sitemap-sort-files anti-chronologically
         :sitemap-file-entry-format "%d %t"
         :html-postamble "<p class=\"postamble\">Last Updated %C.</p>"
         :html-head "<link rel=\"stylesheet\" type=\"text/css\" href=\"css/worg.css\"/>"
         :style-include-default nil ;禁用默认 css 样式,使用自定义css
         )
		("blog-notes"
         :base-directory "~/Dropbox/blog/notes/"
         :base-extension "org"
         :exclude "index.org"
         :publishing-directory "~/Dropbox/blog/"
         :recursive t
         :publishing-function org-html-publish-to-html
         :headline-levels 4 ; Just the default for this project.
         :auto-preamble t
         :auto-sitemap t ; Generate sitemap.org automagically...
         :sitemap-filename "sitemap.org"
         :sitemap-title "Sitemap" ; ... with title 'Sitemap'.
         :sitemap-sort-files anti-chronologically
         :sitemap-file-entry-format "%d %t"
         :html-postamble "<p class=\"postamble\">Last Updated %C.</p>"
         :html-head "<link rel=\"stylesheet\" type=\"text/css\" href=\"css/worg.css\"/>"
         :style-include-default nil ;禁用默认 css 样式,使用自定义css
         ;; :html-preamble "<p class=\"preamble\"><h2><a href=\"index.html\">返回主页</a></h2></p>"
         :html-preamble "<h2><a href=\"index.html\">返回主页</a></h2>"
         )
        ("blog-static"
         :base-directory "~/Dropbox/blog/notes"
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
         :publishing-directory "~/Dropbox/blog/"
         :recursive t
         :publishing-function org-publish-attachment )
        ("blog" :components ("blog-index" "blog-notes" "blog-static"))
        ))
(provide 'init-blog)
