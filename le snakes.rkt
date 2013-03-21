;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |le snakes|) (read-case-sensitive #t) (teachpacks ((lib "image.ss" "teachpack" "2htdp") (lib "universe.ss" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.ss" "teachpack" "2htdp") (lib "universe.ss" "teachpack" "2htdp")))))
;le physical constants
(define HEIGHT 19)
(define SCALE 30)

;le SNAKE
(define HEAD 
  (underlay/offset (circle 40 "solid" "gray")
                   0 -10
                   (underlay/offset (circle 10 "solid" "navy")
                                   -30 0
                                   (circle 10 "solid" "navy"))))
(define BODY (circle (/ SCALE 2) "solid" "purple"))