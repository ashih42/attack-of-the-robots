;;;; MAIN for ROBOTS

(load "robots.lisp")

(defun main ()
    (print (robots)))

;;; Compile with SBCL
;;; sbcl --script main.lisp
(sb-ext:save-lisp-and-die "robots"
    :toplevel #'main
    :executable t)
