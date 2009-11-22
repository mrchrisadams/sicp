; Define a procedure that takes three numbers as arguments and returns the sum 
;of the squares of the two larger numbers.

; first define how to square
(define (square x) (* x x))

; then define the main compound procedure
(define (sum-of-two-largest-squares x y z) 
  (
    cond 
      ;if one of the params passed in is less than or equal to the other
      ;two values, by default the other two must be the largest ones, as
      ;we only have three numbers to choose from
      ((and (<= x y) (<= x z) ) (+ (square y) (square z)))
      ((and (<= y z) (<= y x) ) (+ (square x) (square z))) 
      ((and (<= z y) (<= z x) ) (+ (square y) (square x)))
  )
)
