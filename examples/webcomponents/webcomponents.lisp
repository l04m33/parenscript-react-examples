(in-package #:react-examples/webcomponents)


(defvar proto
  (chain Object
         (create (@ HTMLElement prototype)
                 (create
                   createdCallback
                   (create
                     value
                     (lambda ()
                       (let* ((mountPoint (chain document (createElement "span")))
                              (name (chain this (getAttribute "name")))
                              (url (+ "https://www.google.com/search?q=" (encodeURIComponent name))))
                         (chain (chain this (createShadowRoot)) (appendChild mountPoint))
                         (chain ReactDOM (render (psx (:a :href url name)) mountPoint)))))))))

(chain document (registerElement "x-search" (create prototype proto)))


(defvar HelloMessage
  (chain React
         (createClass
           (create
             render
             (lambda ()
               (psx (:div "Hello " (:X-SEARCH :name (@ this props name)) "!")))))))


(chain ReactDOM (render (psx (:HelloMessage :name "Jim Sproch"))
                        (chain document (getElementById "container"))))
