(defun c-wx-lineup-topmost-intro-cont (langelem)
  (save-excursion
    (beginning-of-line)
    (if (re-search-forward "EVT_" (line-end-position) t)
      'c-basic-offset
      (c-lineup-topmost-intro-cont langelem))))

;; avoid default "gnu" style, use more popular one
(setq c-default-style "linux")

(defun fix-c-indent-offset-according-to-syntax-context (key val)
  ;; remove the old element
  (setq c-offsets-alist (delq (assoc key c-offsets-alist) c-offsets-alist))
  ;; new value
  (add-to-list 'c-offsets-alist '(key . val)))

(defun compilation-finish-hide-buffer-on-success (buf str)
  "Could be reused by other major-mode after compilation."
  (if (string-match "exited abnormally" str)
      ;;there were errors
      (message "compilation errors, press C-x ` to visit")
    ;;no errors, make the compilation window go away in 0.5 seconds
    (when (string-match "*compilation*" (buffer-name buf))
      ;; @see http://emacswiki.org/emacs/ModeCompile#toc2
      (bury-buffer "*compilation*")
      (winner-undo)
      (message "NO COMPILATION ERRORS!")
      )))

(defun my-common-cc-mode-setup ()
  "setup shared by all languages (java/groovy/c++ ...)"
  (setq c-basic-offset 4)
  ;; give me NO newline automatically after electric expressions are entered
  (setq c-auto-newline nil)

  ; @see http://xugx2007.blogspot.com.au/2007/06/benjamin-rutts-emacs-c-development-tips.html
  (setq compilation-window-height 8)
  (setq compilation-finish-functions
        '(compilation-finish-hide-buffer-on-success))

  ;; syntax-highlight aggressively
  ;; (setq font-lock-support-mode 'lazy-lock-mode)
  (setq lazy-lock-defer-contextually t)
  (setq lazy-lock-defer-time 0)

  ;make DEL take all previous whitespace with it
  (c-toggle-hungry-state 1)

  ;; indent
  (fix-c-indent-offset-according-to-syntax-context 'substatement 0)
  (fix-c-indent-offset-according-to-syntax-context 'innamespace [0])
  (fix-c-indent-offset-according-to-syntax-context 'func-decl-cont 0))

(defun my-c-mode-setup ()
  "C/C++ only setup"
  (message "my-c-mode-setup called (buffer-file-name)=%s" (buffer-file-name))
  ;; @see http://stackoverflow.com/questions/3509919/ \
  ;; emacs-c-opening-corresponding-header-file
  (local-set-key (kbd "C-x C-o") 'ff-find-other-file)

  ;; stevens
  (setq cc-search-directories '("." "../*/src" "../*/source" "../*/include" "../*/inc" "/usr/include" "/usr/local/include/*" "$WXWIN/include"))

  ;; wxWidgets setup
  (c-set-offset 'topmost-intro-cont 'c-wx-lineup-topmost-intro-cont)

  ;; make a #define be left-aligned
  (setq c-electric-pound-behavior (quote (alignleft)))

  (when buffer-file-name

    ;; @see https://github.com/redguardtoo/cpputils-cmake
    ;; Make sure your project use cmake!
    ;; Or else, you need comment out below code:
    ;; {{
    ;; (flymake-mode 1)
    ;; (if (executable-find "cmake")
    ;;     (if (not (or (string-match "^/usr/local/include/.*" buffer-file-name)
    ;;                  (string-match "^/usr/src/linux/include/.*" buffer-file-name)))
    ;;         (cppcm-reload-all)))
    ;; }}

    ))

;; donot use c-mode-common-hook or cc-mode-hook because many major-modes use this hook
(defun c-mode-common-hook-setup ()
  (unless (is-buffer-file-temp)
    (my-common-cc-mode-setup)
    (unless (or (derived-mode-p 'java-mode) (derived-mode-p 'groovy-mode))
      (my-c-mode-setup))

    ;; gtags (GNU global) stuff
    (when (and (executable-find "global")
               ;; `man global' to figure out why
               (not (string-match-p "GTAGS not found"
                                    (shell-command-to-string "global -p"))))
      (setq gtags-suggested-key-mapping t)
      (ggtags-mode 1)
      ;; emacs 24.4+ will set up eldoc automatically.
      ;; so below code is NOT needed.
      (setq-local eldoc-documentation-function #'ggtags-eldoc-function)
      (eldoc-mode 1))
    ))
(add-hook 'c-mode-common-hook 'c-mode-common-hook-setup)

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
