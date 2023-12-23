;; -*- lexical-binding: t; -*- ; Turn on this file

;; Install command
;; brew install emacs-plus@29 --with-dragon-icon --with-dbus --with-no-frame-refocus --with-native-comp --with-imagemagick --with-poll

;;xle tooltips

(defvar runemacs/default-font-size 100)
;(set-face-attribute 'default nil :font "Fira Code Retina" :height runemacs/default-font-size)




;(menu-bar-mode -1) ; Disable the menu bar (I disabled it because Raycast <Right-half> does not work correct)

;(setq visible-bell t) ; For undefined commands, maybe it i can change the indicator (it is annoying)


;; (setq inhibit-startup-message t)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)            ; Disable the menu bar

(setq visible-bell t)



(load-theme 'wombat) ; 'tango-dark is a symbol, "tango-dark" is a string. The function accepts symbol.

(set-face-attribute 'default nil
		    ; :font "Fira Code Retina" ; Not found
		    :height 120
		    )

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(require 'package) ;; Probably already. It is just a convention.

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ;("elpa" . "https://elpa.gnu.org/packages")
			 ))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))


;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)


(column-number-mode)
(global-display-line-numbers-mode t)


;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
		term-mode-hook
		shell-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0)))
  )

(use-package command-log-mode)

;; TODO Learn ivy
(use-package ivy
  :ensure t
 :diminish
  :bind (("C-s" . swiper)
	  :map ivy-minibuffer-map
	  ("TAB" . ivy-alt-done)
	  ("C-l " . ivy-alt-done)
	  ("C-j" . ivy-next-line)
	  ("C-k" . ivy-previous-line)
	  :map ivy-switch-buffer-map
	  ("C-k" . ivy-previous-line)
	  ("C-l" . ivy-done)
	  ("C-d" . ivy-swtich-buffer-kill)
	  :map ivy-reverse-i-search-map
	  ("C-k" . ivy-previous-line)
	  ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))


;; NOTE: The first time you load your configuration on a new machine,
;; you will need to run the following command interactively so that
;; mode line icons correctly:

(use-package all-the-icons)

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode)
  :custom ((doom-modeline-height 30)))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))


(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x))
  ("C-x b" . counsel-ibuffer)
  ("C-x C-f" . counsel-find-file)
  ;:map minibuffer-local-map ;TODO check
  ("C-r" . 'counsel-minibuffer-history)
  )

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key)
  )

(use-package general
  :config
  (general-create-definer rune/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (rune/leader-keys
    "t" '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose themeeeeeeee")
    )
  )

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  ;(evil-global-set-key 'motion "j" 'evil-next-visual-line)
  ;(evil-global-set-key 'motion  "k" 'evil-previous-visual-line)

  ;(evil-set-initial-state 'messages-buffer-mode 'normal)
  ;(evil-set-initial-state 'dashboard-mode 'normal)
  )

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init)
  )

(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t)
  )

(rune/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text")
  )

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/Trendyol")
    (setq projectile-project-search-path '("~/Trendyol")))
  (setq projectile-switch-project-action #'projectile-dired)
  )

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(add-to-list 'package-archives
	     '("melpa-stable" . "http://stable.melpa.org/packages/"))

(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/"))

(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;(use-package evil-magit
;  :after magit)


;; NOTE: Make sure to configure a GitHub token before using this package!
;; - https://magit.vc/manual/forge/Token-Creation.html#Token-Creation
;; - https://magit.vc/manual/ghub/Getting-Started.html#Getting-Started

;(use-package forge)


(defun efs/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1)
  )

;; Org Mode Configuration ----

(defun efs/org-font-setup ()
  ;; Replace list hypen with dot
  (font-lock-add-keywords 'org-mode
			  '(("^ *\\([-]\\) "
			     (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
  )

;; Set faces for heading levels
;(dolist (face '((org-level-1 . 1.2)
;		(org-level-2 . 1.1)
;		(org-level-3 . 1.05)
;		(org-level-4 . 1.0)
;		(org-level-5 . 1.1)
;		(org-level-6 . 1.1)
;		(org-level-7 . 1.1)
;		(org-level-8 . 1.1)))
;  (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face))
;  )


;; outside

(setq gc-const-threshold (* 50 1000 1000))

;; Profile emacs startup
(add-hook 'emacs-startup-hook
	  (lambda ()
	    (ssage "*** Emacs loaded in %s seconds with %d garbage collections."
		     (emacs-init-time "%.2f")
		     gcs-done)))



(setq comp-async-report-warnings-errors nil)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;OH SHIT WE ARE BACK AGAIN;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Fresh start

















;; Initialize package sources



;(add-to-list 'package-archives
;             '("melpa" . "http://melpa.org/packages/") t)

;'(package-archives
;   '(("gnu" . "http://elpa.gnu.org/packages/")
;     ("melpa" . "http://www.mirrorservice.org/sites/stable.melpa.org/packages/")))
;(package-initialize)



(setq package-check-signature nil)

(package-initialize)

(require 'use-package)
(setq use-package-always-ensure t)

;; global-command-log-mode
;; clm/toggle-command-log-buffer 
(use-package command-log-mode) 

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(forge org-plus-contrib evil-magit magit counsel-projectile projectile hydra evil-collection evil general helpful all-the-icons dirvish ivy-rich which-key rainbow-delimiters org-crypt doom-modeline ivy-xref 2bit counsel ivy command-log-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )






;(setq columnn-number-mode t)

(column-number-mode)
(global-display-line-numbers-mode t)


; shift-alt-column term-mode-hook
; exlclude
(dolist (mode '(org-mode-hook
		term-mode-hook
		shell-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda ()(display-line-numbers-mode 0))))











(package-refresh-contents)
(unless (package-installed-p 'dirvish)
  (package-install 'dirvish))
(dirvish-override-dired-mode)
