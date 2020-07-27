;;; smie-base-ada.el --- Major-mode for ADA of SMIE collection  -*- lexical-binding: t; -*-

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

;; Major-mode for ADA of SMIE collection.


;;; Code:

(require 'smie)

(defgroup smie-base-ada nil
  "Major-mode for ADA of SMIE collection."
  :group 'convenience
  :link '(url-link :tag "Github" "https://github.com/conao3/smie-base.el"))

(defconst smie-base-ada-mode-syntax-table
  (let ((st (make-syntax-table)))
    (modify-syntax-entry ?# "<" st)
    (modify-syntax-entry ?- ". 12" st)
    (modify-syntax-entry ?\n ">" st)
    (modify-syntax-entry ?_ "_" st)
    st)
  "A `syntax-table' for `smie-base-ada-mode'.")

(defconst smie-base-ada--def-regexp
  "^[ \t]*procedure[ \t]*\\([\\[:alpha:]][[:alnum:]_]*\\)[ \t]*is")

(defconst smie-base-ada-imenu-generic-expression
  `((nil ,smie-base-ada--def-regexp 1))
  "A `imenu-generic-expression' for `smie-base-ada-mode'.")

(defconst smie-base-ada--83-new-keywords
  '("abort"     "abs"       "accept"   "access"    "all"
    "and"       "array"     "at"       "begin"     "body"
    "case"      "constant"  "declare"  "delay"     "delta"
    "digits"    "do"        "else"     "elsif"     "end"
    "entry"     "exception" "exit"     "for"       "function"
    "generic"   "goto"      "if"       "in"        "is"
    "limited"   "loop"      "mod"      "new"       "not"
    "null"      "of"        "or"       "others"    "out"
    "package"   "pragma"    "private"  "procedure" "raise"
    "range"     "record"    "rem"      "renames"   "return"
    "reverse"   "select"    "separate" "subtype"   "task"
    "terminate" "then"      "type"     "use"       "when"
    "while"     "with"      "xor")
  "A keywords for Ada 83.
This list taken from https://en.wikibooks.org/wiki/Ada_Programming/Ada_83")

(defconst smie-base-ada--95-new-keywords
  '("abstract" "aliased" "protected" "requeue" "tagged" "until")
  "A new keywords for Ada 95.
This list taken from https://en.wikibooks.org/wiki/Ada_Programming/Ada_95")

(defconst smie-base-ada--2005-new-keywords
  '("interface" "overriding" "synchronized")
  "A new keywords for Ada 2005.
This list taken from https://en.wikibooks.org/wiki/Ada_Programming/Ada_2005")

(defconst smie-base-ada--2012-new-keywords
  '("some")
  "A new keywords for Ada 2012.
This list taken from https://en.wikibooks.org/wiki/Ada_Programming/Ada_2012")

(defconst smie-base-ada-83-keywords
  (append smie-base-ada--83-new-keywords)
  "A keywords for Ada 83.")

(defconst smie-base-ada-95-keywords
  (append smie-base-ada--83-new-keywords
          smie-base-ada--95-new-keywords)
  "A keywords for Ada 95.")

(defconst smie-base-ada-2005-keywords
  (append smie-base-ada--83-new-keywords
          smie-base-ada--95-new-keywords
          smie-base-ada--2005-new-keywords)
  "A keywords for Ada 2005.")

(defconst smie-base-ada-2012-keywords
  (append smie-base-ada--83-new-keywords
          smie-base-ada--95-new-keywords
          smie-base-ada--2005-new-keywords
          smie-base-ada--2012-new-keywords)
  "A keywords for Ada 2012.")

(defcustom smie-base-ada-keywords smie-base-ada-2012-keywords
  "Ada keywords for `smie-base-ada-mode'.
You can specify string list or below prepared keyword list.
  - smie-base-ada-83-keywords
  - smie-base-ada-95-keywords
  - smie-base-ada-2005-keywords
  - smie-base-ada-2012-keywords"
  :group 'smie-base-ada
  :type 'sexp
  :set (lambda (sym val)
         (set-default sym val)
         (defconst smie-base-ada-mode-font-lock-keywords
           `((,(regexp-opt val 'symbols)
              . font-lock-keyword-face)
             (,smie-base-ada--def-regexp
              (1 font-lock-function-name-face)))
           "A `font-lock-keywords' for `smie-base-ada-mode'.
Taken from the grammar in http://relaxng.org/compact-20021121.html")))

(defcustom smie-base-ada-indent-basic 3
  "Basic indent for `smie-base-ada-mode'."
  :group 'smie-base-ada
  :type 'integer)

(defconst smie-base-ada-smie-grammar
  (smie-prec2->grammar
   (smie-bnf->prec2
    '((id)
      (exp (exp ";")
           ("is" exp "begin" exp "end" id)
           ;; ("package" id "is" exp "end" id)
           (fn))
      (fn ("function" id "(" id ":" "in" id ")" "return" id)
          ("function" id "(" id ":" "in" id ")" "return" id
           "is" "begin" exp "end" id))
      ;; (exps (exp ";" exp))
      ;; (exp (id)
      ;;      (id "." id))

      ;; (args (id) ("{" pattern "}"))
      ;; (decls (id "=" pattern)
      ;;        (decls " ; " decls))
      ;; (pattern ("element" args)
      ;;          ("attribute" args)
      ;;          (pattern "," pattern)
      ;;          (pattern "|" pattern)
      ;;          (pattern "?")
      ;;          (pattern "+"))
      )
    ;; Resolve precedence ambiguities.
    ;; '((assoc " ; "))
    ;; '((assoc "," "|") (nonassoc "?" "+"))
    '((nonassoc "procedure" "package")
      (assoc "is" "begin" "end"))))
  "A smie-grammar for `smie-base-ada-mode'.")

(defun smie-base-ada-smie-forward-token ()
  "A smie-forward-token for `smie-base-ada-mode'."
  (let ((start (point)))
    (forward-comment (point-max))
    (if (and (> (point) start)
             (looking-at "\\(?:\\s_\\|\\sw\\)+[ \t\n]*[|&]?=")
             (save-excursion
               (goto-char start)
               (forward-comment -1)
               (= (point) start)))
        nil ;; " ; "
      (if (looking-at "\\s.")
      	  (buffer-substring-no-properties
      	   (point)
      	   (progn (forward-char 1) (point)))
	(smie-default-forward-token)))))

(defun smie-base-ada-smie-backward-token ()
  "A smie-backward-token for `smie-base-ada-mode'."
  (let ((start (point)))
    (forward-comment (- (point)))
    (if (and (< (point) start)
             (let ((pos (point)))
               (goto-char start)
               (prog1 (looking-at "\\(?:\\ s_\\|\\sw\\)+[ \t\n]*=")
                 (goto-char pos))))
        nil ;; " ; "
      (if (looking-back "\\s." (1- (point)))
          (buffer-substring-no-properties
           (point)
           (progn (forward-char -1) (point)))
        (smie-default-backward-token)))))

(defun smie-base-ada-smie-rules (kind token)
  "A smie-rules for `smie-base-ada-mode'.
TOKEN is recognized as KIND."
  (pcase (cons kind token)
    (`(:after . "is")
     (save-excursion
       (smie-base-ada-smie-backward-token)
       (when (member (smie-base-ada-smie-backward-token)
                     '("procedure" "package" "body"))
         `(column . ,(+ (current-column) smie-indent-basic)))))
    ;; (`(:elem . empty-line-token) " ; ") ; newline indent
    ;; (`(:before . "{")
    ;;  (save-excursion
    ;;    (smie-base-ada-smie-backward-token)
    ;;    (when (member (smie-base-ada-smie-backward-token)
    ;;                  '("package" "procedure" "begin"))
    ;;      `(column . ,(smie-indent-virtual)))))
    ;; (`(:after . ,(or "=" "|=" "&=")) smie-indent-basic)
    ))

(define-derived-mode smie-base-ada-mode prog-mode "sb-ADA"
  "Major-mode for ADA of SMIE collection."
  (setq-local comment-start "#")
  (setq-local font-lock-defaults '(smie-base-ada-mode-font-lock-keywords))
  (setq-local imenu-generic-expression smie-base-ada-imenu-generic-expression)
  (setq-local smie-indent-basic smie-base-ada-indent-basic)
  (smie-setup smie-base-ada-smie-grammar #'smie-base-ada-smie-rules
              ;; :forward-token #'smie-base-ada-smie-forward-token
              ;; :backward-token #'smie-base-ada-smie-backward-token
              ))

(provide 'smie-base-ada)

;; Local Variables:
;; indent-tabs-mode: nil
;; package-lint-main-file: "../smie-base.el"
;; End:

;;; smie-base-ada.el ends here
