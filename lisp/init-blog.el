(require 'ox-publish)
;; http://orgmode.org/worg/org-tutorials/org-publish-html-tutorial.html
(setq org-publish-project-alist
      '(
		("blog-notes"
         :base-directory "~/Dropbox/blog/notes/"
         :base-extension "org"
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
         )
        ("blog-static"
         :base-directory "~/Dropbox/blog/notes/static"
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
         :publishing-directory "~/Dropbox/blog/"
         :recursive t
         :publishing-function org-publish-attachment )
        ("blog" :components ("blog-notes" "blog-static"))
        ))
(provide 'init-blog)
