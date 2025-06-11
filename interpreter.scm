;ONLY FOR EDUCATIONAL USE. PLAGIARISM WILL NOT BE TOLERATED

(define get-operator
  (lambda (op)
    (cond
      ((eq? op '+) +)
      ((eq? op '*) *)
      ((eq? op '-) -)
      ((eq? op '/) /)
      (else
       (display "cs305: ERROR")
       (newline)
       (newline)
       (cs305)))))


(define define-statement? (lambda (e)
	(and 
	  (list? e)
	  (= (length e) 3)
	  (eq? (car e) 'define)
	  (symbol? (cadr e))
	)))


(define let-expression? (lambda (e)
  (and 
    (list? e)                      
    (= (length e) 3)                
    (eq? (car e) 'let)              
    (list? (cadr e))               
    )))


(define get-value
  (lambda (var env)
    (cond
      ((null? env) 
       (display "cs305: ERROR")   
       (newline)  
       (newline)
       (cs305))            ; Call cs305 to return to the REPL
      ((eq? var (caar env)) (cdar env))  ; Return the value of the variable
      (else (get-value var (cdr env))))))  ; Search through the environment


(define extend-env (lambda (var val old-env)
        (cons (cons var val) old-env)))

(define lambda-expression? (lambda (e)
  (and (list? e) (> (length e) 1) (eq? (car e) 'lambda) (list? (cadr e)))))

(define make-closure (lambda (params body env)
  (list 'closure params body env)))

(define closure? (lambda (v)
  (and (list? v) (eq? (car v) 'closure))))

(define apply-closure (lambda (closure args)
  (let ((params (cadr closure))
        (body (caddr closure))
        (env (cadddr closure)))
    (if (= (length params) (length args))
        (s7 body (append (map cons params args) env))
        ))))

(define built-in-operator? (lambda (op)
  (or (eq? op '+) (eq? op '-) (eq? op '*) (eq? op '/))))

(define foldl
  (lambda (f initial-value list)
    (if (null? list)
        initial-value
        (foldl f (f (car list) initial-value) (cdr list)))))

(define s7
  (lambda (e env)
    (cond 
      ((number? e) e)  
      ((symbol? e) (get-value e env))  
      ((not (list? e))  (display "cs305: ERROR") (newline) (newline) (cs305)) 
      ((not (> (length e) 0)) (display "cs305: ERROR") (newline) (newline) (cs305))  
      ((lambda-expression? e) (make-closure (cadr e) (caddr e) env))  
      ((let-expression? e)  ; If the expression is a let statement
       (let ((bindings (cadr e))  ; Bindings are the second element of the let expression
             (body (caddr e)))     ; Body is the third element of the let expression

         (let ((new-env (foldl 
                          (lambda (binding acc)  ; For each binding, evaluate it and extend the environment
                            (let ((var (car binding))
                                  (val (s7 (cadr binding) env)))  ; Evaluate the value of the binding
                              (extend-env var val acc)))  ; Extend the environment with the binding
                          env
                          bindings)))
           (s7 body new-env)))) 

      ((closure? (car e))  ; If the first element is a closure, apply it
       (apply-closure (car e) (map (lambda (arg) (s7 arg env)) (cdr e))))
      ((built-in-operator? (car e))  ; If the first element is a built-in operator, apply it
       (apply (get-operator (car e)) (map (lambda (arg) (s7 arg env)) (cdr e))))
      (else  ; Otherwise, evaluate the operator and operands
       (let ((operator (s7 (car e) env))
             (operands (map (lambda (arg) (s7 arg env)) (cdr e))))
         (if (closure? operator)
             (apply-closure operator operands)
             (apply operator operands)))))))



(define repl (lambda (env)
  (display "cs305> ")
  (let* (
      (expr (read))
      (new-env (if (define-statement? expr)
                   (extend-env (cadr expr) (s7 (caddr expr) env) env)
                (if (let-expression? expr)
                    (let* ((bindings (cadr expr)) ; Bindings for the let statement
                           (evaluated-bindings 
                             (map (lambda (b) 
                                    (cons (car b) (s7 (cadr b) env))) bindings)))
                      (extend-env (map car evaluated-bindings) 
                                  (map cdr evaluated-bindings) env))
                env)))
      (val (if (define-statement? expr)
               (cadr expr)
               (s7 expr env))))
    
    (display "cs305: ")
    (if (or (closure? val) (procedure? val)) 
        (display "[PROCEDURE]") 
        (display val))

    (newline)
    (newline)
    (repl new-env))))

(define cs305 (lambda ()
  (repl '())))
