(in-package #:react-examples/basic-click-counter)

(let* ((Counter
         (chain React
                (createClass
                  (create
                    getInitialState (lambda () (create count 0))
                    handleClick     (lambda ()
                                      (chain this (set-state
                                                    (create
                                                      count (1+ (@ this state count))))))
                    render          (lambda ()
                                      (psx
                                        (:button :onClick (@ this handleClick)
                                         (+ "Click me! Number of clicks: " (@ this state count))))))))))
  (chain ReactDOM (render (psx (:Counter))
                          (chain document (getElementById "container")))))
