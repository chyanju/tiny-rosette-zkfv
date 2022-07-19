#lang rosette

; https://github.com/fredfeng/CS292C/blob/master/lectures/lecture2.pdf
(define-symbolic x integer?)

(define (poly x) (+ (* x x x x) (* 6 x x x) (* 11 x x) (* 6 x)))
(define (factored x) (* x (+ x 1) (+ x 2) (+ x 2)))

(define cex (verify (assert (= (poly x) (factored x)))))
(poly (evaluate x cex))
(factored (evaluate x cex))