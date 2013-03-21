;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname |le snakes|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;le physical constants
(define HEIGHT 19)
(define SCALE 30)

;le cirlce
(define HEAD (circle (/ SCALE 2) outline red))
(define BODY (circle (/ SCALE 2) solid purple))