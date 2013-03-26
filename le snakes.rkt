;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |le snakes|) (read-case-sensitive #t) (teachpacks ((lib "image.ss" "teachpack" "2htdp") (lib "universe.ss" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.ss" "teachpack" "2htdp") (lib "universe.ss" "teachpack" "2htdp")))))
;le physical constants
(define HEIGHT 19)
(define SCALE 30)

;le SNAKE
;the head of the snake
(define HEAD (circle (/ SCALE 2) "solid" "orange"))
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


;movement
;data definitions
;direction is current direction of travel for the worm, and is eiter
     ; 0  up
     ; 1  right
     ; 2  down
     ; 3  left
(define-struct game (pos dir))
;pos=posn of worm
;dir=direction of travel
;Game -> Game
(define (move gs)
  (let*([pos(game-pos gs)]
          [dir  (game-dir gs)]
          [x (posn-x pos)]
          [y (posn-y pos)])
    (cond [(= dir 0) (make-game (make-posn x (-y 1)) dir)]
          [(= dir 1) ...]
          [(= dir 2) ...]
          [(= dir 3) ...])))

;Game Keypress -> Game
(define (command gs key)...)

;worm-ness (making the body be a body that follows)




;food placement