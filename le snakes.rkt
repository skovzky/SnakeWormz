;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname |le snakes|) (read-case-sensitive #t) (teachpacks ((lib "image.ss" "teachpack" "2htdp") (lib "universe.ss" "teachpack" "2htdp") (lib "batch-io.ss" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.ss" "teachpack" "2htdp") (lib "universe.ss" "teachpack" "2htdp") (lib "batch-io.ss" "teachpack" "2htdp")))))
;====ROBERT HEEMANN====
;----SNAKE GAME----

(define-struct game (pos dir body food))

(define INITIAL_BODY_LIST (list (make-posn 5 4) (make-posn 5 3) (make-posn 5 2) ))

(define FOOD_POSN (make-posn (+ 2 (random 52)) (+ 2 (random 52))))

(define initial-game (make-game (make-posn 5 5) 2 INITIAL_BODY_LIST FOOD_POSN))

;Update the game in its entirety
;gs->gs

;(define (UPDATE gs)
 ; ((move gs))
  
  
  ;le physical constants==================================================================================================================================================================================================================
  (define HEIGHT 60)
  (define SCALE 15)
  (define GRID-SIZE 52)
  (define MAX (- GRID-SIZE 1))
  
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
  (define BODY (circle (/ SCALE 3) "solid" "purple"))
  
  ;le objects
  (define FOOD (circle (/ SCALE 3) "solid" "forestgreen"))
  (define BACKGROUND (empty-scene (* GRID-SIZE SCALE) (* GRID-SIZE SCALE) "black"))
  
  ;END SCREEN
  (define (END_SCREEN gs)
    (place-image Lose 400 400 Lose_Screen))
  
  (define Lose_Screen
    (empty-scene (* GRID-SIZE SCALE) (* GRID-SIZE SCALE) "red"))
  
  (define Lose
    (text "YOU. ARE. TERRIBLE!" 48 "white"))
  
  ;World==================================================================================================================================================================================================================
  ;game-state --> image
  ;image to be placed into a window
  (define (world-render gs)
    (let*([pos (game-pos gs)]
          [x (* SCALE(posn-x pos))]
          [y (* SCALE (posn-y pos))]
          [BODY (game-body gs)])
      (RENDER_WORM BODY (place-image HEAD
                                     x y
                                     (RENDER_FOOD BACKGROUND gs)))))
  
  
  ;movement==================================================================================================================================================================================================================
  ;data definitions
  ;direction is current direction of travel for the worm, and is eiter
  ;pos=posn of worm=============================================================================
  ;dir=direction of travel
  ;Game -> Game
  ; 0  up
  ; 1  right
  ; 2  down
  ; 3  left
  
  (define (all_but_the_last_tail lst)
    (reverse (rest (reverse lst))))
  
  
  (define (move gs)
    (let*([pos (game-pos gs)]
          [dir  (game-dir gs)]
          [body (game-body gs)]
          [food (game-food gs)]
          [x (posn-x pos)]
          [y (posn-y pos)]
          [new-posn (cond [(= dir 0) (make-posn x (- y 1))]
                          [(= dir 1) (make-posn (+ x 1) y)]
                          [(= dir 2) (make-posn x (+ y 1))]
                          [(= dir 3) (make-posn (- x 1) y)])])
      (if (EAT? food gs) (make-game new-posn dir (cons pos body) (make-posn (+ 2 (random 52)) (+ 2 (random 52))))
          (make-game new-posn dir (cons pos (all_but_the_last_tail body)) food))))
  
  
  ;Game Keypress -> Game=============================================================================
  (define (command gs key)
    (let*([pos(game-pos gs)]
          [body (game-body gs)]
          [food (game-food gs)]
          [dir  (game-dir gs)])
      (cond
        [(and (key=? key "w")(not (= dir 2))) (make-game pos 0 body food)]
        [(and (key=? key "d")(not (= dir 3))) (make-game pos 1 body food)]
        [(and (key=? key "s")(not (= dir 0))) (make-game pos 2 body food)]
        [(and (key=? key "a")(not (= dir 1))) (make-game pos 3 body food)]
        [else gs])))
  
  
  
  ;Wall Hit==================================================================================================================================================================================================================
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
  
  
  
  ;worm-ness (making the body be a body that follows)==================================================================================================================================================================================================================
  ;AKA CHERNOBL (everything has been scraped....)
  ;gs list -> gs
  ;make a list of
  ;how many heads
  ;posn's
  
  
  
  ;(define (body-list l gs)
  ;      (let*([pos(game-pos gs)]
  ;        [dir  (game-dir gs)]
  ;       [body (game-body gs)]
  ;      [food (game-food gs)]
  ;     [x (posn-x pos)]
  ;    [y (posn-y pos)]
  ;   [new_pos (cond 
  ;       [(= dir 0) (make-game (make-posn x (- y 1)) dir body food)]
  ;      [(= dir 1) (make-game (make-posn (+ x 1) y) dir body food)]
  ;     [(= dir 2) (make-game (make-posn x (+ y 1)) dir body food)]
  ;    [(= dir 3) (make-game (make-posn (- x 1) y) dir body food)])]
  ;[new_tail (if (empty? body)
  ;             empty
  ;            (cons pos (all_but_the_last_tail)))])
  ;(make-game new_pos new_tail dir body food)))
  
  ;Placing Down the Bread crumbs==================================================================================================================================================================================================================
  ;GS->RENDER
  (define (RENDER_FOOD img gs)
    (let* ([x (* SCALE (posn-x (game-food gs)))]
           [y (* SCALE (posn-y (game-food gs)))])
      (place-image FOOD x y img)))
  
  ;food placement
  ;initial game has random posn
  
  (define (EAT? Fd-posn gs)
    (let*([pos (game-pos gs)])
      (equal? pos Fd-posn)))
  
  
  

  ;RENDERING THE WORM==================================================================================================================================================================================================================
  (define worm-cons (list (make-posn 5 6)))
  
  (define (place-segment pos img)
    (let* ([x (* SCALE (posn-x pos))]
           [y (* SCALE (posn-y pos))])
      (place-image BODY x y img)))
  
  (define (RENDER_WORM lst img)
    (cond
      [(empty? lst) img]
      [else (place-segment (first lst) (RENDER_WORM (rest lst) img))]))
  
  
  
  ;CREATE LE UNIVERSE==================================================================================================================================================================================================================
  (big-bang initial-game
            (on-key command)
            (to-draw world-render)
            (on-tick move 0.07)
            (stop-when collision END_SCREEN))
  
  
  