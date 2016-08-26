;;;;
;; Clojure
;;;;

;; Enable rainbow delimiters for Clojure
(add-hook 'clojure-mode-hook 'rainbow-delimiters-mode-enable)

;; Enable paredit for Clojure
(add-hook 'clojure-mode-hook 'enable-paredit-mode)

;; This is useful for working with camel-case tokens, like names of
;; Java classes (e.g. JavaClassName)
(add-hook 'clojure-mode-hook 'subword-mode)

;; Removed because it conflicts with CIDER in cases when we want to
;; use that. Instead, use M-x inf-clojure-minor-mode when desired.
;; Enable integration of Figwheel with Emacs; NOTE: does not use
;; CIDER!
;(add-hook 'clojure-mode-hook #'inf-clojure-minor-mode)

;; A little more syntax highlighting
(require 'clojure-mode-extra-font-locking)

;; syntax hilighting for midje
(add-hook 'clojure-mode-hook
          (lambda ()
            (setq inferior-lisp-program "lein repl")
            (font-lock-add-keywords
             nil
             '(("(\\(facts?\\)"
                (1 font-lock-keyword-face))
               ("(\\(background?\\)"
                (1 font-lock-keyword-face))))
            (define-clojure-indent (fact 1))
            (define-clojure-indent (facts 1))))

;;;;
;; Cider
;;;;

;; provides minibuffer documentation for the code you're typing into the repl
(add-hook 'cider-mode-hook 'eldoc-mode)

;; go right to the REPL buffer when it's finished connecting
(setq cider-repl-pop-to-buffer-on-connect t)

;; When there's a cider error, show its buffer and switch to it
(setq cider-show-error-buffer t)
(setq cider-auto-select-error-buffer t)

;; Where to store the cider history.
(setq cider-repl-history-file "~/.emacs.d/cider-history")

;; Wrap when navigating history.
(setq cider-repl-wrap-history t)

;; enable paredit in your REPL
(add-hook 'cider-repl-mode-hook 'paredit-mode)

;; Use clojure mode for other extensions
(add-to-list 'auto-mode-alist '("\\.edn$" . clojure-mode))
(add-to-list 'auto-mode-alist '("\\.boot$" . clojure-mode))
(add-to-list 'auto-mode-alist '("\\.cljs.*$" . clojure-mode))
(add-to-list 'auto-mode-alist '("lein-env" . enh-ruby-mode))


;; key bindings
;; these help me out with the way I usually develop web apps
(defun cider-start-http-server ()
  (interactive)
  (cider-load-current-buffer)
  (let ((ns (cider-current-ns)))
    (cider-repl-set-ns ns)
    (cider-interactive-eval (format "(println '(def server (%s/start))) (println 'server)" ns))
    (cider-interactive-eval (format "(def server (%s/start)) (println server)" ns))))


(defun cider-refresh ()
  (interactive)
  (cider-interactive-eval (format "(user/reset)")))

(defun cider-user-ns ()
  (interactive)
  (cider-repl-set-ns "user"))

(eval-after-load 'cider
  '(progn
     (define-key clojure-mode-map (kbd "C-c C-v") 'cider-start-http-server)
     (define-key clojure-mode-map (kbd "C-M-r") 'cider-refresh)
     (define-key clojure-mode-map (kbd "C-c u") 'cider-user-ns)
     (define-key cider-mode-map (kbd "C-c u") 'cider-user-ns)))

(defun figwheel-repl ()
  "Start a Figwheel Clojurescript REPL using inf-clojure."
  (interactive)
  (run-clojure "lein figwheel"))

(defun define-paredit-terminal-keys ()
  "Create some terminal-friendly paredit bindings"

  (define-key paredit-mode-map (kbd "C-c [ ]") 'paredit-forward-slurp-sexp)
  (define-key paredit-mode-map (kbd "C-c [ [")  'paredit-forward-barf-sexp)
  (define-key paredit-mode-map (kbd "C-c [ M-]") 'paredit-backward-slurp-sexp)
  (define-key paredit-mode-map (kbd "C-c [ M-[")  'paredit-backward-barf-sexp))

(defun define-paredit-general-keys ()
  "Create some generally-useful paredit bindings"

  (define-key paredit-mode-map (kbd "{") 'paredit-open-curly)
  (define-key paredit-mode-map (kbd "}") 'paredit-close-curly)

  ;; Initially I wanted to have M-[ and M-{ to parallel M-(, and M-]
  ;; and M-} to parallel M-). But the former falls apart because M-[
  ;; is the prefix for things like <Home>; and the former and latter
  ;; fall apart because M-{/M-} are built-in things for navigating
  ;; paragraphs. So we can use terminal-like sequences instead (and
  ;; throw in corresponding ones for round parentheses too).
  ;; (define-key paredit-mode-map (kbd "C-c [ w (") 'paredit-wrap-round)
  ;; (define-key paredit-mode-map (kbd "C-c [ w [") 'paredit-wrap-square)
  ;; (define-key paredit-mode-map (kbd "C-c [ w {") 'paredit-wrap-curly)

  ;; ;; Really, with these, we can just use M-)
  ;; ;; (paredit-close-round-and-newline) and it will use the right kind
  ;; ;; of delimiter for whatever structure point is in, so these are
  ;; ;; unnecessary.
  ;; (define-key paredit-mode-map (kbd "C-c [ c )") 'paredit-close-round-and-newline)
  ;; (define-key paredit-mode-map (kbd "C-c [ c ]") 'paredit-close-square-and-newline)
  ;; (define-key paredit-mode-map (kbd "C-c [ c }") 'paredit-close-curly-and-newline)
  )

(eval-after-load 'paredit
  '(progn (define-paredit-general-keys)
          (define-paredit-terminal-keys)))
