(require 'clang-format)
(custom-set-variables
 '(clang-format-style "{BasedOnStyle: Google, IndentWidth: 4, ColumnLimit: 120}"))

;; cpplint.sh content is
;; cpplint.py --linelength=120 "$@"
(custom-set-variables
 '(flymake-google-cpplint-command "cpplint.sh")
 )

(eval-after-load 'flymake-google-cpplint '(require 'flymake-cursor))

(provide 'init-clang-format)
