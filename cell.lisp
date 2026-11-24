;;;; cell.lisp --- kulala-http: the package this cell's definitions read in.
;;;;
;;;; Written by new-cell. The cell's code is kulala-http.lisp beside it, in
;;;; (in-package #:marzv1one-kulala-http); a (define-cell kulala-http ...) there declares its
;;;; commands, tools and settings: (help :cells).

(defpackage #:marzv1one-kulala-http
  (:use #:cl #:nodecode.kernel #:nodecode.evolved))

(in-package #:marzv1one-kulala-http)

(define-peripheral kulala-http :not-running t)
