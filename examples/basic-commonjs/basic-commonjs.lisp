(in-package #:react-examples/basic-commonjs)

(let* ((renderCB (lambda ()
                   (let* ((elapsed (round (/ (@ this props elapsed) 100.0)))
                          (sec (/ elapsed 10))
                          (seconds (+ sec (if (= (mod elapsed 10) 0) ".0" "")))
                          (message (+ "React has been successfully running for " seconds " seconds" )))
                     (psx (:p message)))))
       (ExampleApplication
         (chain React (createClass (create render renderCB))))
       (start (chain (new (Date)) (get-time))))

  (setInterval (lambda ()
                 (let ((container (chain document (get-element-by-id "container"))))
                   (chain ReactDOM (render
                                     (psx (:ExampleApplication :elapsed (- (chain (new (Date)) (get-time)) start)))
                                     container))))
               50))
