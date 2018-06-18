(begin
  (define array:opt-args '(tter (3 -1 0 1) (5 0) (8)))
  (define (array:optimize f r)
    (case r
      ((0) (let ((n0 (f))) (array:0 n0)))
      ((1) (let ((n0 (f 0))) (array:1 n0 (- (f 1) n0))))
      ((2)
       (let ((n0 (f 0 0)))
         (array:2 n0 (- (f 1 0) n0) (- (f 0 1) n0))))
      ((3)
       (let ((n0 (f 0 0 0)))
         (array:3
           n0
           (- (f 1 0 0) n0)
           (- (f 0 1 0) n0)
           (- (f 0 0 1) n0))))
      ((4)
       (let ((n0 (f 0 0 0 0)))
         (array:4
           n0
           (- (f 1 0 0 0) n0)
           (- (f 0 1 0 0) n0)
           (- (f 0 0 1 0) n0)
           (- (f 0 0 0 1) n0))))
      ((5)
       (let ((n0 (f 0 0 0 0 0)))
         (array:5
           n0
           (- (f 1 0 0 0 0) n0)
           (- (f 0 1 0 0 0) n0)
           (- (f 0 0 1 0 0) n0)
           (- (f 0 0 0 1 0) n0)
           (- (f 0 0 0 0 1) n0))))
      ((6)
       (let ((n0 (f 0 0 0 0 0 0)))
         (array:6
           n0
           (- (f 1 0 0 0 0 0) n0)
           (- (f 0 1 0 0 0 0) n0)
           (- (f 0 0 1 0 0 0) n0)
           (- (f 0 0 0 1 0 0) n0)
           (- (f 0 0 0 0 1 0) n0)
           (- (f 0 0 0 0 0 1) n0))))
      ((7)
       (let ((n0 (f 0 0 0 0 0 0 0)))
         (array:7
           n0
           (- (f 1 0 0 0 0 0 0) n0)
           (- (f 0 1 0 0 0 0 0) n0)
           (- (f 0 0 1 0 0 0 0) n0)
           (- (f 0 0 0 1 0 0 0) n0)
           (- (f 0 0 0 0 1 0 0) n0)
           (- (f 0 0 0 0 0 1 0) n0)
           (- (f 0 0 0 0 0 0 1) n0))))
      (else
       (let ((v
              (do ((k 0 (+ k 1)) (v '() (cons 0 v)))
                  ((= k r) v))))
         (let ((n0 (apply f v)))
           (let ((cs (array:coefficients f n0 v v)))
             "bug -- the cons should be in array:n"
             (cons
              (apply array:n n0 cs)
              (apply array:n! n0 cs))))))))
  (define (array:optimize-empty r)
    (cons
     (lambda ks -1)
     (lambda (v . kso)
       (vector-set! v -1 (car (reverse kso))))))
  (define (array:coefficients f n0 vs vp)
    (case vp
      ((()) '())
      (else
       (set-car! vp 1)
       (let ((n (- (apply f vs) n0)))
         (set-car! vp 0)
         (cons n (array:coefficients f n0 vs (cdr vp)))))))
  (define (array:vector-index x ks) (apply (car x) ks))
  (define (array:shape-index)
    (cons
     (lambda (r k) (+ r r k))
     (lambda (v r k o) (vector-set! v (+ r r k) o))))
  (define (array:empty-shape-index)
    (cons
     (lambda (r k) -1)
     (lambda (v r k o) (vector-set! v -1 o))))
  (define (array:shape-vector-index x r k) ((car x) r k))
  (define (array:actor-index x k) ((car x) k))
  (define (array:0 n0)
    (if (= n0 0)
      (cons (array:0+0) (array:0+0!))
      (cons (array:0+n n0) (array:0+n! n0))))
  (define (array:0+0) (lambda () 0))
  (define (array:0+0!) (lambda (v o) (vector-set! v 0 o)))
  (define (array:0+n n0) (lambda () n0))
  (define (array:0+n! n0)
    (lambda (v o) (vector-set! v n0 o)))
  (define (array:1 n0 n1)
    (if (= n0 0)
      (case n1
        ((-1) (cons (array:1+0-1) (array:1+0-1!)))
        ((0) (cons (array:1+0+0) (array:1+0+0!)))
        ((1) (cons (array:1+0+1) (array:1+0+1!)))
        (else (cons (array:1+0+n n1) (array:1+0+n! n1))))
      (case n1
        ((-1) (cons (array:1+n-1 n0) (array:1+n-1! n0)))
        ((0) (cons (array:1+n+0 n0) (array:1+n+0! n0)))
        ((1) (cons (array:1+n+1 n0) (array:1+n+1! n0)))
        (else
         (cons (array:1+n+n n0 n1) (array:1+n+n! n0 n1))))))
  (define (array:1+0-1) (lambda (k1) (- k1)))
  (define (array:1+0-1!)
    (lambda (v k1 o) (vector-set! v (- k1) o)))
  (define (array:1+0+0) (lambda (k1) 0))
  (define (array:1+0+0!)
    (lambda (v k1 o) (vector-set! v 0 o)))
  (define (array:1+0+1) (lambda (k1) k1))
  (define (array:1+0+1!)
    (lambda (v k1 o) (vector-set! v k1 o)))
  (define (array:1+0+n n1) (lambda (k1) (* n1 k1)))
  (define (array:1+0+n! n1)
    (lambda (v k1 o) (vector-set! v (* n1 k1) o)))
  (define (array:1+n-1 n0) (lambda (k1) (+ n0 (- k1))))
  (define (array:1+n-1! n0)
    (lambda (v k1 o) (vector-set! v (+ n0 (- k1)) o)))
  (define (array:1+n+0 n0) (lambda (k1) n0))
  (define (array:1+n+0! n0)
    (lambda (v k1 o) (vector-set! v n0 o)))
  (define (array:1+n+1 n0) (lambda (k1) (+ n0 k1)))
  (define (array:1+n+1! n0)
    (lambda (v k1 o) (vector-set! v (+ n0 k1) o)))
  (define (array:1+n+n n0 n1)
    (lambda (k1) (+ n0 (* n1 k1))))
  (define (array:1+n+n! n0 n1)
    (lambda (v k1 o) (vector-set! v (+ n0 (* n1 k1)) o)))
  (define (array:2 n0 n1 n2)
    (if (= n0 0)
      (case n1
        ((-1)
         (case n2
           ((-1) (cons (array:2+0-1-1) (array:2+0-1-1!)))
           ((0) (cons (array:2+0-1+0) (array:2+0-1+0!)))
           ((1) (cons (array:2+0-1+1) (array:2+0-1+1!)))
           (else
            (cons (array:2+0-1+n n2) (array:2+0-1+n! n2)))))
        ((0)
         (case n2
           ((-1) (cons (array:2+0+0-1) (array:2+0+0-1!)))
           ((0) (cons (array:2+0+0+0) (array:2+0+0+0!)))
           ((1) (cons (array:2+0+0+1) (array:2+0+0+1!)))
           (else
            (cons (array:2+0+0+n n2) (array:2+0+0+n! n2)))))
        ((1)
         (case n2
           ((-1) (cons (array:2+0+1-1) (array:2+0+1-1!)))
           ((0) (cons (array:2+0+1+0) (array:2+0+1+0!)))
           ((1) (cons (array:2+0+1+1) (array:2+0+1+1!)))
           (else
            (cons (array:2+0+1+n n2) (array:2+0+1+n! n2)))))
        (else
         (case n2
           ((-1)
            (cons (array:2+0+n-1 n1) (array:2+0+n-1! n1)))
           ((0)
            (cons (array:2+0+n+0 n1) (array:2+0+n+0! n1)))
           ((1)
            (cons (array:2+0+n+1 n1) (array:2+0+n+1! n1)))
           (else
            (cons
             (array:2+0+n+n n1 n2)
             (array:2+0+n+n! n1 n2))))))
      (case n1
        ((-1)
         (case n2
           ((-1)
            (cons (array:2+n-1-1 n0) (array:2+n-1-1! n0)))
           ((0)
            (cons (array:2+n-1+0 n0) (array:2+n-1+0! n0)))
           ((1)
            (cons (array:2+n-1+1 n0) (array:2+n-1+1! n0)))
           (else
            (cons
             (array:2+n-1+n n0 n2)
             (array:2+n-1+n! n0 n2)))))
        ((0)
         (case n2
           ((-1)
            (cons (array:2+n+0-1 n0) (array:2+n+0-1! n0)))
           ((0)
            (cons (array:2+n+0+0 n0) (array:2+n+0+0! n0)))
           ((1)
            (cons (array:2+n+0+1 n0) (array:2+n+0+1! n0)))
           (else
            (cons
             (array:2+n+0+n n0 n2)
             (array:2+n+0+n! n0 n2)))))
        ((1)
         (case n2
           ((-1)
            (cons (array:2+n+1-1 n0) (array:2+n+1-1! n0)))
           ((0)
            (cons (array:2+n+1+0 n0) (array:2+n+1+0! n0)))
           ((1)
            (cons (array:2+n+1+1 n0) (array:2+n+1+1! n0)))
           (else
            (cons
             (array:2+n+1+n n0 n2)
             (array:2+n+1+n! n0 n2)))))
        (else
         (case n2
           ((-1)
            (cons
             (array:2+n+n-1 n0 n1)
             (array:2+n+n-1! n0 n1)))
           ((0)
            (cons
             (array:2+n+n+0 n0 n1)
             (array:2+n+n+0! n0 n1)))
           ((1)
            (cons
             (array:2+n+n+1 n0 n1)
             (array:2+n+n+1! n0 n1)))
           (else
            (cons
             (array:2+n+n+n n0 n1 n2)
             (array:2+n+n+n! n0 n1 n2))))))))
  (define (array:2+0-1-1)
    (lambda (k1 k2) (+ (- k1) (- k2))))
  (define (array:2+0-1-1!)
    (lambda (v k1 k2 o)
      (vector-set! v (+ (- k1) (- k2)) o)))
  (define (array:2+0-1+0) (lambda (k1 k2) (- k1)))
  (define (array:2+0-1+0!)
    (lambda (v k1 k2 o) (vector-set! v (- k1) o)))
  (define (array:2+0-1+1) (lambda (k1 k2) (+ (- k1) k2)))
  (define (array:2+0-1+1!)
    (lambda (v k1 k2 o) (vector-set! v (+ (- k1) k2) o)))
  (define (array:2+0-1+n n2)
    (lambda (k1 k2) (+ (- k1) (* n2 k2))))
  (define (array:2+0-1+n! n2)
    (lambda (v k1 k2 o)
      (vector-set! v (+ (- k1) (* n2 k2)) o)))
  (define (array:2+0+0-1) (lambda (k1 k2) (- k2)))
  (define (array:2+0+0-1!)
    (lambda (v k1 k2 o) (vector-set! v (- k2) o)))
  (define (array:2+0+0+0) (lambda (k1 k2) 0))
  (define (array:2+0+0+0!)
    (lambda (v k1 k2 o) (vector-set! v 0 o)))
  (define (array:2+0+0+1) (lambda (k1 k2) k2))
  (define (array:2+0+0+1!)
    (lambda (v k1 k2 o) (vector-set! v k2 o)))
  (define (array:2+0+0+n n2) (lambda (k1 k2) (* n2 k2)))
  (define (array:2+0+0+n! n2)
    (lambda (v k1 k2 o) (vector-set! v (* n2 k2) o)))
  (define (array:2+0+1-1) (lambda (k1 k2) (+ k1 (- k2))))
  (define (array:2+0+1-1!)
    (lambda (v k1 k2 o) (vector-set! v (+ k1 (- k2)) o)))
  (define (array:2+0+1+0) (lambda (k1 k2) k1))
  (define (array:2+0+1+0!)
    (lambda (v k1 k2 o) (vector-set! v k1 o)))
  (define (array:2+0+1+1) (lambda (k1 k2) (+ k1 k2)))
  (define (array:2+0+1+1!)
    (lambda (v k1 k2 o) (vector-set! v (+ k1 k2) o)))
  (define (array:2+0+1+n n2)
    (lambda (k1 k2) (+ k1 (* n2 k2))))
  (define (array:2+0+1+n! n2)
    (lambda (v k1 k2 o) (vector-set! v (+ k1 (* n2 k2)) o)))
  (define (array:2+0+n-1 n1)
    (lambda (k1 k2) (+ (* n1 k1) (- k2))))
  (define (array:2+0+n-1! n1)
    (lambda (v k1 k2 o)
      (vector-set! v (+ (* n1 k1) (- k2)) o)))
  (define (array:2+0+n+0 n1) (lambda (k1 k2) (* n1 k1)))
  (define (array:2+0+n+0! n1)
    (lambda (v k1 k2 o) (vector-set! v (* n1 k1) o)))
  (define (array:2+0+n+1 n1)
    (lambda (k1 k2) (+ (* n1 k1) k2)))
  (define (array:2+0+n+1! n1)
    (lambda (v k1 k2 o) (vector-set! v (+ (* n1 k1) k2) o)))
  (define (array:2+0+n+n n1 n2)
    (lambda (k1 k2) (+ (* n1 k1) (* n2 k2))))
  (define (array:2+0+n+n! n1 n2)
    (lambda (v k1 k2 o)
      (vector-set! v (+ (* n1 k1) (* n2 k2)) o)))
  (define (array:2+n-1-1 n0)
    (lambda (k1 k2) (+ n0 (- k1) (- k2))))
  (define (array:2+n-1-1! n0)
    (lambda (v k1 k2 o)
      (vector-set! v (+ n0 (- k1) (- k2)) o)))
  (define (array:2+n-1+0 n0) (lambda (k1 k2) (+ n0 (- k1))))
  (define (array:2+n-1+0! n0)
    (lambda (v k1 k2 o) (vector-set! v (+ n0 (- k1)) o)))
  (define (array:2+n-1+1 n0)
    (lambda (k1 k2) (+ n0 (- k1) k2)))
  (define (array:2+n-1+1! n0)
    (lambda (v k1 k2 o) (vector-set! v (+ n0 (- k1) k2) o)))
  (define (array:2+n-1+n n0 n2)
    (lambda (k1 k2) (+ n0 (- k1) (* n2 k2))))
  (define (array:2+n-1+n! n0 n2)
    (lambda (v k1 k2 o)
      (vector-set! v (+ n0 (- k1) (* n2 k2)) o)))
  (define (array:2+n+0-1 n0) (lambda (k1 k2) (+ n0 (- k2))))
  (define (array:2+n+0-1! n0)
    (lambda (v k1 k2 o) (vector-set! v (+ n0 (- k2)) o)))
  (define (array:2+n+0+0 n0) (lambda (k1 k2) n0))
  (define (array:2+n+0+0! n0)
    (lambda (v k1 k2 o) (vector-set! v n0 o)))
  (define (array:2+n+0+1 n0) (lambda (k1 k2) (+ n0 k2)))
  (define (array:2+n+0+1! n0)
    (lambda (v k1 k2 o) (vector-set! v (+ n0 k2) o)))
  (define (array:2+n+0+n n0 n2)
    (lambda (k1 k2) (+ n0 (* n2 k2))))
  (define (array:2+n+0+n! n0 n2)
    (lambda (v k1 k2 o) (vector-set! v (+ n0 (* n2 k2)) o)))
  (define (array:2+n+1-1 n0)
    (lambda (k1 k2) (+ n0 k1 (- k2))))
  (define (array:2+n+1-1! n0)
    (lambda (v k1 k2 o) (vector-set! v (+ n0 k1 (- k2)) o)))
  (define (array:2+n+1+0 n0) (lambda (k1 k2) (+ n0 k1)))
  (define (array:2+n+1+0! n0)
    (lambda (v k1 k2 o) (vector-set! v (+ n0 k1) o)))
  (define (array:2+n+1+1 n0) (lambda (k1 k2) (+ n0 k1 k2)))
  (define (array:2+n+1+1! n0)
    (lambda (v k1 k2 o) (vector-set! v (+ n0 k1 k2) o)))
  (define (array:2+n+1+n n0 n2)
    (lambda (k1 k2) (+ n0 k1 (* n2 k2))))
  (define (array:2+n+1+n! n0 n2)
    (lambda (v k1 k2 o)
      (vector-set! v (+ n0 k1 (* n2 k2)) o)))
  (define (array:2+n+n-1 n0 n1)
    (lambda (k1 k2) (+ n0 (* n1 k1) (- k2))))
  (define (array:2+n+n-1! n0 n1)
    (lambda (v k1 k2 o)
      (vector-set! v (+ n0 (* n1 k1) (- k2)) o)))
  (define (array:2+n+n+0 n0 n1)
    (lambda (k1 k2) (+ n0 (* n1 k1))))
  (define (array:2+n+n+0! n0 n1)
    (lambda (v k1 k2 o) (vector-set! v (+ n0 (* n1 k1)) o)))
  (define (array:2+n+n+1 n0 n1)
    (lambda (k1 k2) (+ n0 (* n1 k1) k2)))
  (define (array:2+n+n+1! n0 n1)
    (lambda (v k1 k2 o)
      (vector-set! v (+ n0 (* n1 k1) k2) o)))
  (define (array:2+n+n+n n0 n1 n2)
    (lambda (k1 k2) (+ n0 (* n1 k1) (* n2 k2))))
  (define (array:2+n+n+n! n0 n1 n2)
    (lambda (v k1 k2 o)
      (vector-set! v (+ n0 (* n1 k1) (* n2 k2)) o)))
  (define (array:3 n0 n1 n2 n3)
    (if (= n0 0)
      (case n1
        ((0)
         (case n2
           ((0)
            (case n3
              ((0)
               (cons (array:3+0+0+0+0) (array:3+0+0+0+0!)))
              (else
               (cons
                (array:3+0+0+0+n n3)
                (array:3+0+0+0+n! n3)))))
           (else
            (case n3
              ((0)
               (cons
                (array:3+0+0+n+0 n2)
                (array:3+0+0+n+0! n2)))
              (else
               (cons
                (array:3+0+0+n+n n2 n3)
                (array:3+0+0+n+n! n2 n3)))))))
        (else
         (case n2
           ((0)
            (case n3
              ((0)
               (cons
                (array:3+0+n+0+0 n1)
                (array:3+0+n+0+0! n1)))
              (else
               (cons
                (array:3+0+n+0+n n1 n3)
                (array:3+0+n+0+n! n1 n3)))))
           (else
            (case n3
              ((0)
               (cons
                (array:3+0+n+n+0 n1 n2)
                (array:3+0+n+n+0! n1 n2)))
              (else
               (cons
                (array:3+0+n+n+n n1 n2 n3)
                (array:3+0+n+n+n! n1 n2 n3))))))))
      (case n1
        ((0)
         (case n2
           ((0)
            (case n3
              ((0)
               (cons
                (array:3+n+0+0+0 n0)
                (array:3+n+0+0+0! n0)))
              (else
               (cons
                (array:3+n+0+0+n n0 n3)
                (array:3+n+0+0+n! n0 n3)))))
           (else
            (case n3
              ((0)
               (cons
                (array:3+n+0+n+0 n0 n2)
                (array:3+n+0+n+0! n0 n2)))
              (else
               (cons
                (array:3+n+0+n+n n0 n2 n3)
                (array:3+n+0+n+n! n0 n2 n3)))))))
        (else
         (case n2
           ((0)
            (case n3
              ((0)
               (cons
                (array:3+n+n+0+0 n0 n1)
                (array:3+n+n+0+0! n0 n1)))
              (else
               (cons
                (array:3+n+n+0+n n0 n1 n3)
                (array:3+n+n+0+n! n0 n1 n3)))))
           (else
            (case n3
              ((0)
               (cons
                (array:3+n+n+n+0 n0 n1 n2)
                (array:3+n+n+n+0! n0 n1 n2)))
              (else
               (cons
                (array:3+n+n+n+n n0 n1 n2 n3)
                (array:3+n+n+n+n! n0 n1 n2 n3))))))))))
  (define (array:3+0+0+0+0) (lambda (k1 k2 k3) 0))
  (define (array:3+0+0+0+0!)
    (lambda (v k1 k2 k3 o) (vector-set! v 0 o)))
  (define (array:3+0+0+0+n n3)
    (lambda (k1 k2 k3) (* n3 k3)))
  (define (array:3+0+0+0+n! n3)
    (lambda (v k1 k2 k3 o) (vector-set! v (* n3 k3) o)))
  (define (array:3+0+0+n+0 n2)
    (lambda (k1 k2 k3) (* n2 k2)))
  (define (array:3+0+0+n+0! n2)
    (lambda (v k1 k2 k3 o) (vector-set! v (* n2 k2) o)))
  (define (array:3+0+0+n+n n2 n3)
    (lambda (k1 k2 k3) (+ (* n2 k2) (* n3 k3))))
  (define (array:3+0+0+n+n! n2 n3)
    (lambda (v k1 k2 k3 o)
      (vector-set! v (+ (* n2 k2) (* n3 k3)) o)))
  (define (array:3+0+n+0+0 n1)
    (lambda (k1 k2 k3) (* n1 k1)))
  (define (array:3+0+n+0+0! n1)
    (lambda (v k1 k2 k3 o) (vector-set! v (* n1 k1) o)))
  (define (array:3+0+n+0+n n1 n3)
    (lambda (k1 k2 k3) (+ (* n1 k1) (* n3 k3))))
  (define (array:3+0+n+0+n! n1 n3)
    (lambda (v k1 k2 k3 o)
      (vector-set! v (+ (* n1 k1) (* n3 k3)) o)))
  (define (array:3+0+n+n+0 n1 n2)
    (lambda (k1 k2 k3) (+ (* n1 k1) (* n2 k2))))
  (define (array:3+0+n+n+0! n1 n2)
    (lambda (v k1 k2 k3 o)
      (vector-set! v (+ (* n1 k1) (* n2 k2)) o)))
  (define (array:3+0+n+n+n n1 n2 n3)
    (lambda (k1 k2 k3) (+ (* n1 k1) (* n2 k2) (* n3 k3))))
  (define (array:3+0+n+n+n! n1 n2 n3)
    (lambda (v k1 k2 k3 o)
      (vector-set! v (+ (* n1 k1) (* n2 k2) (* n3 k3)) o)))
  (define (array:3+n+0+0+0 n0) (lambda (k1 k2 k3) n0))
  (define (array:3+n+0+0+0! n0)
    (lambda (v k1 k2 k3 o) (vector-set! v n0 o)))
  (define (array:3+n+0+0+n n0 n3)
    (lambda (k1 k2 k3) (+ n0 (* n3 k3))))
  (define (array:3+n+0+0+n! n0 n3)
    (lambda (v k1 k2 k3 o)
      (vector-set! v (+ n0 (* n3 k3)) o)))
  (define (array:3+n+0+n+0 n0 n2)
    (lambda (k1 k2 k3) (+ n0 (* n2 k2))))
  (define (array:3+n+0+n+0! n0 n2)
    (lambda (v k1 k2 k3 o)
      (vector-set! v (+ n0 (* n2 k2)) o)))
  (define (array:3+n+0+n+n n0 n2 n3)
    (lambda (k1 k2 k3) (+ n0 (* n2 k2) (* n3 k3))))
  (define (array:3+n+0+n+n! n0 n2 n3)
    (lambda (v k1 k2 k3 o)
      (vector-set! v (+ n0 (* n2 k2) (* n3 k3)) o)))
  (define (array:3+n+n+0+0 n0 n1)
    (lambda (k1 k2 k3) (+ n0 (* n1 k1))))
  (define (array:3+n+n+0+0! n0 n1)
    (lambda (v k1 k2 k3 o)
      (vector-set! v (+ n0 (* n1 k1)) o)))
  (define (array:3+n+n+0+n n0 n1 n3)
    (lambda (k1 k2 k3) (+ n0 (* n1 k1) (* n3 k3))))
  (define (array:3+n+n+0+n! n0 n1 n3)
    (lambda (v k1 k2 k3 o)
      (vector-set! v (+ n0 (* n1 k1) (* n3 k3)) o)))
  (define (array:3+n+n+n+0 n0 n1 n2)
    (lambda (k1 k2 k3) (+ n0 (* n1 k1) (* n2 k2))))
  (define (array:3+n+n+n+0! n0 n1 n2)
    (lambda (v k1 k2 k3 o)
      (vector-set! v (+ n0 (* n1 k1) (* n2 k2)) o)))
  (define (array:3+n+n+n+n n0 n1 n2 n3)
    (lambda (k1 k2 k3)
      (+ n0 (* n1 k1) (* n2 k2) (* n3 k3))))
  (define (array:3+n+n+n+n! n0 n1 n2 n3)
    (lambda (v k1 k2 k3 o)
      (vector-set!
        v
        (+ n0 (* n1 k1) (* n2 k2) (* n3 k3))
        o)))
  (define (array:4 n0 n1 n2 n3 n4)
    (if (= n0 0)
      (case n1
        ((0)
         (case n2
           ((0)
            (case n3
              ((0)
               (case n4
                 ((0)
                  (cons
                   (array:4+0+0+0+0+0)
                   (array:4+0+0+0+0+0!)))
                 (else
                  (cons
                   (array:4+0+0+0+0+n n4)
                   (array:4+0+0+0+0+n! n4)))))
              (else
               (case n4
                 ((0)
                  (cons
                   (array:4+0+0+0+n+0 n3)
                   (array:4+0+0+0+n+0! n3)))
                 (else
                  (cons
                   (array:4+0+0+0+n+n n3 n4)
                   (array:4+0+0+0+n+n! n3 n4)))))))
           (else
            (case n3
              ((0)
               (case n4
                 ((0)
                  (cons
                   (array:4+0+0+n+0+0 n2)
                   (array:4+0+0+n+0+0! n2)))
                 (else
                  (cons
                   (array:4+0+0+n+0+n n2 n4)
                   (array:4+0+0+n+0+n! n2 n4)))))
              (else
               (case n4
                 ((0)
                  (cons
                   (array:4+0+0+n+n+0 n2 n3)
                   (array:4+0+0+n+n+0! n2 n3)))
                 (else
                  (cons
                   (array:4+0+0+n+n+n n2 n3 n4)
                   (array:4+0+0+n+n+n! n2 n3 n4)))))))))
        (else
         (case n2
           ((0)
            (case n3
              ((0)
               (case n4
                 ((0)
                  (cons
                   (array:4+0+n+0+0+0 n1)
                   (array:4+0+n+0+0+0! n1)))
                 (else
                  (cons
                   (array:4+0+n+0+0+n n1 n4)
                   (array:4+0+n+0+0+n! n1 n4)))))
              (else
               (case n4
                 ((0)
                  (cons
                   (array:4+0+n+0+n+0 n1 n3)
                   (array:4+0+n+0+n+0! n1 n3)))
                 (else
                  (cons
                   (array:4+0+n+0+n+n n1 n3 n4)
                   (array:4+0+n+0+n+n! n1 n3 n4)))))))
           (else
            (case n3
              ((0)
               (case n4
                 ((0)
                  (cons
                   (array:4+0+n+n+0+0 n1 n2)
                   (array:4+0+n+n+0+0! n1 n2)))
                 (else
                  (cons
                   (array:4+0+n+n+0+n n1 n2 n4)
                   (array:4+0+n+n+0+n! n1 n2 n4)))))
              (else
               (case n4
                 ((0)
                  (cons
                   (array:4+0+n+n+n+0 n1 n2 n3)
                   (array:4+0+n+n+n+0! n1 n2 n3)))
                 (else
                  (cons
                   (array:4+0+n+n+n+n n1 n2 n3 n4)
                   (array:4+0+n+n+n+n! n1 n2 n3 n4))))))))))
      (case n1
        ((0)
         (case n2
           ((0)
            (case n3
              ((0)
               (case n4
                 ((0)
                  (cons
                   (array:4+n+0+0+0+0 n0)
                   (array:4+n+0+0+0+0! n0)))
                 (else
                  (cons
                   (array:4+n+0+0+0+n n0 n4)
                   (array:4+n+0+0+0+n! n0 n4)))))
              (else
               (case n4
                 ((0)
                  (cons
                   (array:4+n+0+0+n+0 n0 n3)
                   (array:4+n+0+0+n+0! n0 n3)))
                 (else
                  (cons
                   (array:4+n+0+0+n+n n0 n3 n4)
                   (array:4+n+0+0+n+n! n0 n3 n4)))))))
           (else
            (case n3
              ((0)
               (case n4
                 ((0)
                  (cons
                   (array:4+n+0+n+0+0 n0 n2)
                   (array:4+n+0+n+0+0! n0 n2)))
                 (else
                  (cons
                   (array:4+n+0+n+0+n n0 n2 n4)
                   (array:4+n+0+n+0+n! n0 n2 n4)))))
              (else
               (case n4
                 ((0)
                  (cons
                   (array:4+n+0+n+n+0 n0 n2 n3)
                   (array:4+n+0+n+n+0! n0 n2 n3)))
                 (else
                  (cons
                   (array:4+n+0+n+n+n n0 n2 n3 n4)
                   (array:4+n+0+n+n+n! n0 n2 n3 n4)))))))))
        (else
         (case n2
           ((0)
            (case n3
              ((0)
               (case n4
                 ((0)
                  (cons
                   (array:4+n+n+0+0+0 n0 n1)
                   (array:4+n+n+0+0+0! n0 n1)))
                 (else
                  (cons
                   (array:4+n+n+0+0+n n0 n1 n4)
                   (array:4+n+n+0+0+n! n0 n1 n4)))))
              (else
               (case n4
                 ((0)
                  (cons
                   (array:4+n+n+0+n+0 n0 n1 n3)
                   (array:4+n+n+0+n+0! n0 n1 n3)))
                 (else
                  (cons
                   (array:4+n+n+0+n+n n0 n1 n3 n4)
                   (array:4+n+n+0+n+n! n0 n1 n3 n4)))))))
           (else
            (case n3
              ((0)
               (case n4
                 ((0)
                  (cons
                   (array:4+n+n+n+0+0 n0 n1 n2)
                   (array:4+n+n+n+0+0! n0 n1 n2)))
                 (else
                  (cons
                   (array:4+n+n+n+0+n n0 n1 n2 n4)
                   (array:4+n+n+n+0+n! n0 n1 n2 n4)))))
              (else
               (case n4
                 ((0)
                  (cons
                   (array:4+n+n+n+n+0 n0 n1 n2 n3)
                   (array:4+n+n+n+n+0! n0 n1 n2 n3)))
                 (else
                  (cons
                   (array:4+n+n+n+n+n n0 n1 n2 n3 n4)
                   (array:4+n+n+n+n+n!
                     n0
                     n1
                     n2
                     n3
                     n4))))))))))))
  (define (array:4+0+0+0+0+0) (lambda (k1 k2 k3 k4) 0))
  (define (array:4+0+0+0+0+0!)
    (lambda (v k1 k2 k3 k4 o) (vector-set! v 0 o)))
  (define (array:4+0+0+0+0+n n4)
    (lambda (k1 k2 k3 k4) (* n4 k4)))
  (define (array:4+0+0+0+0+n! n4)
    (lambda (v k1 k2 k3 k4 o) (vector-set! v (* n4 k4) o)))
  (define (array:4+0+0+0+n+0 n3)
    (lambda (k1 k2 k3 k4) (* n3 k3)))
  (define (array:4+0+0+0+n+0! n3)
    (lambda (v k1 k2 k3 k4 o) (vector-set! v (* n3 k3) o)))
  (define (array:4+0+0+0+n+n n3 n4)
    (lambda (k1 k2 k3 k4) (+ (* n3 k3) (* n4 k4))))
  (define (array:4+0+0+0+n+n! n3 n4)
    (lambda (v k1 k2 k3 k4 o)
      (vector-set! v (+ (* n3 k3) (* n4 k4)) o)))
  (define (array:4+0+0+n+0+0 n2)
    (lambda (k1 k2 k3 k4) (* n2 k2)))
  (define (array:4+0+0+n+0+0! n2)
    (lambda (v k1 k2 k3 k4 o) (vector-set! v (* n2 k2) o)))
  (define (array:4+0+0+n+0+n n2 n4)
    (lambda (k1 k2 k3 k4) (+ (* n2 k2) (* n4 k4))))
  (define (array:4+0+0+n+0+n! n2 n4)
    (lambda (v k1 k2 k3 k4 o)
      (vector-set! v (+ (* n2 k2) (* n4 k4)) o)))
  (define (array:4+0+0+n+n+0 n2 n3)
    (lambda (k1 k2 k3 k4) (+ (* n2 k2) (* n3 k3))))
  (define (array:4+0+0+n+n+0! n2 n3)
    (lambda (v k1 k2 k3 k4 o)
      (vector-set! v (+ (* n2 k2) (* n3 k3)) o)))
  (define (array:4+0+0+n+n+n n2 n3 n4)
    (lambda (k1 k2 k3 k4)
      (+ (* n2 k2) (* n3 k3) (* n4 k4))))
  (define (array:4+0+0+n+n+n! n2 n3 n4)
    (lambda (v k1 k2 k3 k4 o)
      (vector-set! v (+ (* n2 k2) (* n3 k3) (* n4 k4)) o)))
  (define (array:4+0+n+0+0+0 n1)
    (lambda (k1 k2 k3 k4) (* n1 k1)))
  (define (array:4+0+n+0+0+0! n1)
    (lambda (v k1 k2 k3 k4 o) (vector-set! v (* n1 k1) o)))
  (define (array:4+0+n+0+0+n n1 n4)
    (lambda (k1 k2 k3 k4) (+ (* n1 k1) (* n4 k4))))
  (define (array:4+0+n+0+0+n! n1 n4)
    (lambda (v k1 k2 k3 k4 o)
      (vector-set! v (+ (* n1 k1) (* n4 k4)) o)))
  (define (array:4+0+n+0+n+0 n1 n3)
    (lambda (k1 k2 k3 k4) (+ (* n1 k1) (* n3 k3))))
  (define (array:4+0+n+0+n+0! n1 n3)
    (lambda (v k1 k2 k3 k4 o)
      (vector-set! v (+ (* n1 k1) (* n3 k3)) o)))
  (define (array:4+0+n+0+n+n n1 n3 n4)
    (lambda (k1 k2 k3 k4)
      (+ (* n1 k1) (* n3 k3) (* n4 k4))))
  (define (array:4+0+n+0+n+n! n1 n3 n4)
    (lambda (v k1 k2 k3 k4 o)
      (vector-set! v (+ (* n1 k1) (* n3 k3) (* n4 k4)) o)))
  (define (array:4+0+n+n+0+0 n1 n2)
    (lambda (k1 k2 k3 k4) (+ (* n1 k1) (* n2 k2))))
  (define (array:4+0+n+n+0+0! n1 n2)
    (lambda (v k1 k2 k3 k4 o)
      (vector-set! v (+ (* n1 k1) (* n2 k2)) o)))
  (define (array:4+0+n+n+0+n n1 n2 n4)
    (lambda (k1 k2 k3 k4)
      (+ (* n1 k1) (* n2 k2) (* n4 k4))))
  (define (array:4+0+n+n+0+n! n1 n2 n4)
    (lambda (v k1 k2 k3 k4 o)
      (vector-set! v (+ (* n1 k1) (* n2 k2) (* n4 k4)) o)))
  (define (array:4+0+n+n+n+0 n1 n2 n3)
    (lambda (k1 k2 k3 k4)
      (+ (* n1 k1) (* n2 k2) (* n3 k3))))
  (define (array:4+0+n+n+n+0! n1 n2 n3)
    (lambda (v k1 k2 k3 k4 o)
      (vector-set! v (+ (* n1 k1) (* n2 k2) (* n3 k3)) o)))
  (define (array:4+0+n+n+n+n n1 n2 n3 n4)
    (lambda (k1 k2 k3 k4)
      (+ (* n1 k1) (* n2 k2) (* n3 k3) (* n4 k4))))
  (define (array:4+0+n+n+n+n! n1 n2 n3 n4)
    (lambda (v k1 k2 k3 k4 o)
      (vector-set!
        v
        (+ (* n1 k1) (* n2 k2) (* n3 k3) (* n4 k4))
        o)))
  (define (array:4+n+0+0+0+0 n0) (lambda (k1 k2 k3 k4) n0))
  (define (array:4+n+0+0+0+0! n0)
    (lambda (v k1 k2 k3 k4 o) (vector-set! v n0 o)))
  (define (array:4+n+0+0+0+n n0 n4)
    (lambda (k1 k2 k3 k4) (+ n0 (* n4 k4))))
  (define (array:4+n+0+0+0+n! n0 n4)
    (lambda (v k1 k2 k3 k4 o)
      (vector-set! v (+ n0 (* n4 k4)) o)))
  (define (array:4+n+0+0+n+0 n0 n3)
    (lambda (k1 k2 k3 k4) (+ n0 (* n3 k3))))
  (define (array:4+n+0+0+n+0! n0 n3)
    (lambda (v k1 k2 k3 k4 o)
      (vector-set! v (+ n0 (* n3 k3)) o)))
  (define (array:4+n+0+0+n+n n0 n3 n4)
    (lambda (k1 k2 k3 k4) (+ n0 (* n3 k3) (* n4 k4))))
  (define (array:4+n+0+0+n+n! n0 n3 n4)
    (lambda (v k1 k2 k3 k4 o)
      (vector-set! v (+ n0 (* n3 k3) (* n4 k4)) o)))
  (define (array:4+n+0+n+0+0 n0 n2)
    (lambda (k1 k2 k3 k4) (+ n0 (* n2 k2))))
  (define (array:4+n+0+n+0+0! n0 n2)
    (lambda (v k1 k2 k3 k4 o)
      (vector-set! v (+ n0 (* n2 k2)) o)))
  (define (array:4+n+0+n+0+n n0 n2 n4)
    (lambda (k1 k2 k3 k4) (+ n0 (* n2 k2) (* n4 k4))))
  (define (array:4+n+0+n+0+n! n0 n2 n4)
    (lambda (v k1 k2 k3 k4 o)
      (vector-set! v (+ n0 (* n2 k2) (* n4 k4)) o)))
  (define (array:4+n+0+n+n+0 n0 n2 n3)
    (lambda (k1 k2 k3 k4) (+ n0 (* n2 k2) (* n3 k3))))
  (define (array:4+n+0+n+n+0! n0 n2 n3)
    (lambda (v k1 k2 k3 k4 o)
      (vector-set! v (+ n0 (* n2 k2) (* n3 k3)) o)))
  (define (array:4+n+0+n+n+n n0 n2 n3 n4)
    (lambda (k1 k2 k3 k4)
      (+ n0 (* n2 k2) (* n3 k3) (* n4 k4))))
  (define (array:4+n+0+n+n+n! n0 n2 n3 n4)
    (lambda (v k1 k2 k3 k4 o)
      (vector-set!
        v
        (+ n0 (* n2 k2) (* n3 k3) (* n4 k4))
        o)))
  (define (array:4+n+n+0+0+0 n0 n1)
    (lambda (k1 k2 k3 k4) (+ n0 (* n1 k1))))
  (define (array:4+n+n+0+0+0! n0 n1)
    (lambda (v k1 k2 k3 k4 o)
      (vector-set! v (+ n0 (* n1 k1)) o)))
  (define (array:4+n+n+0+0+n n0 n1 n4)
    (lambda (k1 k2 k3 k4) (+ n0 (* n1 k1) (* n4 k4))))
  (define (array:4+n+n+0+0+n! n0 n1 n4)
    (lambda (v k1 k2 k3 k4 o)
      (vector-set! v (+ n0 (* n1 k1) (* n4 k4)) o)))
  (define (array:4+n+n+0+n+0 n0 n1 n3)
    (lambda (k1 k2 k3 k4) (+ n0 (* n1 k1) (* n3 k3))))
  (define (array:4+n+n+0+n+0! n0 n1 n3)
    (lambda (v k1 k2 k3 k4 o)
      (vector-set! v (+ n0 (* n1 k1) (* n3 k3)) o)))
  (define (array:4+n+n+0+n+n n0 n1 n3 n4)
    (lambda (k1 k2 k3 k4)
      (+ n0 (* n1 k1) (* n3 k3) (* n4 k4))))
  (define (array:4+n+n+0+n+n! n0 n1 n3 n4)
    (lambda (v k1 k2 k3 k4 o)
      (vector-set!
        v
        (+ n0 (* n1 k1) (* n3 k3) (* n4 k4))
        o)))
  (define (array:4+n+n+n+0+0 n0 n1 n2)
    (lambda (k1 k2 k3 k4) (+ n0 (* n1 k1) (* n2 k2))))
  (define (array:4+n+n+n+0+0! n0 n1 n2)
    (lambda (v k1 k2 k3 k4 o)
      (vector-set! v (+ n0 (* n1 k1) (* n2 k2)) o)))
  (define (array:4+n+n+n+0+n n0 n1 n2 n4)
    (lambda (k1 k2 k3 k4)
      (+ n0 (* n1 k1) (* n2 k2) (* n4 k4))))
  (define (array:4+n+n+n+0+n! n0 n1 n2 n4)
    (lambda (v k1 k2 k3 k4 o)
      (vector-set!
        v
        (+ n0 (* n1 k1) (* n2 k2) (* n4 k4))
        o)))
  (define (array:4+n+n+n+n+0 n0 n1 n2 n3)
    (lambda (k1 k2 k3 k4)
      (+ n0 (* n1 k1) (* n2 k2) (* n3 k3))))
  (define (array:4+n+n+n+n+0! n0 n1 n2 n3)
    (lambda (v k1 k2 k3 k4 o)
      (vector-set!
        v
        (+ n0 (* n1 k1) (* n2 k2) (* n3 k3))
        o)))
  (define (array:4+n+n+n+n+n n0 n1 n2 n3 n4)
    (lambda (k1 k2 k3 k4)
      (+ n0 (* n1 k1) (* n2 k2) (* n3 k3) (* n4 k4))))
  (define (array:4+n+n+n+n+n! n0 n1 n2 n3 n4)
    (lambda (v k1 k2 k3 k4 o)
      (vector-set!
        v
        (+ n0 (* n1 k1) (* n2 k2) (* n3 k3) (* n4 k4))
        o)))
  (define (array:5 n0 n1 n2 n3 n4 n5)
    (case n1
      (else
       (case n2
         (else
          (case n3
            (else
             (case n4
               (else
                (case n5
                  (else
                   (cons
                    (array:5+n+n+n+n+n+n n0 n1 n2 n3 n4 n5)
                    (array:5+n+n+n+n+n+n!
                      n0
                      n1
                      n2
                      n3
                      n4
                      n5)))))))))))))
  (define (array:5+n+n+n+n+n+n n0 n1 n2 n3 n4 n5)
    (lambda (k1 k2 k3 k4 k5)
      (+
       n0
       (* n1 k1)
       (* n2 k2)
       (* n3 k3)
       (* n4 k4)
       (* n5 k5))))
  (define (array:5+n+n+n+n+n+n! n0 n1 n2 n3 n4 n5)
    (lambda (v k1 k2 k3 k4 k5 o)
      (vector-set!
        v
        (+
         n0
         (* n1 k1)
         (* n2 k2)
         (* n3 k3)
         (* n4 k4)
         (* n5 k5))
        o)))
  (define (array:6 n0 n1 n2 n3 n4 n5 n6)
    (case n1
      (else
       (case n2
         (else
          (case n3
            (else
             (case n4
               (else
                (case n5
                  (else
                   (case n6
                     (else
                      (cons
                       (array:6+n+n+n+n+n+n+n
                         n0
                         n1
                         n2
                         n3
                         n4
                         n5
                         n6)
                       (array:6+n+n+n+n+n+n+n!
                         n0
                         n1
                         n2
                         n3
                         n4
                         n5
                         n6)))))))))))))))
  (define (array:6+n+n+n+n+n+n+n n0 n1 n2 n3 n4 n5 n6)
    (lambda (k1 k2 k3 k4 k5 k6)
      (+
       n0
       (* n1 k1)
       (* n2 k2)
       (* n3 k3)
       (* n4 k4)
       (* n5 k5)
       (* n6 k6))))
  (define (array:6+n+n+n+n+n+n+n! n0 n1 n2 n3 n4 n5 n6)
    (lambda (v k1 k2 k3 k4 k5 k6 o)
      (vector-set!
        v
        (+
         n0
         (* n1 k1)
         (* n2 k2)
         (* n3 k3)
         (* n4 k4)
         (* n5 k5)
         (* n6 k6))
        o)))
  (define (array:7 n0 n1 n2 n3 n4 n5 n6 n7)
    (case n1
      (else
       (case n2
         (else
          (case n3
            (else
             (case n4
               (else
                (case n5
                  (else
                   (case n6
                     (else
                      (case n7
                        (else
                         (cons
                          (array:7+n+n+n+n+n+n+n+n
                            n0
                            n1
                            n2
                            n3
                            n4
                            n5
                            n6
                            n7)
                          (array:7+n+n+n+n+n+n+n+n!
                            n0
                            n1
                            n2
                            n3
                            n4
                            n5
                            n6
                            n7)))))))))))))))))
  (define (array:7+n+n+n+n+n+n+n+n n0 n1 n2 n3 n4 n5 n6 n7)
    (lambda (k1 k2 k3 k4 k5 k6 k7)
      (+
       n0
       (* n1 k1)
       (* n2 k2)
       (* n3 k3)
       (* n4 k4)
       (* n5 k5)
       (* n6 k6)
       (* n7 k7))))
  (define (array:7+n+n+n+n+n+n+n+n! n0 n1 n2 n3 n4 n5 n6 n7)
    (lambda (v k1 k2 k3 k4 k5 k6 k7 o)
      (vector-set!
        v
        (+
         n0
         (* n1 k1)
         (* n2 k2)
         (* n3 k3)
         (* n4 k4)
         (* n5 k5)
         (* n6 k6)
         (* n7 k7))
        o)))
  (define (array:n n0 n1 n2 n3 n4 n5 n6 n7 n8 . ns)
    (lambda (k1 k2 k3 k4 k5 k6 k7 k8 . ks)
      (do ((ns ns (cdr ns))
           (ks ks (cdr ks))
           (dx
            (+
             n0
             (* n1 k1)
             (* n2 k2)
             (* n3 k3)
             (* n4 k4)
             (* n5 k5)
             (* n6 k6)
             (* n7 k7)
             (* n8 k8))
            (+ dx (* (car ns) (car ks)))))
          ((null? ns) dx))))
  (define (array:n! n0 n1 n2 n3 n4 n5 n6 n7 n8 . ns)
    (lambda (v k1 k2 k3 k4 k5 k6 k7 k8 . ks)
      (do ((ns ns (cdr ns))
           (ks ks (cdr ks))
           (dx
            (+
             n0
             (* n1 k1)
             (* n2 k2)
             (* n3 k3)
             (* n4 k4)
             (* n5 k5)
             (* n6 k6)
             (* n7 k7)
             (* n8 k8))
            (+ dx (* (car ns) (car ks)))))
          ((null? ns) (vector-set! v dx (car ks))))))
  (define (array:maker r)
    (case r
      ((0) array:0)
      ((1) array:1)
      ((2) array:2)
      ((3) array:3)
      ((4) array:4)
      ((5) array:5)
      ((6) array:6)
      ((7) array:7)
      (else
       (lambda (n0 n1 n2 n3 n4 n5 n6 n7 n8 . ns)
         "bug -- the cons should be in array:n"
         (cons
          (apply array:n n0 n1 n2 n3 n4 n5 n6 n7 n8 ns)
          (apply
           array:n!
           n0
           n1
           n2
           n3
           n4
           n5
           n6
           n7
           n8
           ns))))))
  (define array:indexer/vector
    (let ((em
           (vector
             (lambda (x i) ((car x)))
             (lambda (x i) ((car x) (vector-ref i 0)))
             (lambda (x i)
               ((car x) (vector-ref i 0) (vector-ref i 1)))
             (lambda (x i)
               ((car x)
                (vector-ref i 0)
                (vector-ref i 1)
                (vector-ref i 2)))
             (lambda (x i)
               ((car x)
                (vector-ref i 0)
                (vector-ref i 1)
                (vector-ref i 2)
                (vector-ref i 3)))
             (lambda (x i)
               ((car x)
                (vector-ref i 0)
                (vector-ref i 1)
                (vector-ref i 2)
                (vector-ref i 3)
                (vector-ref i 4)))
             (lambda (x i)
               ((car x)
                (vector-ref i 0)
                (vector-ref i 1)
                (vector-ref i 2)
                (vector-ref i 3)
                (vector-ref i 4)
                (vector-ref i 5)))
             (lambda (x i)
               ((car x)
                (vector-ref i 0)
                (vector-ref i 1)
                (vector-ref i 2)
                (vector-ref i 3)
                (vector-ref i 4)
                (vector-ref i 5)
                (vector-ref i 6)))
             (lambda (x i)
               ((car x)
                (vector-ref i 0)
                (vector-ref i 1)
                (vector-ref i 2)
                (vector-ref i 3)
                (vector-ref i 4)
                (vector-ref i 5)
                (vector-ref i 6)
                (vector-ref i 7)))
             (lambda (x i)
               ((car x)
                (vector-ref i 0)
                (vector-ref i 1)
                (vector-ref i 2)
                (vector-ref i 3)
                (vector-ref i 4)
                (vector-ref i 5)
                (vector-ref i 6)
                (vector-ref i 7)
                (vector-ref i 8)))))
          (it
           (lambda (w)
             (lambda (x i)
               (apply
                (car x)
                (vector-ref i 0)
                (vector-ref i 1)
                (vector-ref i 2)
                (vector-ref i 3)
                (vector-ref i 4)
                (vector-ref i 5)
                (vector-ref i 6)
                (vector-ref i 7)
                (vector-ref i 8)
                (vector-ref i 9)
                (do ((ks '() (cons (vector-ref i u) ks))
                     (u (- w 1) (- u 1)))
                    ((< u 10) ks)))))))
      (lambda (r) (if (< r 10) (vector-ref em r) (it r)))))
  (define array:indexer/array
    (let ((em
           (vector
             (lambda (x v i) ((car x)))
             (lambda (x v i)
               ((car x)
                (vector-ref v (array:actor-index i 0))))
             (lambda (x v i)
               ((car x)
                (vector-ref v (array:actor-index i 0))
                (vector-ref v (array:actor-index i 1))))
             (lambda (x v i)
               ((car x)
                (vector-ref v (array:actor-index i 0))
                (vector-ref v (array:actor-index i 1))
                (vector-ref v (array:actor-index i 2))))
             (lambda (x v i)
               ((car x)
                (vector-ref v (array:actor-index i 0))
                (vector-ref v (array:actor-index i 1))
                (vector-ref v (array:actor-index i 2))
                (vector-ref v (array:actor-index i 3))))
             (lambda (x v i)
               ((car x)
                (vector-ref v (array:actor-index i 0))
                (vector-ref v (array:actor-index i 1))
                (vector-ref v (array:actor-index i 2))
                (vector-ref v (array:actor-index i 3))
                (vector-ref v (array:actor-index i 4))))
             (lambda (x v i)
               ((car x)
                (vector-ref v (array:actor-index i 0))
                (vector-ref v (array:actor-index i 1))
                (vector-ref v (array:actor-index i 2))
                (vector-ref v (array:actor-index i 3))
                (vector-ref v (array:actor-index i 4))
                (vector-ref v (array:actor-index i 5))))
             (lambda (x v i)
               ((car x)
                (vector-ref v (array:actor-index i 0))
                (vector-ref v (array:actor-index i 1))
                (vector-ref v (array:actor-index i 2))
                (vector-ref v (array:actor-index i 3))
                (vector-ref v (array:actor-index i 4))
                (vector-ref v (array:actor-index i 5))
                (vector-ref v (array:actor-index i 6))))
             (lambda (x v i)
               ((car x)
                (vector-ref v (array:actor-index i 0))
                (vector-ref v (array:actor-index i 1))
                (vector-ref v (array:actor-index i 2))
                (vector-ref v (array:actor-index i 3))
                (vector-ref v (array:actor-index i 4))
                (vector-ref v (array:actor-index i 5))
                (vector-ref v (array:actor-index i 6))
                (vector-ref v (array:actor-index i 7))))
             (lambda (x v i)
               ((car x)
                (vector-ref v (array:actor-index i 0))
                (vector-ref v (array:actor-index i 1))
                (vector-ref v (array:actor-index i 2))
                (vector-ref v (array:actor-index i 3))
                (vector-ref v (array:actor-index i 4))
                (vector-ref v (array:actor-index i 5))
                (vector-ref v (array:actor-index i 6))
                (vector-ref v (array:actor-index i 7))
                (vector-ref v (array:actor-index i 8))))))
          (it
           (lambda (w)
             (lambda (x v i)
               (apply
                (car x)
                (vector-ref v (array:actor-index i 0))
                (vector-ref v (array:actor-index i 1))
                (vector-ref v (array:actor-index i 2))
                (vector-ref v (array:actor-index i 3))
                (vector-ref v (array:actor-index i 4))
                (vector-ref v (array:actor-index i 5))
                (vector-ref v (array:actor-index i 6))
                (vector-ref v (array:actor-index i 7))
                (vector-ref v (array:actor-index i 8))
                (vector-ref v (array:actor-index i 9))
                (do ((ks
                      '()
                      (cons
                       (vector-ref
                         v
                         (array:actor-index i u))
                       ks))
                     (u (- w 1) (- u 1)))
                    ((< u 10) ks)))))))
      (lambda (r) (if (< r 10) (vector-ref em r) (it r)))))
  (define array:applier-to-vector
    (let ((em
           (vector
             (lambda (p v) (p))
             (lambda (p v) (p (vector-ref v 0)))
             (lambda (p v)
               (p (vector-ref v 0) (vector-ref v 1)))
             (lambda (p v)
               (p
                (vector-ref v 0)
                (vector-ref v 1)
                (vector-ref v 2)))
             (lambda (p v)
               (p
                (vector-ref v 0)
                (vector-ref v 1)
                (vector-ref v 2)
                (vector-ref v 3)))
             (lambda (p v)
               (p
                (vector-ref v 0)
                (vector-ref v 1)
                (vector-ref v 2)
                (vector-ref v 3)
                (vector-ref v 4)))
             (lambda (p v)
               (p
                (vector-ref v 0)
                (vector-ref v 1)
                (vector-ref v 2)
                (vector-ref v 3)
                (vector-ref v 4)
                (vector-ref v 5)))
             (lambda (p v)
               (p
                (vector-ref v 0)
                (vector-ref v 1)
                (vector-ref v 2)
                (vector-ref v 3)
                (vector-ref v 4)
                (vector-ref v 5)
                (vector-ref v 6)))
             (lambda (p v)
               (p
                (vector-ref v 0)
                (vector-ref v 1)
                (vector-ref v 2)
                (vector-ref v 3)
                (vector-ref v 4)
                (vector-ref v 5)
                (vector-ref v 6)
                (vector-ref v 7)))
             (lambda (p v)
               (p
                (vector-ref v 0)
                (vector-ref v 1)
                (vector-ref v 2)
                (vector-ref v 3)
                (vector-ref v 4)
                (vector-ref v 5)
                (vector-ref v 6)
                (vector-ref v 7)
                (vector-ref v 8)))))
          (it
           (lambda (r)
             (lambda (p v)
               (apply
                p
                (vector-ref v 0)
                (vector-ref v 1)
                (vector-ref v 2)
                (vector-ref v 3)
                (vector-ref v 4)
                (vector-ref v 5)
                (vector-ref v 6)
                (vector-ref v 7)
                (vector-ref v 8)
                (vector-ref v 9)
                (do ((k r (- k 1))
                     (r
                      '()
                      (cons (vector-ref v (- k 1)) r)))
                    ((= k 10) r)))))))
      (lambda (r) (if (< r 10) (vector-ref em r) (it r)))))
  (define array:applier-to-actor
    (let ((em
           (vector
             (lambda (p a) (p))
             (lambda (p a) (p (array-ref a 0)))
             (lambda (p a)
               (p (array-ref a 0) (array-ref a 1)))
             (lambda (p a)
               (p
                (array-ref a 0)
                (array-ref a 1)
                (array-ref a 2)))
             (lambda (p a)
               (p
                (array-ref a 0)
                (array-ref a 1)
                (array-ref a 2)
                (array-ref a 3)))
             (lambda (p a)
               (p
                (array-ref a 0)
                (array-ref a 1)
                (array-ref a 2)
                (array-ref a 3)
                (array-ref a 4)))
             (lambda (p a)
               (p
                (array-ref a 0)
                (array-ref a 1)
                (array-ref a 2)
                (array-ref a 3)
                (array-ref a 4)
                (array-ref a 5)))
             (lambda (p a)
               (p
                (array-ref a 0)
                (array-ref a 1)
                (array-ref a 2)
                (array-ref a 3)
                (array-ref a 4)
                (array-ref a 5)
                (array-ref a 6)))
             (lambda (p a)
               (p
                (array-ref a 0)
                (array-ref a 1)
                (array-ref a 2)
                (array-ref a 3)
                (array-ref a 4)
                (array-ref a 5)
                (array-ref a 6)
                (array-ref a 7)))
             (lambda (p a)
               (p
                (array-ref a 0)
                (array-ref a 1)
                (array-ref a 2)
                (array-ref a 3)
                (array-ref a 4)
                (array-ref a 5)
                (array-ref a 6)
                (array-ref a 7)
                (array-ref a 8)))))
          (it
           (lambda (r)
             (lambda (p a)
               (apply
                a
                (array-ref a 0)
                (array-ref a 1)
                (array-ref a 2)
                (array-ref a 3)
                (array-ref a 4)
                (array-ref a 5)
                (array-ref a 6)
                (array-ref a 7)
                (array-ref a 8)
                (array-ref a 9)
                (do ((k r (- k 1))
                     (r '() (cons (array-ref a (- k 1)) r)))
                    ((= k 10) r)))))))
      (lambda (r)
        "These are high level, hiding implementation at call site."
        (if (< r 10) (vector-ref em r) (it r)))))
  (define array:applier-to-backing-vector
    (let ((em
           (vector
             (lambda (p ai av) (p))
             (lambda (p ai av)
               (p (vector-ref av (array:actor-index ai 0))))
             (lambda (p ai av)
               (p
                (vector-ref av (array:actor-index ai 0))
                (vector-ref av (array:actor-index ai 1))))
             (lambda (p ai av)
               (p
                (vector-ref av (array:actor-index ai 0))
                (vector-ref av (array:actor-index ai 1))
                (vector-ref av (array:actor-index ai 2))))
             (lambda (p ai av)
               (p
                (vector-ref av (array:actor-index ai 0))
                (vector-ref av (array:actor-index ai 1))
                (vector-ref av (array:actor-index ai 2))
                (vector-ref av (array:actor-index ai 3))))
             (lambda (p ai av)
               (p
                (vector-ref av (array:actor-index ai 0))
                (vector-ref av (array:actor-index ai 1))
                (vector-ref av (array:actor-index ai 2))
                (vector-ref av (array:actor-index ai 3))
                (vector-ref av (array:actor-index ai 4))))
             (lambda (p ai av)
               (p
                (vector-ref av (array:actor-index ai 0))
                (vector-ref av (array:actor-index ai 1))
                (vector-ref av (array:actor-index ai 2))
                (vector-ref av (array:actor-index ai 3))
                (vector-ref av (array:actor-index ai 4))
                (vector-ref av (array:actor-index ai 5))))
             (lambda (p ai av)
               (p
                (vector-ref av (array:actor-index ai 0))
                (vector-ref av (array:actor-index ai 1))
                (vector-ref av (array:actor-index ai 2))
                (vector-ref av (array:actor-index ai 3))
                (vector-ref av (array:actor-index ai 4))
                (vector-ref av (array:actor-index ai 5))
                (vector-ref av (array:actor-index ai 6))))
             (lambda (p ai av)
               (p
                (vector-ref av (array:actor-index ai 0))
                (vector-ref av (array:actor-index ai 1))
                (vector-ref av (array:actor-index ai 2))
                (vector-ref av (array:actor-index ai 3))
                (vector-ref av (array:actor-index ai 4))
                (vector-ref av (array:actor-index ai 5))
                (vector-ref av (array:actor-index ai 6))
                (vector-ref av (array:actor-index ai 7))))
             (lambda (p ai av)
               (p
                (vector-ref av (array:actor-index ai 0))
                (vector-ref av (array:actor-index ai 1))
                (vector-ref av (array:actor-index ai 2))
                (vector-ref av (array:actor-index ai 3))
                (vector-ref av (array:actor-index ai 4))
                (vector-ref av (array:actor-index ai 5))
                (vector-ref av (array:actor-index ai 6))
                (vector-ref av (array:actor-index ai 7))
                (vector-ref av (array:actor-index ai 8))))))
          (it
           (lambda (r)
             (lambda (p ai av)
               (apply
                p
                (vector-ref av (array:actor-index ai 0))
                (vector-ref av (array:actor-index ai 1))
                (vector-ref av (array:actor-index ai 2))
                (vector-ref av (array:actor-index ai 3))
                (vector-ref av (array:actor-index ai 4))
                (vector-ref av (array:actor-index ai 5))
                (vector-ref av (array:actor-index ai 6))
                (vector-ref av (array:actor-index ai 7))
                (vector-ref av (array:actor-index ai 8))
                (vector-ref av (array:actor-index ai 9))
                (do ((k r (- k 1))
                     (r
                      '()
                      (cons
                       (vector-ref
                         av
                         (array:actor-index ai (- k 1)))
                       r)))
                    ((= k 10) r)))))))
      (lambda (r)
        "These are low level, exposing implementation at call site."
        (if (< r 10) (vector-ref em r) (it r)))))
  (define (array:index/vector r x v)
    ((array:indexer/vector r) x v))
  (define (array:index/array r x av ai)
    ((array:indexer/array r) x av ai))
  (define (array:apply-to-vector r p v)
    ((array:applier-to-vector r) p v))
  (define (array:apply-to-actor r p a)
    ((array:applier-to-actor r) p a)))
