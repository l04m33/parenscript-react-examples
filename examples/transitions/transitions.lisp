(in-package #:react-examples/transitions)


(defvar CSSTransitionGroup (@ React addons CSSTransitionGroup))
(defvar INTERVAL 2000)


(defvar AnimateDemo
  (chain React
         (createClass
           (create
             getInitialState
             (lambda ()
               (create current 0))
             
             componentDidMount
             (lambda ()
               (setf (@ this interval) (setInterval (@ this tick) INTERVAL)))

             componentWillUnmount
             (lambda ()
               (clearInterval (@ this interval)))

             tick
             (lambda ()
               (chain this (setState (create current (1+ (@ this state current))))))

             render
             (lambda ()
               (let ((children (array))
                     (pos 0)
                     (colors (array "red" "gray" "blue")))
                 (loop for i from (@ this state current) below (+ (@ this state current) (@ colors length))
                       do (let ((style
                                  (create
                                    left (* pos 128)
                                    background (@ colors (mod i (@ colors length))))))
                            (incf pos)
                            (chain children
                                   (push
                                     (psx
                                       (:div :key i :className "animateItem" :style style i))))))
                 (psx
                   (:CSSTransitionGroup
                     :className "animateExample"
                     :transitionEnterTimeout 250
                     :transitionLeaveTimeout 250
                     :transitionName "example"
                     children))))))))


(chain ReactDOM
       (render (psx (:AnimateDemo))
               (chain document (getElementById "container"))))
