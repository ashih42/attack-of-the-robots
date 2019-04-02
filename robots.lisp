;;;; Land of Lisp, Chapter 11
;;;; ROBOTS

;;; Map dimension: 64 x 16 = 1024

(defun robots ()
    (loop named main
          with directions = '((q . -65) (w . -64) (e . -63)
                              (a .  -1)           (d .   1)
                              (z .  63) (x .  64) (c .  65))
          ;; Initialize player's position
          for pos = 544
          ;; Process player input
          then (progn (format t "~%qwe/asd/zxc to move, (t)eleport, (l)eave:")
                      (force-output)
                      (let* ((c (read))
                             (d (assoc c directions)))
                          (cond (d          (mod (+ pos (cdr d)) 1024))
                                ((eq 't c)  (random 1024))
                                ((eq 'l c)  (return-from main 'bye))
                                (t          pos))))
          ;; Initialize monsters' positions
          for monsters = (loop repeat 10
  		                       collect (random 1024))
          ;; Let each living monster move toward player
          then (loop for mpos in monsters
                     collect (if (> (count mpos monsters) 1)
  			                    mpos
                                (cdar (sort (loop for (k . d) in directions
  					                              for new-mpos = (+ mpos d)
                                                  collect (cons (+ (abs (- (mod new-mpos 64) 
                                                                            (mod pos 64)))
                                                                   (abs (- (ash new-mpos -6)
                                                                            (ash pos -6))))
                                                                new-mpos))
                                            #'<
                                            :key #'car))))
          ;; Check if all monsters are dead (stopped at same position)
          when (loop for mpos in monsters
                     always (> (count mpos monsters) 1))
          return 'player-wins
          ;; Render
          do (format t "~A[H~@*~A[J" #\escape) ; clear screen
             (format t "+~v@{~A~:*~}+" 64 #\-) ; print horizontal wall
             (format t 
                     "~%|~{~<|~%|~,65:;~A~>~}|"
                     (loop for p 
                           below 1024
                           collect (cond ((member p monsters)
                                              (if (> (count p monsters) 1)
                                                    #\#
                                                    #\A))
                                         ((= p pos) #\@)
                                         (t         #\space))))
             (fresh-line)
             (format t "+~v@{~A~:*~}+" 64 #\-) ; print horizontal wall
             (when (member pos monsters)
                (return-from main 'player-loses))))
