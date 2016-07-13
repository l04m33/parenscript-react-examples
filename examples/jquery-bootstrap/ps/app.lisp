(in-package #:react-examples/jquery-bootstrap)


(defvar BootstrapButton
  (chain React
         (createClass
           (create
             render
             (lambda ()
               (psx
                 (:a
                   (:... (@ this props))
                   :href "javascript:;"
                   :role "button"
                   :className (+ (or (chain this props className) "") " btn"))))))))


(defvar BootstrapModal
  (chain React
         (createClass
           (create
             componentDidMount
             (lambda ()
               (chain ($ (@ this refs root))
                      (modal (create backdrop "static" keyboard f show f)))
               (chain ($ (@ this refs root))
                      (on "hidden.bs.modal" (@ this handleHidden))))

             componentWillUnmount
             (lambda ()
               (chain ($ (@ this refs root))
                      (off "hidden.bs.modal" (@ this handleHidden))))

             close
             (lambda ()
               (chain ($ (@ this refs root)) (modal "hide")))

             open
             (lambda ()
               (chain ($ (@ this refs root)) (modal "show")))

             render
             (lambda ()
               (let ((confirmButton
                       (when (@ this props confirm)
                         (psx (:BootstrapButton
                                :onClick (@ this handleConfirm)
                                :className "btn-primary"
                                (@ this props confirm)))))
                     (cancelButton
                       (when (@ this props cancel)
                         (psx (:BootstrapButton
                                :onClick (@ this handleCancel)
                                :className "btn-default"
                                (@ this props cancel))))))
                 (psx
                   (:div :className "modal fade" :ref "root"
                    (:div :className "modal-dialog"
                     (:div :className "modal-content"
                      (:div :className "modal-header"
                       (:button
                         :type "button"
                         :className "close"
                         :onClick (@ this handleCancel)
                         (decode-entities "&times;"))
                       (:h3 (@ this props title)))
                      (:div :className "modal-body"
                       (@ this props children))
                      (:div :className "modal-footer"
                       cancelButton
                       confirmButton)))))))

             handleCancel
             (lambda ()
               (when (@ this props onCancel)
                 (chain this props (onCancel))))

             handleConfirm
             (lambda ()
               (when (@ this props onConfirm)
                 (chain this props (onConfirm))))

             handleHidden
             (lambda ()
               (when (@ this props onHidden)
                 (chain this props (onHidden))))))))


(defvar Example
  (chain React
         (createClass
           (create
             handleCancel
             (lambda ()
               (when (confirm "Are you sure you want to cancel?")
                 (chain this refs modal (close))))

             render
             (lambda ()
               (let ((modal
                       (psx
                         (:BootstrapModal
                           :ref "modal"
                           :confirm "OK"
                           :cancel "Cancel"
                           :onCancel (@ this handleCancel)
                           :onConfirm (@ this closeModal)
                           :onHidden (@ this handleModelDidClose)
                           :title "Hello, Bootstrap!"
                           "This is a React component powered by jQuery and Bootstrap!"))))
                 (psx
                   (:div :className "example"
                    modal
                    (:BootstrapButton
                      :onClick (@ this openModal)
                      :className "btn-default"
                      "Open modal")))))

             openModal
             (lambda ()
               (chain this refs modal (open)))

             closeModal
             (lambda ()
               (chain this refs modal (close)))

             handleModelDidClose
             (lambda ()
               (alert "The modal has been dismissed!"))))))


(chain ReactDOM (render (psx (:Example)) (chain document (getElementById "jqueryexample"))))
