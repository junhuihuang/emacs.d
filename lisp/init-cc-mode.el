(defun c-wx-lineup-topmost-intro-cont (langelem)
  (save-excursion
    (beginning-of-line)
    (if (re-search-forward "EVT_" (line-end-position) t)
      'c-basic-offset
      (c-lineup-topmost-intro-cont langelem))))


;; http://www.emacswiki.org/emacs/fic-mode.el
(defun turn-on-fic-mode ()
  "turn fic-mode on"
  (interactive)
  (fic-mode 1))

;C/C++ SECTION
(defun my-c-mode-hook ()
  (message "my-c-mode-hook called (buffer-file-name)=%s" (buffer-file-name))
  ;; @see http://stackoverflow.com/questions/3509919/ \
  ;; emacs-c-opening-corresponding-header-file
  (local-set-key (kbd "C-x C-o") 'ff-find-other-file)
  (local-set-key "\M-f" 'c-forward-into-nomenclature)
  (local-set-key "\M-b" 'c-backward-into-nomenclature)
  ;; stevens
  (setq cc-search-directories '("." "../*/src" "../*/source" "../*/include" "../*/inc" "/usr/include" "/usr/local/include/*" "$WXWIN/include"))
  (setq c-basic-offset 4)
  (setq c-style-variables-are-local-p nil)
  ;give me NO newline automatically after electric expressions are entered
  (setq c-auto-newline nil)

  ; @see http://xugx2007.blogspot.com.au/2007/06/benjamin-rutts-emacs-c-development-tips.html
  (setq compilation-window-height 8)
  (setq compilation-finish-function
        (lambda (buf str)
          (if (string-match "exited abnormally" str)
              ;;there were errors
              (message "compilation errors, press C-x ` to visit")
            ;;no errors, make the compilation window go away in 0.5 seconds
            (when (string-match "*compilation*" (buffer-name buf))
              ;; @see http://emacswiki.org/emacs/ModeCompile#toc2
              (bury-buffer "*compilation*")
              (winner-undo)
              (message "NO COMPILATION ERRORS!")
              ))))

  ;if (0)          becomes        if (0)
  ;    {                          {
  ;       ;                           ;
  ;    }                          }
  (c-set-offset 'substatement-open 0)

  ;first arg of arglist to functions: tabbed in once
  ;(default was c-lineup-arglist-intro-after-paren)
  ;; (c-set-offset 'arglist-intro '+)

  ;second line of arglist to functions: tabbed in once
  ;(default was c-lineup-arglist)
  ;; (c-set-offset 'arglist-cont-nonempty '+)

  ;switch/case:  make each case line indent from switch
  (c-set-offset 'case-label '+)

  ;make the ENTER key indent next line properly
  (local-set-key "\C-m" 'newline-and-indent)

  ;syntax-highlight aggressively
  ;(setq font-lock-support-mode 'lazy-lock-mode)
  (setq lazy-lock-defer-contextually t)
  (setq lazy-lock-defer-time 0)

  ;make DEL take all previous whitespace with it
  (c-toggle-hungry-state 1)

  ;make open-braces after a case: statement indent to 0 (default was '+)
  (c-set-offset 'statement-case-open 0)

  ;make a #define be left-aligned
  (setq c-electric-pound-behavior (quote (alignleft)))

  ;wxwdigets stuff
  (c-set-offset 'topmost-intro-cont 'c-wx-lineup-topmost-intro-cont)

  ;do not impose restriction that all lines not top-level be indented at least
  ;1 (was imposed by gnu style by default)
  (setq c-label-minimum-indentation 0)

  (when buffer-file-name
    (require 'fic-mode)
    (add-hook 'c++-mode-hook 'turn-on-fic-mode)

    ;; @see https://github.com/redguardtoo/cpputils-cmake
    ;; Make sure your project use cmake!
    ;; Or else, you need comment out below code:
    ;; {{
    ;; stevens disable
    ;; (flymake-mode 1)
    ;; (if (executable-find "cmake")
    ;;     (if (not (or (string-match "^/usr/local/include/.*" buffer-file-name)
    ;;                  (string-match "^/usr/src/linux/include/.*" buffer-file-name)))
    ;;         (cppcm-reload-all)))
    ;; }}

    ))

(defun fix-c-indent-offset-according-to-syntax-context (key val)
  ;; remove the old element
  (setq c-offsets-alist (delq (assoc key c-offsets-alist) c-offsets-alist))
  ;; new value
  (add-to-list 'c-offsets-alist '(key . val)))

;; donot use c-mode-common-hook or cc-mode-hook because many major-modes use this hook
(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
              ;; indent
              (fix-c-indent-offset-according-to-syntax-context 'substatement 0)
              (fix-c-indent-offset-according-to-syntax-context 'func-decl-cont 0)
              (fix-c-indent-offset-according-to-syntax-context 'innamespace [0])

              ;; gtags (GNU global) stuff
              (setq gtags-suggested-key-mapping t)
              (if *emacs24* (ggtags-mode 1)))
            (if (and (derived-mode-p 'c-mode 'c++-mode)
                     (not (is-buffer-file-temp)))
              (my-c-mode-hook))
            ))

;; electric-pair-mode 在某些情况下，对`{`无法正常使用
(defun my-c-mode-auto-pair ()
  (interactive)
  (make-local-variable 'skeleton-pair-alist)
  (setq skeleton-pair-alist  '(
    (?\( _ ")")
    (?\[ _ "]")
    (?{ \n > _ \n ?} >)))
  (setq skeleton-pair t)
  ;; (local-set-key (kbd "(") 'skeleton-pair-insert-maybe)
  ;; (local-set-key (kbd "[") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "{") 'skeleton-pair-insert-maybe))

(add-hook 'c-mode-common-hook 'my-c-mode-auto-pair)

;; http://stackoverflow.com/questions/4549015/in-c-c-mode-in-emacs-change-face-of-code-in-if-0-endif-block-to-comment-f
(defun my-c-mode-font-lock-if0 (limit)
  (save-restriction
    (widen)
    (save-excursion
      (goto-char (point-min))
      (let ((depth 0) str start start-depth)
        (while (re-search-forward "^\\s-*#\\s-*\\(if\\|else\\|endif\\)" limit 'move)
          (setq str (match-string 1))
          (if (string= str "if")
              (progn
                (setq depth (1+ depth))
                (when (and (null start) (looking-at "\\s-+0"))
                  (setq start (match-end 0)
                        start-depth depth)))
            (when (and start (= depth start-depth))
              (c-put-font-lock-face start (match-beginning 0) 'font-lock-comment-face)
              (setq start nil))
            (when (string= str "endif")
              (setq depth (1- depth)))))
        (when (and start (> depth 0))
          (c-put-font-lock-face start (point) 'font-lock-comment-face)))))
  nil)

(defun my-c-mode-common-hook ()
  (font-lock-add-keywords
   nil
   '((my-c-mode-font-lock-if0 (0 font-lock-comment-face prepend))) 'add-to-end))

(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

(provide 'init-cc-mode)
