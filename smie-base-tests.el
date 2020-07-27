;;; smie-base-tests.el --- Test definitions for smie-base  -*- lexical-binding: t; -*-

;; Copyright (C) 2019  Naoya Yamashita

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

;; Test definitions for `smie-base'.


;;; Code:

(require 'cort)
(require 'smie-base)
(require 'smie-base-rnc-mini)
(require 'smie-base-ada)

(setq-default indent-tabs-mode nil)

(defmacro cort--buffer-string-with-indent ()
  "Get `buffer-string' after indent whole buffer."
  `(progn
     (let ((inhibit-message t))
       (indent-region (point-min) (point-max))
       (buffer-substring-no-properties (point-min) (point-max)))))

(defmacro cort-deftest--major-mode-indent (name mode testlst)
  "Define a test case with the NAME for MODE.
TESTLST is list of (GIVEN EXPECT)."
  (declare (indent 2))
  `(cort-deftest ,name
     (cort-generate :equal
       ',(mapcar
          (lambda (elm)
            `((with-temp-buffer
                (insert ,(car elm))
                (,(eval mode))
                (cort--buffer-string-with-indent))
              ,(cadr elm)))
          (eval testlst)))))


;;; smie-base-rnc-mini

(cort-deftest--major-mode-indent smie-base-rnc-mini/sample-1
    #'smie-base-rnc-mini-mode
  '(("\
datatypes xsd = \"http://www.w3.org/2001/XMLSchema-datatypes\"

start = element recettes { recettes }

recettes = recette+ |
element group {
attribute nom { string },
recettes
}

recette = element recette {
attribute nom { string },
attribute photo { xsd:anyURI }? ,
ingredients,
etapes
}"
     "\
datatypes xsd = \"http://www.w3.org/2001/XMLSchema-datatypes\"

start = element recettes { recettes }

recettes = recette+ |
           element group {
               attribute nom { string },
               recettes
           }

recette = element recette {
              attribute nom { string },
              attribute photo { xsd:anyURI }? ,
              ingredients,
              etapes
          }")))


;;; smie-base-ada

;; (cort-deftest--major-mode-indent smie-base-ada/RADWIMPS
;;     #'smie-base-ada-mode
;;   '(("\
;; with Ada.Text_IO;
;; use Ada.Text_IO;

;; procedure RADWIMPS is
;; package Rad_Package is
;; type Rad is tagged null record;

;; procedure se(Self: in Rad);

;; function t_hen(Self: in Rad) return Rad;
;; end Rad_Package;

;; package body Rad_Package is
;; procedure se(Self: in Rad) is
;; begin
;; put_line(\"世\");
;; end se;

;; function t_hen(Self: in Rad) return Rad is
;; begin
;; put(\"前\");
;; return Self;
;; end t_hen;
;; end Rad_Package;

;; use Rad_Package;

;; RADWIMPS: Rad;
;; begin
;; RADWIMPS.t_hen.t_hen.t_hen.se;
;; end RADWIMPS;
;; "
;;      "\
;; with Ada.Text_IO;
;; use Ada.Text_IO;

;; procedure RADWIMPS is
;;    package Rad_Package is
;;       type Rad is tagged null record;

;;       procedure se(Self: in Rad);

;;       function t_hen(Self: in Rad) return Rad;
;;    end Rad_Package;

;;    package body Rad_Package is
;;       procedure se(Self: in Rad) is
;;       begin
;;          put_line(\"世\");
;;       end se;

;;       function t_hen(Self: in Rad) return Rad is
;;       begin
;;          put(\"前\");
;;          return Self;
;;       end t_hen;
;;    end Rad_Package;

;;    use Rad_Package;

;;    RADWIMPS: Rad;
;; begin
;;    RADWIMPS.t_hen.t_hen.t_hen.se;
;; end RADWIMPS;")))

;; (provide 'smie-base-tests)

;; Local Variables:
;; indent-tabs-mode: nil
;; End:

;;; smie-base-tests.el ends here
