(in-package #:react-examples/quadratic)


(defvar QuadraticCalculator
  (chain React
         (createClass
           (create
             getInitialState
             (lambda ()
               (create
                 a 1
                 b 3
                 c -4))
             
             handleInputChange
             (lambda (key event)
               (let ((partialState (create)))
                 (setf (getprop partialState key) (parseFloat (@ event target value)))
                 (chain this (setState partialState))))

             render
             (lambda ()
               (let* ((a (@ this state a))
                      (b (@ this state b))
                      (c (@ this state c))
                      (root (sqrt (- (chain Math (pow b 2)) (* 4 a c))))
                      (denominator (* 2 a))
                      (x1 (/ (+ (- b) root) denominator))
                      (x2 (/ (- (- b) root) denominator)))
                 (psx
                   (:div
                     (:strong
                       (:em "ax") (:sup "2") " + " (:em "bx") " + " (:em "c") " = 0")
                     (:h4 "Solve for " (:em "x") ":")
                     (:p
                       (:label
                         "a: "
                         (:input :type "number" :value a :onChange (chain this handleInputChange (bind nil "a"))))
                       (:br)
                       (:label
                         "b: "
                         (:input :type "number" :value b :onChange (chain this handleInputChange (bind nil "b"))))
                       (:br)
                       (:label
                         "c: "
                         (:input :type "number" :value c :onChange (chain this handleInputChange (bind nil "c"))))
                       (:br)
                       "x: " (:strong x1 ", " x2))))))))))


(chain ReactDOM (render (psx (:QuadraticCalculator)) (chain document (getElementById "container"))))
