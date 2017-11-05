;; Start server if GUI is running
(when (display-graphic-p)
  (server-start)

  ;; Prevent Emacs.app from becoming unresponsive once we close all the GUI frames
  (mac-pseudo-daemon-mode))
