(load "mk-vicare.scm")
(load "mk.scm")
(load "test-check.scm")
(load "interp-simplified.scm")


;; append tests

(time (test "append-0"
        (run* (q)
          (evalo
           `(letrec ((append
                      (lambda (l s)
                        (if (null? l)
                            s
                            (cons (car l) (append (cdr l) s))))))
              (append '(a b c) '(d e)))
           '(a b c d e)))
        '((_.0))))

(time (test "append-1"
        (run* (q)
          (evalo
           `(letrec ((append
                      (lambda (l s)
                        (if (null? l)
                            s
                            (cons (car l) (append (cdr l) s))))))
              (append '(a b c) '(d e)))
           q))
        '(((a b c d e)))))

(time (test "append-2"
        (run 2 (q)
          (evalo
           `(letrec ((append
                      (lambda (l s)
                        (if (null? l)
                            s
                            (cons (car l) (append (cdr l) s))))))
              (append ,q '(d e)))
           '(a b c d e)))
        '(('(a b c))
          ((car '((a b c) . _.0)) (absento (closure _.0) (prim _.0))))))

(time (test "append-3"
        (run* (q)
          (evalo
           `(letrec ((append
                      (lambda (l s)
                        (if (null? l)
                            s
                            (cons (car l) (append (cdr l) s))))))
              (append ',q '(d e)))
           '(a b c d e)))
        '(((a b c)))))

(time (test "append-4"
        (run* (q r)
          (evalo
           `(letrec ((append
                      (lambda (l s)
                        (if (null? l)
                            s
                            (cons (car l) (append (cdr l) s))))))
              (append ',q ',r))
           '(a b c d e)))
        '(((() (a b c d e)))
          (((a) (b c d e)))
          (((a b) (c d e)))
          (((a b c) (d e)))
          (((a b c d) (e)))
          (((a b c d e) ())))))

(time (test "append-5"
        (run 1 (q)
          (evalo
           `(letrec ((append
                      (lambda (l s)
                        (if (null? l)
                            s
                            (cons ,q (append (cdr l) s))))))
              (append '(a b c) '(d e)))
           '(a b c d e)))
        '(((car l)))))

(time (test "append-6"
        (run 1 (q)
          (evalo
           `(letrec ((append
                      (lambda (l s)
                        (if (null? l)
                            s
                            (cons (car l) (append (cdr ,q) s))))))
              (append '(a b c) '(d e)))
           '(a b c d e)))
        '((l))))

(time (test "append-7"
        (run 1 (q)
          (evalo
           `(letrec ((append
                      (lambda (l s)
                        (if (null? l)
                            s
                            (cons (car l) (append (,q l) s))))))
              (append '(a b c) '(d e)))
           '(a b c d e)))
        '((cdr))))

(time (test "append-8"
        (run 1 (q r)
          (symbolo q)
          (symbolo r)
          (evalo
           `(letrec ((append
                      (lambda (l s)
                        (if (null? l)
                            s
                            (cons (car l) (append (,q ,r) s))))))
              (append '(a b c) '(d e)))
           '(a b c d e)))
        '(((cdr l)))))

(time (test "append-9"
        (run 1 (q r)
          (evalo
           `(letrec ((append
                      (lambda (l s)
                        (if (null? l)
                            s
                            (cons (car l) (append (,q ,r) s))))))
              (append '(a b c) '(d e)))
           '(a b c d e)))
        '(((cdr l)))))

(time (test "append-10"
        (run 1 (q)
          (evalo
           `(letrec ((append
                      (lambda (l s)
                        (if ,q
                            s
                            (cons (car l) (append (cdr l) s))))))
              (append '(a b c) '(d e)))
           '(a b c d e)))
        '(((null? l)))))

(time (test "append-11"
        (run 4 (q)
          (evalo
           `(letrec ((append
                      (lambda (l s)
                        (if ,q
                            s
                            (cons (car l) (append (cdr l) s))))))
              (append '(a b c) '(d e)))
           '(a b c d e)))
        '(((null? l))
          (((lambda () (null? l))))
          ((null? ((lambda () l))))
          ((equal? '() l)))))

;; slooow--didnt complete in 30 seconds
#|
(time (test "append-12"
        (run 1 (q r)
          (absento 'a r)
          (absento 'b r)
          (absento 'c r)
          (absento 'd r)
          (absento 'e r)
          (evalo
           `(letrec ((append
                      (lambda (l s)
                        (if ,q
                            ,r
                            (cons (car l) (append (cdr l) s))))))
              (append '(a b c) '(d e)))
           '(a b c d e)))
        '(((null? l) s))))
|#

;; slooow--didnt complete in 30 seconds
#|
(time (test "append-13"
        (run 1 (q r)
          (absento 'a r)
          (absento 'b r)
          (absento 'c r)
          (absento 'd r)
          (absento 'e r)
          (absento 'f r)
          (evalo
           `(letrec ((append
                      (lambda (l s)
                        (if ,q
                            ,r
                            (cons (car l) (append (cdr l) s))))))
              (list
               (append '() '())
               (append '(a) '(b))
               (append '(c d) '(e f))))
           '(()
             (a b)
             (c d e f))))
        '(((null? l) s))))
|#

;; slooow--didnt complete in 30 seconds
#|
(time (test "append-14"
        (run 1 (q r s)
          (absento 'a r)
          (absento 'b r)
          (absento 'c r)
          (absento 'd r)
          (absento 'e r)
          (absento 'f r)
          (evalo
           `(letrec ((append
                      (lambda (l s)
                        (if ,q
                            ,r
                            (,s (car l) (append (cdr l) s))))))
              (list
               (append '() '())
               (append '(a) '(b))
               (append '(c d) '(e f))))
           '(()
             (a b)
             (c d e f))))
        '(((null? l) s cons))))
|#


;; and tests
(time (test "and-0"
        (run* (q) (evalo '(and) q))
        '((#t))))

(time (test "and-1"
        (run* (q) (evalo '(and 5) q))
        '((5))))

(time (test "and-2"
        (run* (q) (evalo '(and #f) q))
        '((#f))))

(time (test "and-3"
        (run* (q) (evalo '(and 5 6) q))
        '((6))))

(test "and-4"
  (run* (q) (evalo '(and #f 6) q))
  '((#f)))

(test "and-5"
  (run* (q) (evalo '(and (null? '()) 6) q))
  '((6)))

(test "and-6"
  (run* (q) (evalo '(and (null? '(a b c)) 6) q))
  '((#f)))


;; or tests
(test "or-0"
  (run* (q) (evalo '(or) q))
  '((#f)))

(test "or-1"
  (run* (q) (evalo '(or 5) q))
  '((5)))

(test "or-2"
  (run* (q) (evalo '(or #f) q))
  '((#f)))

(test "or-3"
  (run* (q) (evalo '(or 5 6) q))
  '((5)))

(test "or-4"
  (run* (q) (evalo '(or #f 6) q))
  '((6)))

(test "or-5"
  (run* (q) (evalo '(or (null? '()) 6) q))
  '((#t)))

(test "or-6"
  (run* (q) (evalo '(or (null? '(a b c)) 6) q))
  '((6)))

(time
  (test "proof-1"
    (run* (q)
      (evalo
       `(letrec ((member? (lambda (x ls)
                            (if (null? ls)
                                #f
                                (if (equal? (car ls) x)
                                    #t
                                    (member? x (cdr ls)))))))
          (letrec ((proof? (lambda (proof)
                             (match proof
                               [`(assumption ,assms () ,A)
                                (member? A assms)]
                               [`(modus-ponens
                                  ,assms
                                  ((,r1 ,assms ,ants1 (if ,A ,B))
                                   (,r2 ,assms ,ants2 ,A))
                                  ,B)
                                (and (proof? (list r1 assms ants1 (list 'if A B)))
                                     (proof? (list r2 assms ants2 A)))]))))
            (proof? '(modus-ponens
                      (A (if A B) (if B C))
                      ((assumption (A (if A B) (if B C)) () (if B C))
                       (modus-ponens
                        (A (if A B) (if B C))
                        ((assumption (A (if A B) (if B C)) () (if A B))
                         (assumption (A (if A B) (if B C)) () A)) B))
                      C))))
       q))
    '((#t))))

(time
  (test "proof-2b"
    (run* (prf)
      (fresh (rule assms ants)
        (== `(,rule ,assms ,ants C) prf)
        (== `(A (if A B) (if B C)) assms)
        (== '(modus-ponens
              (A (if A B) (if B C))
              ((assumption (A (if A B) (if B C)) () (if B C))
               (modus-ponens
                (A (if A B) (if B C))
                ((assumption (A (if A B) (if B C)) () (if A B))
                 (assumption (A (if A B) (if B C)) () A)) B))
              C)
            prf)
        (evalo
         `(letrec ((member? (lambda (x ls)
                              (if (null? ls)
                                  #f
                                  (if (equal? (car ls) x)
                                      #t
                                      (member? x (cdr ls)))))))
            (letrec ((proof? (lambda (proof)
                               (match proof
                                 [`(assumption ,assms () ,A)
                                  (member? A assms)]
                                 [`(modus-ponens
                                    ,assms
                                    ((,r1 ,assms ,ants1 (if ,A ,B))
                                     (,r2 ,assms ,ants2 ,A))
                                    ,B)
                                  (and (proof? (list r1 assms ants1 (list 'if A B)))
                                       (proof? (list r2 assms ants2 A)))]))))
              (proof? ',prf)))
         #t)))
    '(((modus-ponens (A (if A B) (if B C))
                     ((assumption (A (if A B) (if B C)) () (if B C))
                      (modus-ponens (A (if A B) (if B C))
                                    ((assumption (A (if A B) (if B C)) () (if A B))
                                     (assumption (A (if A B) (if B C)) () A))
                                    B))
                     C)))))

(time
  (test "proof-2c"
    (run 1 (prf)
      (fresh (rule assms ants)
        ;; We want to prove that C holds...
        (== `(,rule ,assms ,ants C) prf)
        ;; ...given the assumptions A, A => B, and B => C.
        (== `(A (if A B) (if B C)) assms)
        (evalo
         `(letrec ((member? (lambda (x ls)
                              (if (null? ls)
                                  #f
                                  (if (equal? (car ls) x)
                                      #t
                                      (member? x (cdr ls)))))))
            (letrec ((proof? (lambda (proof)
                               (match proof
                                 [`(assumption ,assms () ,A)
                                  (member? A assms)]
                                 [`(modus-ponens
                                    ,assms
                                    ((,r1 ,assms ,ants1 (if ,A ,B))
                                     (,r2 ,assms ,ants2 ,A))
                                    ,B)
                                  (and (proof? (list r1 assms ants1 (list 'if A B)))
                                       (proof? (list r2 assms ants2 A)))]))))
              (proof? ',prf)))
         #t)))
    '(((modus-ponens (A (if A B) (if B C))
                     ((assumption (A (if A B) (if B C)) () (if B C))
                      (modus-ponens (A (if A B) (if B C))
                                    ((assumption (A (if A B) (if B C)) () (if A B))
                                     (assumption (A (if A B) (if B C)) () A))
                                    B))
                     C)))))

(time
  (test "generate-theorems/proofs"
    (length (run 20 (prf)
              (evalo
               `(letrec ((member? (lambda (x ls)
                                    (if (null? ls)
                                        #f
                                        (if (equal? (car ls) x)
                                            #t
                                            (member? x (cdr ls)))))))
                  (letrec ((proof? (lambda (proof)
                                     (match proof
                                       [`(assumption ,assms () ,A)
                                        (member? A assms)]
                                       [`(modus-ponens
                                          ,assms
                                          ((,r1 ,assms ,ants1 (if ,A ,B))
                                           (,r2 ,assms ,ants2 ,A))
                                          ,B)
                                        (and (proof? (list r1 assms ants1 (list 'if A B)))
                                             (proof? (list r2 assms ants2 A)))]))))
                    (proof? ',prf)))
               #t)))
    '20))

(time
  (test "generate-theorems/proofs-using-modus-ponens"
    (length (run 20 (prf)
              (fresh (assms ants conseq)
                (== `(modus-ponens ,assms ,ants ,conseq) prf)
                (evalo
                 `(letrec ((member? (lambda (x ls)
                                      (if (null? ls)
                                          #f
                                          (if (equal? (car ls) x)
                                              #t
                                              (member? x (cdr ls)))))))
                    (letrec ((proof? (lambda (proof)
                                       (match proof
                                         [`(assumption ,assms () ,A)
                                          (member? A assms)]
                                         [`(modus-ponens
                                            ,assms
                                            ((,r1 ,assms ,ants1 (if ,A ,B))
                                             (,r2 ,assms ,ants2 ,A))
                                            ,B)
                                          (and (proof? (list r1 assms ants1 (list 'if A B)))
                                               (proof? (list r2 assms ants2 A)))]))))
                      (proof? ',prf)))
                 #t))))
    '20))

(time
  (test "generate-non-theorems/proofs"
    (length (run 20 (prf)
              (evalo
               `(letrec ((member? (lambda (x ls)
                                    (if (null? ls)
                                        #f
                                        (if (equal? (car ls) x)
                                            #t
                                            (member? x (cdr ls)))))))
                  (letrec ((proof? (lambda (proof)
                                     (match proof
                                       [`(assumption ,assms () ,A)
                                        (member? A assms)]
                                       [`(modus-ponens
                                          ,assms
                                          ((,r1 ,assms ,ants1 (if ,A ,B))
                                           (,r2 ,assms ,ants2 ,A))
                                          ,B)
                                        (and (proof? (list r1 assms ants1 (list 'if A B)))
                                             (proof? (list r2 assms ants2 A)))]))))
                    (proof? ',prf)))
               #f)))
    '20))



;; unit tests

; or
; num
; symbol?
; not
(time
  (test 'stupor-test-1
    (run* (q)
      (evalo '(letrec ((assoc (lambda (x l)
                                 (if (null? l)
                                     0
                                     (if (or (not (symbol? x))
                                             (not (equal? (car (car l)) x)))
                                         (assoc x (cdr l))
                                         (car l))))))
                (assoc 'foo '((bar . 1) (baz . 2) (42 . ignore) (foo . 3) (quux . 4))))
             q))
    '(((foo . 3)))))


;; append

(time
  (test 'append-simple-1
    (run* (q)
      (evalo '(letrec ((append (lambda (l s)
                                 (if (null? l)
                                     s
                                     (cons (car l)
                                           (append (cdr l) s))))))
                (append '(1 2 3) '(4 5)))
             q))
    '(((1 2 3 4 5)))))

(time
  (test 'append-simple-2
    (run* (q)
      (evalo `(letrec ((append (lambda (l s)
                                 (if (null? l)
                                     s
                                     (cons (car l)
                                           (append (cdr l) s))))))
                (append ',q '(4 5)))
             '(1 2 3 4 5)))
    '(((1 2 3)))))

(time
  (test 'append-simple-3
    (run* (x y)
      (evalo `(letrec ((append (lambda (l s)
                                 (if (null? l)
                                     s
                                     (cons (car l)
                                           (append (cdr l) s))))))
                (append ',x ',y))
             '(1 2 3 4 5)))
    '(((() (1 2 3 4 5)))
      (((1) (2 3 4 5)))
      (((1 2) (3 4 5)))
      (((1 2 3) (4 5)))
      (((1 2 3 4) (5)))
      (((1 2 3 4 5) ())))))

;; Tests from 2017 pearl

(time
  (test "proof-backwards-explicit-member?"
    (run 1 (prf)
      (fresh (rule assms ants)
        ;; We want to prove that C holds...
        (== `(,rule ,assms ,ants C) prf)
        ;; ...given the assumptions A, A => B, and B => C.
        (== `(A (if A B) (if B C)) assms)
        (evalo
         `(letrec ((member? (lambda (x ls)
                              (if (null? ls)
                                  #f
                                  (if (equal? (car ls) x)
                                      #t
                                      (member? x (cdr ls)))))))
            (letrec ((proof? (lambda (proof)
                               (match proof
                                 [`(assumption ,assms () ,A)
                                  (member? A assms)]
                                 [`(modus-ponens
                                    ,assms
                                    ((,r1 ,assms ,ants1 (if ,A ,B))
                                     (,r2 ,assms ,ants2 ,A))
                                    ,B)
                                  (and (proof? (list r1 assms ants1 (list 'if A B)))
                                       (proof? (list r2 assms ants2 A)))]))))
              (proof? ',prf)))
         #t)))
    '(((modus-ponens (A (if A B) (if B C))
                     ((assumption (A (if A B) (if B C)) () (if B C))
                      (modus-ponens (A (if A B) (if B C))
                                    ((assumption (A (if A B) (if B C)) () (if A B))
                                     (assumption (A (if A B) (if B C)) () A))
                                    B))
                     C)))))

(time
  (test "check quine"
    (run 1 (q)
      (== q '((lambda (x) `(,x ',x)) '(lambda (x) `(,x ',x))))
      (evalo
       `(letrec ((eval-quasi (lambda (q eval)
                               (match q
                                 [(? symbol? x) x]
                                 [`() '()]
                                 [`(,`unquote ,exp) (eval exp)]
                                 [`(quasiquote ,datum) ('error)]
                                 [`(,a . ,d)
                                  (cons (eval-quasi a eval) (eval-quasi d eval))]))))
          (letrec ((eval-expr
                    (lambda (expr env)
                      (match expr
                        [`(quote ,datum) datum]
                        [`(lambda (,(? symbol? x)) ,body)
                         (lambda (a)
                           (eval-expr body (lambda (y)
                                             (if (equal? x y)
                                                 a
                                                 (env y)))))]
                        [(? symbol? x) (env x)]
                        [`(quasiquote ,datum)
                         (eval-quasi datum (lambda (exp) (eval-expr exp env)))]
                        [`(,rator ,rand)
                         ((eval-expr rator env) (eval-expr rand env))]
                        ))))
            (eval-expr ',q
                       'initial-env)))
       q))
    (list '(((lambda (x) `(,x ',x)) '(lambda (x) `(,x ',x)))))))
