;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname |le snakes|) (read-case-sensitive #t) (teachpacks ((lib "image.ss" "teachpack" "2htdp") (lib "batch-io.ss" "teachpack" "2htdp") (lib "universe.ss" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.ss" "teachpack" "2htdp") (lib "batch-io.ss" "teachpack" "2htdp") (lib "universe.ss" "teachpack" "2htdp")))))
;le physical constants
(define HEIGHT 60)
(define SCALE 60)
(define GRID-SIZE 13)

;le SNAKE
;the head of the snake
(define HEAD (circle (/ SCALE 3) "solid" "orange"))
;an alternate head I might use
(define HEADalt 
  (underlay/offset (circle 40 "solid" "gray")
                   0 -10
                   (underlay/offset (circle 10 "solid" "forestgreen")
                                   -30 0
                                   (circle 10 "solid" "forestgreen"))))

;the body circles
(define BODY (circle (/ SCALE 2) "solid" "purple"))

;le objects
(define FOOD (circle (/ SCALE 2) "solid" "forestgreen"))
(define BACKGROUND (empty-scene (* GRID-SIZE SCALE) (* GRID-SIZE HEIGHT) "black"))


(define Lose_Screen
  (empty-scene (* GRID-SIZE SCALE) (* GRID-SIZE HEIGHT) "red"))
(define Lose
  (text "YOU. ARE. TERRIBLE!" 48 "white"))

;World
;game-state --> image
;image to be placed into a window
(define (world-render gs)
  (let*([pos (game-pos gs)]
        [x (* SCALE(posn-x pos))]
        [y (* SCALE (posn-y pos))])
    (place-image HEAD
               x y
               BACKGROUND)))
     

;movement
;data definitions
;direction is current direction of travel for the worm, and is eiter
     ; 0  up
     ; 1  right
     ; 2  down
     ; 3  left
     
     
(define-struct game (pos dir body food))
(define initial-game (make-game (make-posn 5 5) 2 empty (make-posn 7 5)))

;pos=posn of worm
;dir=direction of travel
;Game -> Game
(define (move gs)
  (let*([pos(game-pos gs)]
          [dir  (game-dir gs)]
          [body (game-body gs)]
          [food (game-food gs)]
          [x (posn-x pos)]
          [y (posn-y pos)])
    (cond [(= dir 0) (make-game (make-posn x (- y 1)) dir body food)]
          [(= dir 1) (make-game (make-posn (+ x 1) y) dir body food)]
          [(= dir 2) (make-game (make-posn x (+ y 1)) dir body food)]
          [(= dir 3) (make-game (make-posn (- x 1) y) dir body food)])))

;Game Keypress -> Game
(define (command gs key)
  (let*([pos(game-pos gs)]
        [body (game-body gs)]
        [food (game-food gs)])
  (cond
    [(key=? key "w") (make-game pos 0 body food)]
    [(key=? key "d") (make-game pos 1 body food)]
    [(key=? key "s") (make-game pos 2 body food)]
    [(key=? key "a") (make-game pos 3 body food)]
    [else gs])))

;Wall Hit
;dont hit the wall n00b
;game-state -> game-state
(define (collision gs)
  (let* ([pos(game-pos gs)]
          [dir  (game-dir gs)]
          [x (posn-x pos)]
          [y (posn-y pos)])
    (or
      (<= y 0)
      (<= x 0)
      (>= x GRID-SIZE)
      (>= y GRID-SIZE))))

;END SCREEN
(define (END_SCREEN gs)
         (place-image Lose 400 400 Lose_Screen))

;worm-ness (making the body be a body that follows)
;gs+list -> gs
;make a list of
     ;how many heads
     ;posn's
;(define (body-list l gs)



;food placement



;CREATE LE UNIVERSE
(big-bang initial-game
          (on-key command)
          (to-draw world-render)
          (on-tick move 0.2)
          (stop-when collision END_SCREEN))
