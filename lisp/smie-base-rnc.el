;;; smie-base-rnc.el --- Major-mode for RNC of SMIE collection  -*- lexical-binding: t; -*-

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

;; Major-mode for RNC of SMIE collection.


;;; Code:

(defgroup smie-base-rnc nil
  "Major-mode for RNC of SMIE collection."
  :group 'convenience
  :link '(url-link :tag "Github" "https://github.com/conao3/smie-base.el"))

(defconst smie-base-rnc-mode-syntax-table
  (let ((st (make-syntax-table)))
    (modify-syntax-entry ?\{ "(}" st)
    (modify-syntax-entry ?\} "){" st)
    (modify-syntax-entry ?\" "\"" st)
    (modify-syntax-entry ?# "<" st)
    (modify-syntax-entry ?\n ">" st)
    (modify-syntax-entry ?: "_" st)
    st)
  "A `syntax-table' for `smie-base-rnc-mode'.")

(provide 'smie-base-rnc)

;; Local Variables:
;; indent-tabs-mode: nil
;; package-lint-main-file: "../smie-base.el"
;; End:

;;; smie-base-rnc.el ends here
