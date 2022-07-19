#lang rosette

(define l0 (list 1 2 3 4))
(define-symbolic ptr integer?)

(define v0 (list-ref l0 ptr))
v0
(vc)