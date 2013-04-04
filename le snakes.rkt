;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname |le snakes|) (read-case-sensitive #t) (teachpacks ((lib "image.ss" "teachpack" "2htdp") (lib "batch-io.ss" "teachpack" "2htdp") (lib "universe.ss" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.ss" "teachpack" "2htdp") (lib "batch-io.ss" "teachpack" "2htdp") (lib "universe.ss" "teachpack" "2htdp")))))
;le physical constants
(define HEIGHT 60)
(define SCALE 60)

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
(define BACKGROUND (empty-scene (* 10 SCALE) (* 10 HEIGHT) "brown"))


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
     
;(define (world-render s)
 ; (place-image HEAD
  ;             (posn-x (game-pos s)) (posn-y (game-pos s))
   ;            BACKGROUND))
;movement
;data definitions
;direction is current direction of travel for the worm, and is eiter
     ; 0  up
     ; 1  right
     ; 2  down
     ; 3  left
     
     
(define-struct game (pos dir))
(define initial-game (make-game (make-posn 0 0) 1))

;pos=posn of worm
;dir=direction of travel
;Game -> Game
(define (move gs)
  (let*([pos(game-pos gs)]
          [dir  (game-dir gs)]
          [x (posn-x pos)]
          [y (posn-y pos)])
    (cond [(= dir 0) (make-game (make-posn x (- y 1)) dir)]
          [(= dir 1) (make-game (make-posn (+ x 1) y) dir)]
          [(= dir 2) (make-game (make-posn x (+ y 1)) dir)]
          [(= dir 3) (make-game (make-posn (- x 1) y) dir)])))

;Game Keypress -> Game
(define (command gs key)
  (let*([pos(game-pos gs)])
  (cond
    [(key=? key "up") (make-game pos 0)]
    [(key=? key "right") (make-game pos 1)]
    [(key=? key "down") (make-game pos 2)]
    [(key=? key "left") (make-game pos 3)])))

;worm-ness (making the body be a body that follows)




;food placement



;CREATE LE UNIVERSE
(big-bang initial-game
          (on-tick move 0.2)
          (on-key command)
          (to-draw world-render)
          )
