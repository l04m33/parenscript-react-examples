(require :parenscript)

(in-package #:cl-user)

(defpackage #:psx
  (:use #:cl #:parenscript)
  (:export #:psx))

(in-package #:psx)


;;; ripped from cl-react
(defparameter *dom-types*
  '(:math :svg :a :abbr :address :area :article :aside :audio :b :base :bdi :bdo
    :blockquote :body :br :button :button :button :button :canvas :caption :cite
    :code :col :colgroup :command :command :command :command :datalist :dd :del
    :details :dfn :div :dl :dt :em :embed :fieldset :figcaption :figure :footer
    :form :h1 :h2 :h3 :h4 :h5 :h6 :head :header :hgroup :hr :html :i :iframe :img
    :input :ins :kbd :keygen :label :legend :li :link :map :mark :menu
    :meta :meta :meta :meta :meta :meta :meter :nav :noscript :object :ol
    :optgroup :option :output :p :param :pre :progress :q :rp :rt :ruby :s :samp
    :script :section :select :small :source :span :strong :style :sub :summary
    :sup :table :tbody :td :textarea :tfoot :th :thead :time :title :tr :track :u
    :ul :var :video :wbr))

(defun dom-type-p (type)
  (find type *dom-types*))


(defun parse-props (prop-list)
  (do* ((create-form `(create))
        (children nil)
        (props-to-merge nil)
        (plist (copy-list prop-list))
        (p (pop plist) (pop plist)))
       ((not p) (values (if (> (length create-form) 1)
                          (reverse create-form)
                          nil)
                        (reverse props-to-merge)
                        (reverse children)))
    (cond
      ((keywordp p)
       (let ((v (pop plist)))
         (if v
           (progn
             (push (make-symbol (string p)) create-form)
             (push v create-form))
           (push p children))))
      ((and (listp p) (keywordp (car p)))
       (cond
         ((eql (car p) :|...|)
          (push (cadr p) props-to-merge))
         (t
          (push p children))
         ))
      (t
       (push p children)))))


(defun expand-react-element (element-form)
  (if (and (listp element-form) (keywordp (car element-form)))
    (let* ((element-type (car element-form))
           (element-sym (make-symbol (string element-type))))
      (multiple-value-bind (props props-to-merge children) (parse-props (cdr element-form))
        (if (dom-type-p element-type)
          (if (> (length props-to-merge) 0)
            (if props
              `(chain *react *d-o-m (,element-sym (chain *object (assign (create) ,@props-to-merge ,props))
                                                  ,@(mapcar #'expand-react-element children)))
              `(chain *react *d-o-m (,element-sym (chain *object (assign (create) ,@props-to-merge))
                                                  ,@(mapcar #'expand-react-element children))))
            `(chain *react *d-o-m (,element-sym ,props ,@(mapcar #'expand-react-element children))))
          `(chain *react (create-element ,element-sym ,props ,@(mapcar #'expand-react-element children))))))
    element-form))


(defpsmacro psx (&body body)
  (loop for form in body
        collect (expand-react-element form) into px-forms
        finally (return (append `(progn) px-forms))))
