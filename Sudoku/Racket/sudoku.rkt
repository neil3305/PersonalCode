#lang racket

;; The following are necessary for our grading script to see your functions.
;; Do not change.
;(provide solve-driver)
(provide get-board-from-file)
(provide print-board)


;;; Name: Neil Advani
;;; VUnet id: advanin
;;; Email: neil.advani@vanderbilt.edu
;;; Class: CS3270
;;; Date: 3/24/15

;;; Description:  Sudoku Solver for classic 9x9 sudoku board. Reads in a board from a file (or default file), then
;;; attempts to solve the puzzle via recursive backtracking. If the puzzle isn't solvable, will output that it cant
;;; be solved. If it is solvable it will print out the solved puzzle in a more readable way along with the time
;;; taken to solve. Uses classical functional programming ideals, in that the program does not mutate.

;;; sudoku-solver is the main entry point.
;;; user types (sudoku-solver) at the Racket command prompt to run the program.



; define some global constants
(define BOARD-SIZE 9)   ; the size of the board
(define ROWS 9)         ; the number of rows
(define COLS 9)         ; the number of columns
(define GRID-SIZE 3)    ; the size of a subgrid

; specify default file to load puzzle from
(define defaultFileName "C:\\cs270\\racket\\sudoku.txt")




;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Supplied functions
;;;
;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; print-board 
;; prints a board
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (print-board board)
  (begin
    (print-row (list-ref board 0))
    (print-row (list-ref board 1))
    (print-row (list-ref board 2))
    (printf "------+-------+------ ~n")
    (print-row (list-ref board 3))
    (print-row (list-ref board 4))
    (print-row (list-ref board 5))
    (printf "------+-------+------ ~n")
    (print-row (list-ref board 6))
    (print-row (list-ref board 7))
    (print-row (list-ref board 8))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; print-row  
;; print a row of the board with dividing lines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (print-row row)
  (printf "~a ~a ~a | ~a ~a ~a | ~a ~a ~a ~n"
          (list-ref row 0)
          (list-ref row 1)
          (list-ref row 2)
          (list-ref row 3)
          (list-ref row 4)
          (list-ref row 5)
          (list-ref row 6)
          (list-ref row 7)
          (list-ref row 8)))

 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; get-board 
;; loads a board
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (get-board)
  (begin
    (printf "~nEnter the name of the file containing the Sudoku puzzle, or ")
    (printf "~npress enter for the default file (~a): " defaultFileName)
    (let
        ([fileName (string-trim (read-line))])
      (if (string=? fileName "")
          (get-board-from-file defaultFileName)
          (get-board-from-file fileName)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; get-board-from-file
;; loads a board from the given file
;; it expects the board to be in the format of a single S-expression:
;; a list of nine lists, each containing nine numbers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (get-board-from-file fileName)
  (let ([in (open-input-file fileName #:mode 'text)])
    (read in)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; get-value  
;; return the value on the board at a specified row & col
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (get-value board row col)
  (list-ref (list-ref board row) col))

  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; set-value 
;; place a given value in the specified row & col and return the new board
;; Note: non-destructive! It returns a new board.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (set-value board row col value)
  (list-set board row (list-set (list-ref board row) col value)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; main entry point to the sudoku solver.
;; times the solution function.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (sudoku-solver)
  (let ([board (get-board)])
    (if board
        (begin
          (displayln "")
          (displayln "Here is the initial board:")
          (print-board board)
          (displayln "")
          (let ([solution (time (solve-driver board))])
            (if (null? solution)
                (displayln "No solution")
                (begin
                  (displayln "")
                  (displayln "Here is the solution:")
                  (print-board solution)
                  (displayln "")))))
        (displayln "There is no board to process"))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; driver routine
;;
;; It is your job to write this and necessary helper functions
;;
;; This function should call your recursive backtracking solver
;; and, depending upon the result, either return the solved puzzle
;; or return null if the puzzle has no solution
;;
;; DO NOT change the name/signature of this function, as our
;; testing script depends upon it.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (solve-driver board)
  ; your job to write this
  (recursive-solver board 0 0 1)  
)


;; add your other functions here

;;recursive solver solves the puzzle recursively given the board and a current
;;coordinate spot on the board and a number to try and place there
(define (recursive-solver board row col number)
  (cond
    [(equal? number (add1 BOARD-SIZE)) null] ;;checks if we have gone through all numbers and if so returns null
    [(equal? row BOARD-SIZE) board]  ;;checks if we have gone through all spots and returns the board if so
    [(equal? col BOARD-SIZE) (recursive-solver board (add1 row) 0 1)] ;;checks to see if columns are out of range, and if so adds one to row and resets column and number
    [(not (zero? (get-value board row col))) (recursive-solver board row (add1 col) 1)] ;;checks if we already have a number in this spot
    ;;recursive call. If we can place the number, set a newBoard value equal to moving to the next spot. If that board is null, move this board to next number
    [(can-place board number row col) (let ([newBoard (recursive-solver (set-value board row col number) row (add1 col) 1)])
                                        (if (null? newBoard)
                                            (recursive-solver board row (add1 col) (add1 number))
                                            newBoard))]
                                                                                 
    [else (recursive-solver board row col (add1 number))])) ;;if we cant place the current number, move to next spot
                

;;canPlace function that combines the 3 functions below into one
;;to test and see if a given num can be place on the given board
;;at coordinates (row,col)
(define (can-place board number row col)
  (cond
    [(not (test-col board number row col)) #f]
    [(not (test-row board number row col)) #f]
    [(not (test-box board number (- row (remainder row GRID-SIZE)) (- col (remainder col GRID-SIZE)) 0 0)) #f]
    [else #t]))
;;checks to see if the given number is safe to place at
;;position (row,col) on the given board in terms of given col
;;returns true if number is safe to place in terms of column, else false
(define (test-col board number row col)
  (cond
    [(and (> BOARD-SIZE row) (equal? number (get-value board row col))) #f] ;;num exists, return false
    [(> BOARD-SIZE row) (test-col board number (+ row 1) col)] ;;else increment row by 1
    [else #t])) ;;all spots checked, return true
  
;;checks to see if the given number is safe to place at position
;;(row,col) on given board in terms of given row
;;returns true if num is safe to place in terms of row else false
(define (test-row board number row col)
  (cond
    [(and (> BOARD-SIZE col) (equal? number (get-value board row col))) #f] ;;num exists, return false
    [(> BOARD-SIZE col) (test-row board number row (+ col 1))] ;;else increment column by 1
    [else #t])) ;;checked all spots, return true
    
;;checks to see if the given number is safe to place in the 3x3 box
;;near the given coordinates. Assumes row and col is (0,0) of the 3x3 box
;;returns true if number is safe to place in terms of 3x3 box else false
(define (test-box board number row col rowChange colChange)
  (cond
    [(equal? number (get-value board (+ row rowChange) (+ col colChange))) #f]  ;;number exists at (row+rowChange,col+colChange) so return false
    [(and (> (sub1 GRID-SIZE) rowChange) (> (sub1 GRID-SIZE) colChange)) (test-box board number row col rowChange (+ colChange 1))]  ;;numbers still in 3x3 range so move to next
    [(> (sub1 GRID-SIZE) rowChange) (test-box board number row col (+ rowChange 1) 0)] ;;row needs to increment by 1, reset column
    [else #t])) ;;all spots checked so return true
   

  
;; The following should be at the bottom of your file
;;
;; the following was added to automatically start your solver when 
;; the "Run" button is pressed in DrRacket.

(sudoku-solver)

;; the following was added for generating an executable so window stays open
;(printf "~npress enter to exit")
;(read-line)

