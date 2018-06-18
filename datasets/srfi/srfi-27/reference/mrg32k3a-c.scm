; 54-BIT FLONUM IMPLEMENTATION OF THE "MRG32K3A"-GENERATOR
; ========================================================
;
; Sebastian.Egner@philips.com, 2002.
;
; This code is a floating point implementation in Scheme of Pierre L'Ecuyer's 
; MRG32k3a generator. The implementation runs under the Gambit 3.0 Scheme
; system. It makes use of Gambit's f64vector. The code is based on Brad
; Lucier's code for this generator. Please refer to Brad's original posting
; in the SRFI-27 discussion archive and to his posting of an optimization.
;
; compliance:
;   Scheme R5RS with flonums covering at least {-2^53..2^53-1} exactly.
;   In addition: declare f64vector ##fixnum?
;
; loading this file into Gambit 3.0:
;   (load "mrg32k3a-2.scm")
;
; history of this file:
;   SE, 18-Mar-2002: initial version
;   SE, 25-Mar-2002: adapted to new interface
;   SE, 04-Apr-2002: debugged; simplified
;   SE, 10-Apr-2002: incorporated Brad Lucier's optimizations

; the actual generator

(define (mrg32k3a-random-m1 state) ; from Brad Lucier
  (declare (flonum))
  (let* ((x10 (- (* 1403580.0 (f64vector-ref state 1)) 
		 (* 810728.0 (f64vector-ref state 2))))
	 (y10 (- x10 (* (floor (/ x10 4294967087.0)) 4294967087.0)))
	 (x20 (- (* 527612.0 (f64vector-ref state 3)) 
		 (* 1370589.0 (f64vector-ref state 5))))
	 (y20 (- x20 (* (floor (/ x20 4294944443.0)) 4294944443.0)))
	 (dx (- y10 y20))
	 (dy (- dx (* (floor (/ dx 4294967087.0)) 4294967087.0))))
    (f64vector-set! state 5 (f64vector-ref state 4))
    (f64vector-set! state 4 (f64vector-ref state 3))
    (f64vector-set! state 3 y20)
    (f64vector-set! state 2 (f64vector-ref state 1))
    (f64vector-set! state 1 (f64vector-ref state 0))
    (f64vector-set! state 0 y10)
    dy))

; interface to 'random.scm'

(define (mrg32k3a-pack-state unpacked-state)
  (list->f64vector (map exact->inexact (vector->list unpacked-state))))

(define (mrg32k3a-unpack-state state)
  (list->vector (map inexact->exact (f64vector->list state))))

(define (mrg32k3a-random-range)
  (if (##fixnum? 4294967087)
      4294967087
       536870911)) ; 2^29-1

(define (mrg32k3a-random-integer state range) ; from Brad Lucier
  (declare (flonum))
  (let* ((n (let () (declare (fixnum)) (exact->inexact range)))
	 (q (floor (/ 4294967087.0 n)))
	 (qn (* q n)))
    (do ((x (mrg32k3a-random-m1 state) (mrg32k3a-random-m1 state)))
	((< x qn) 
	 (let () 
	   (declare (fixnum)) 
	   (inexact->exact (let () (declare (flonum)) (floor (/ x q)))))))))

(define (mrg32k3a-random-real state)
  (declare (flonum))
  (* 0.0000000002328306549295728 (+ 1.0 (mrg32k3a-random-m1 state))))

