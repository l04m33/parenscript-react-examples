(in-package #:react-examples/basic)

(let* ((renderCB (lambda ()
                   (let* ((elapsed (round (/ (@ this props elapsed) 100.0)))
                          (sec (/ elapsed 10))
                          (seconds (+ sec (if (= (mod elapsed 10) 0) ".0" "")))
                          (message (+ "React has been successfully running for " seconds " seconds" )))
                     (chain React DOM (p nil message)))))
       (ExampleApplication
         (chain React (createClass (create render renderCB))))
       (ExampleApplicationFactory
         (chain React (createFactory ExampleApplication)))
       (start (chain (new (Date)) (get-time))))

  (setInterval (lambda ()
                 (let* ((dt (- (chain (new (Date)) (get-time)) start))
                        (app (ExampleApplicationFactory (create elapsed dt)))
                        (container (chain document (get-element-by-id "container"))))
                   (chain ReactDOM (render app container))))
               50))
