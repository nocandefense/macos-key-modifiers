;;; macos-key-modifiers.el --- Customizable macOS keyboard modifier keys -*- lexical-binding: t; -*-

;; Copyright (C) 2024 Your Name

;; Author: Brock Callahan <jbrockc@gmail.com>
;; Version: 0.1
;; Package-Requires: ((emacs "25.1"))
;; Keywords: convenience, macos
;; URL: https://github.com/nocandefense/macos-key-modifiers

;;; Commentary:

;; This package provides a customizable way to manage keyboard modifier
;; keys on macOS.  It allows cycling through predefined configurations
;; and easy switching between different modifier key setups.

;;; Code:

(defgroup macos-key-modifiers nil
  "Customization group for macOS key modifiers."
  :group 'convenience
  :prefix "macos-key-modifiers-")

(defcustom macos-key-modifiers-configurations
  '((standard . ((mac-command-modifier . super)
                 (mac-option-modifier . meta)
                 (mac-control-modifier . control)
                 (mac-function-modifier . hyper)))
    (alternate . ((mac-command-modifier . meta)
                  (mac-option-modifier . super)
                  (mac-control-modifier . control)
                  (mac-function-modifier . hyper)))
    (vim-friendly . ((mac-command-modifier . meta)
                     (mac-option-modifier . alt)
                     (mac-control-modifier . control)
                     (mac-function-modifier . super))))
  "Alist of predefined macOS modifier key configurations."
  :type '(alist :key-type symbol :value-type (alist :key-type symbol :value-type symbol))
  :group 'macos-key-modifiers)

(defcustom macos-key-modifiers-default-config 'standard
  "Default macOS modifier key configuration."
  :type 'symbol
  :group 'macos-key-modifiers)

(defvar macos-key-modifiers-current-config macos-key-modifiers-default-config
  "Current macOS modifier key configuration.")

;;;###autoload
(defun macos-key-modifiers-cycle ()
  "Cycle through available macOS modifier key configurations."
  (interactive)
  (let* ((configs (mapcar #'car macos-key-modifiers-configurations))
         (current-index (cl-position macos-key-modifiers-current-config configs))
         (next-index (mod (1+ current-index) (length configs)))
         (next-config (nth next-index configs)))
    (macos-key-modifiers-set next-config)
    (setq macos-key-modifiers-current-config next-config)
    (message "Switched to %s macOS modifier configuration" next-config)))

;;;###autoload
(defun macos-key-modifiers-set (&optional config)
  "Set macOS modifier keys according to the specified or current configuration."
  (interactive)
  (when (eq system-type 'darwin)
    (let ((configuration (or config macos-key-modifiers-current-config)))
      (when-let ((modifiers (alist-get configuration macos-key-modifiers-configurations)))
        (dolist (modifier modifiers)
          (set (car modifier) (cdr modifier)))
        (message "macOS modifiers set to %s configuration" configuration)))))

;;;###autoload
(define-minor-mode macos-key-modifiers-mode
  "Toggle macOS Key Modifiers mode."
  :init-value nil
  :lighter " MKM"
  :global t
  (if macos-key-modifiers-mode
      (macos-key-modifiers-set)
    (message "macOS Key Modifiers mode disabled")))

(provide 'macos-key-modifiers)

;;; macos-key-modifiers.el ends here
