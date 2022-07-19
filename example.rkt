#lang rosette
(require rosette/lib/destruct)
(define p 21888242871839275222246405745257275088548364400416034343698204186575808495617)
(define (assert-range x) (assert (&& (>= x 0) (< x p))))

(struct padd (x y) #:mutable #:transparent #:reflection-name 'padd)
(struct pmul (x y) #:mutable #:transparent #:reflection-name 'pmul)
(struct peqv (x y) #:mutable #:transparent #:reflection-name 'peqv)

(define (interpret arg-node)
    (destruct arg-node
        [(padd x y)
            (define x0 (interpret x))
            (define y0 (interpret y))
            ; (printf "# padd: ~a, ~a\n" x0 y0)
            ; arg-node
            (+ x0 y0)
        ]
        [(pmul x y)
            (define x0 (interpret x))
            (define y0 (interpret y))
            ; (printf "# pmul: ~a, ~a\n" x0 y0)
            ; arg-node
            (* x0 y0)
        ]
        [(peqv x y)
            (define x0 (interpret x))
            (define y0 (interpret y))
            ; (printf "# peqv: ~a, ~a\n" x0 y0)
            ; arg-node
            (= (modulo x0 p) (modulo y0 p))
        ]
        [x
            ; (printf "# value: ~a\n" v)
            (assert-range x)
            x
        ]
    )
)

(define-symbolic x0 integer?)
(define-symbolic x1 integer?)
(define-symbolic x2 integer?)
(define-symbolic x3 integer?)

(define c0 (peqv
    (pmul x2 x3)
    (padd x0 (pmul x1 21888242871839275222246405745257275088548364400416034343698204186575808495616))
))
(define c1 (peqv
    (pmul x2 x1)
    0
))
(define cc0 (interpret c0))
(define cc1 (interpret c1))
(printf "# cc0: ~a.\n" cc0)
(printf "# cc1: ~a.\n" cc1)

(define-symbolic x1b integer?)
(define-symbolic x3b integer?)

(define c0b (peqv
    (pmul x2 x3b)
    (padd x0 (pmul x1b 21888242871839275222246405745257275088548364400416034343698204186575808495616))
))
(define c1b (peqv
    (pmul x2 x1b)
    0
))
(define cc0b (interpret c0b))
(define cc1b (interpret c1b))

; no range analysis, z3 returns (unknown)
; (define sol (solve (assert (&& cc0 cc1 cc0b cc1b (! (= x1 x1b)) ))))
; (printf "# sol is: ~a.\n" sol)

; with range analysis, z3 returns (unsat), which is verified
(define sol (solve (assert (&& cc0 cc1 cc0b cc1b (&& (! (= x1 x1b)) (|| (= x1 0) (= x1 1)) (|| (= x1b 0) (= x1b 1)) ) ))))
(printf "# sol is: ~a.\n" sol)