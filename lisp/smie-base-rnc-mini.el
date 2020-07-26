;;; smie-base-rnc-mini.el --- Major-mode for RNC-MINI of SMIE collection  -*- lexical-binding: t; -*-

;; Copyright (C) 2020  Naoya Yamashita

;; Author: Naoya Yamashita <conao3@gmail.com>
;; URL: https://github.com/conao3/smie-base.el

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Major-mode for RNC-MINI of SMIE collection.


;;; Code:

(require 'smie)

(defgroup smie-base-rnc-mini nil
  "Major-mode for RNC-MINI of SMIE collection."
  :group 'convenience
  :link '(url-link :tag "Github" "https://github.com/conao3/smie-base.el"))

(defconst smie-base-rnc-mini-mode-syntax-table
  (let ((st (make-syntax-table)))
    (modify-syntax-entry ?# "<" st)
    (modify-syntax-entry ?\n ">" st)
    (modify-syntax-entry ?: "_" st)
    st)
  "A `syntax-table' for `smie-base-rnc-mini-mode'.")

(defconst smie-base-rnc-mini--def-regexp
  "^[ \t]*\\([\\[:alpha:]][[:alnum:]-._]*\\)[ \t]*=")

(defconst smie-base-rnc-mini-imenu-generic-expression
  `((nil ,smie-base-rnc-mini--def-regexp 1))
  "A `imenu-generic-expression' for `smie-base-rnc-mini-mode'.")

(defconst smie-base-rnc-mini-mode-font-lock-keywords
  `((,(regexp-opt
       '("namespace" "default" "datatypes" "element" "attribute"
         "list" "mixed" "parent" "empty" "text" "notAllowed" "external"
         "grammar" "div" "include" ;; "start"
         "string" "token" "inherit")
       'symbols)
     . font-lock-keyword-face)
    (,smie-base-rnc-mini--def-regexp
     (1 font-lock-function-name-face)))
  "A `font-lock-keywords' for `smie-base-rnc-mini-mode'.
Taken from the grammar in http://relaxng.org/compact-20021121.html")

(defconst smie-base-rnc-mini-smie-grammar
  (smie-prec2->grammar
   (smie-bnf->prec2
    '((id)
      (args (id) ("{" pattern "}"))
      (decls (id "=" pattern)
             (decls " ; " decls))
      (pattern ("element" args)
               ("attribute" args)
               (pattern "," pattern)
               (pattern "|" pattern)
               (pattern "?")
               (pattern "+")))
    ;; Resolve precedence ambiguities.
    '((assoc " ; "))
    '((assoc "," "|") (nonassoc "?" "+"))))
  "A smie-grammar for `smie-base-rnc-mini-mode'.")

(defun smie-base-rnc-mini-smie-forward-token ()
  "A smie-forward-token for `smie-base-rnc-mini-mode'."
  (let ((start (point)))
    (forward-comment (point-max))
    (if (and (> (point) start)
             (looking-at "\\(?:\\s_\\|\\sw\\)+[ \t\n]*[|&]?=")
             (save-excursion
               (goto-char start)
               (forward-comment -1)
               (= (point) start)))
        " ; "
      (if (looking-at "\\s.")
      	  (buffer-substring-no-properties
      	   (point)
      	   (progn (forward-char 1) (point)))
	(smie-default-forward-token)))))

(defun smie-base-rnc-mini-smie-backward-token ()
  "A smie-backward-token for `smie-base-rnc-mini-mode'."
  (let ((start (point)))
    (forward-comment (- (point)))
    (if (and (< (point) start)
             (let ((pos (point)))
               (goto-char start)
               (prog1 (looking-at "\\(?:\\ s_\\|\\sw\\)+[ \t\n]*=")
                 (goto-char pos))))
        " ; "
      (if (looking-back "\\s." (1- (point)))
          (buffer-substring-no-properties
           (point)
           (progn (forward-char -1) (point)))
        (smie-default-backward-token)))))

(defun smie-base-rnc-mini-smie-rules (kind token)
  "A smie-rules for `smie-base-rnc-mini-mode'.
TOKEN is recognized as KIND."
  (pcase (cons kind token)
    (`(:elem . empty-line-token) " ; ") ; newline indent
    (`(:before . "{")
     (save-excursion
       (smie-base-rnc-mini-smie-backward-token)
       (when (member (smie-base-rnc-mini-smie-backward-token)
                     '("element" "attribute"))
         `(column . ,(smie-indent-virtual)))))
    (`(:after . ,(or "=" "|=" "&=")) smie-indent-basic)))

(define-derived-mode smie-base-rnc-mini-mode prog-mode "sb-RNC-MINI"
  "Major-mode for RNC-MINI of SMIE collection."
  (setq-local comment-start "#")
  (setq-local font-lock-defaults '(smie-base-rnc-mini-mode-font-lock-keywords))
  (setq-local imenu-generic-expression smie-base-rnc-mini-imenu-generic-expression)
  (smie-setup smie-base-rnc-mini-smie-grammar #'smie-base-rnc-mini-smie-rules
              :forward-token #'smie-base-rnc-mini-smie-forward-token
              :backward-token #'smie-base-rnc-mini-smie-backward-token))

(provide 'smie-base-rnc-mini)

;; Local Variables:
;; indent-tabs-mode: nil
;; package-lint-main-file: "../smie-base.el"
;; End:

;;; smie-base-rnc-mini.el ends here
