;; Start server if GUI is running
(when (display-graphic-p)
  (server-start)

  ;; Prevent Emacs.app from becoming unresponsive once we close all
  ;; the GUI frames Actually, mac-pseudo-daemon-mode should be defined
  ;; even outside of macOS; but currently on my Ubuntu it isn't.
  (when (fboundp 'mac-pseudo-daemon-mode)
    mac-pseudo-daemon-mode))
