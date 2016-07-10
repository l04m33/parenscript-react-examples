(require :parenscript)

(in-package #:cl-user)

(defpackage #:ps-compile
  (:use #:cl)
  (:export #:batch-compile))

(in-package #:ps-compile)


(defun batch-compile (package-file ps-dir)
  (let* ((ps:*js-target-version* "1.8.5")
         (ps-path (pathname ps-dir))
         (ps-wild
           (merge-pathnames
             (make-pathname :directory `(:relative :wild-inferiors)
                            :name :wild
                            :type "lisp")
             ps-path))
         (ps-package-file (car (directory (pathname package-file))))
         (full-ps-list (directory ps-wild))
         (ps-list (remove ps-package-file full-ps-list :test 'equal)))
    (load ps-package-file)
    (loop for fname in ps-list
          do (let* ((out-fname (merge-pathnames (make-pathname :type "js") fname))
                    (fname-short (concatenate 'string (pathname-name fname) "." (pathname-type fname)))
                    (out-fname-short (concatenate 'string (pathname-name out-fname) "." (pathname-type out-fname))))
               (format t "~A -> ~A~%" fname-short out-fname-short)
               (with-open-file (out out-fname
                                    :direction :output
                                    :if-exists :supersede
                                    :if-does-not-exist :create)
                 (multiple-value-bind (sec min hour date month year week-day dst tz) (get-decoded-time)
                   (declare (ignore week-day dst))
                   (format out "/* Compiled by parenscript, ~4,'0d-~2,'0d-~2,'0d, ~2,'0d:~2,'0d:~2,'0d, GMT~@d */~%"
                           year month date hour min sec (- tz)))
                 (let ((orig-readtable-case (readtable-case *readtable*)))
                   (setf (readtable-case *readtable*) :invert)
                   (write-string (ps:ps-compile-file fname) out)
                   (setf (readtable-case *readtable*) orig-readtable-case)))))))
