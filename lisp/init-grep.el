;; https://github.com/yuandaxing/.emacs.d/blob/3976a0a7ee115a016e417085c669ad5b489d22be/lisp/init-grep.el
;; (setq-default grep-highlight-matches t
;;              grep-scroll-output t)

;; (when (executable-find "ag")
;;   (require-package 'ag)
;;   (require-package 'wgrep-ag)
;;   (setq-default ag-highlight-search t)
;;   (global-set-key (kbd "M-?") 'ag-project))

(add-hook 'after-init-hook
          (lambda ()
            (progn
              (add-to-list 'grep-files-aliases '("h" . "*.[ch] *.cpp *.hpp *.cc *.hxx *.cxx"))
              (add-to-list 'grep-files-aliases '("cc" . "*.[ch] *.cpp *.hpp *.cc *.hxx *.cxx"))
              (add-to-list 'grep-files-aliases '("cpp" . "*.[ch] *.cpp *.hpp *.cc *.hxx *.cxx")))))
(provide 'init-grep)
