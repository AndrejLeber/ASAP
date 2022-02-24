(define (problem turtlebot) 
  (:domain DomainTurtlebot) 
  (:objects 
        tb - turtlebot
        tr - trash
        a1 a2 a3 a4 a5 a6 b1 b2 b3 b4 b5 b6 c1 c2 c3 c4 c5 c6 d1 d2 d3 d4 d5 d6 e1 e2 e3 e4 e5 e6 f1 f2 f3 f4 f5 f6 trash_zone - fields
  )
 
  (:init
	(turtlebot-at tb e1)
	(trash-at tr e3)

	(clear a1) (clear b1) (clear c1) (clear d1) (clear e1) (clear f1) 
	(clear a2) (clear b2) (clear c2) (clear d2) (clear e2) (clear f2)
	(clear a3) (clear b3) (clear c3) (clear d3) (clear e3) (clear f3)
 	(clear a4) (clear b4) (clear c4) (clear d4) (clear e4) (clear f4)
 	(clear a5) (clear b5) (clear c5) (clear d5) (clear e5) (clear f5)
 	(clear a6) (clear b6) (clear c6) (clear d6) (clear e6) (clear f6) 
	(clear trash_zone)   
  		
	(next_to a1 b1) (next_to b1 c1) (next_to c1 d1) (next_to d1 e1) (next_to e1 f1) 
	(next_to a2 b2) (next_to b2 c2) (next_to c2 d2) (next_to d2 e2) (next_to e2 f2) 
	(next_to a3 b3) (next_to b3 c3) (next_to c3 d3) (next_to d3 e3) (next_to e3 f3) 
	(next_to a4 b4) (next_to b4 c4) (next_to c4 d4) (next_to d4 e4) (next_to e4 f4) 
	(next_to a5 b5) (next_to b5 c5) (next_to c5 d5) (next_to d5 e5) (next_to e5 f5) 
	(next_to a5 b5) (next_to b6 c6) (next_to c6 d6) (next_to d6 e6) (next_to e6 f6) 

	(next_to f1 e1) (next_to e1 d1) (next_to d1 c1) (next_to c1 b1) (next_to b1 a1) 
	(next_to f2 e2) (next_to e2 d2) (next_to d2 c2) (next_to c2 b2) (next_to b2 a2)
	(next_to f3 e3) (next_to e3 d3) (next_to d3 c3) (next_to c3 b3) (next_to b3 a3) 
	(next_to f4 e4) (next_to e4 d4) (next_to d4 c4) (next_to c4 b4) (next_to b4 a4) 
	(next_to f5 e5) (next_to e5 d5) (next_to d5 c5) (next_to c5 b5) (next_to b5 a5) 
	(next_to f6 e6) (next_to e6 d6) (next_to d6 c6) (next_to c6 b6) (next_to b6 a6)  
     
	(next_to a1 a2) (next_to a2 a3) (next_to a3 a4) (next_to a4 a5) (next_to a5 a6) 
	(next_to b1 b2) (next_to b2 b3) (next_to b3 b4) (next_to b4 b5) (next_to b5 b6) 
	(next_to c1 c2) (next_to c2 c3) (next_to c3 c4) (next_to c4 c5) (next_to c5 c6) 
	(next_to d1 d2) (next_to d2 d3) (next_to d3 d4) (next_to d4 d5) (next_to d5 d6) 
	(next_to e1 e2) (next_to e2 e3) (next_to e3 e4) (next_to e4 e5) (next_to e5 e6) 
	(next_to f1 f2) (next_to f2 f3) (next_to f3 f4) (next_to f4 f5) (next_to f5 f6) 

	(next_to a6 a5) (next_to a5 a4) (next_to a4 a3) (next_to a3 a2) (next_to a2 a1) 
	(next_to b6 b5) (next_to b5 b4) (next_to b4 b3) (next_to b3 b2) (next_to b2 b1) 
	(next_to c6 c5) (next_to c5 c4) (next_to c4 c3) (next_to c3 c2) (next_to c2 c1) 
	(next_to d6 d5) (next_to d5 d4) (next_to d4 d3) (next_to d3 d2) (next_to d2 d1) 
	(next_to e6 e5) (next_to e5 e4) (next_to e4 e3) (next_to e3 e2) (next_to e2 e1) 
	(next_to f6 f5) (next_to f5 f4) (next_to f4 f3) (next_to f3 f2) (next_to f2 f1)

 	(next_to c1 trash_zone) (next_to d1 trash_zone)

	(push_cond a1 b1) (push_cond b1 trash_zone) (push_cond c1 trash_zone) (push_cond d1 trash_zone) (push_cond e1 trash_zone) (push_cond f1 e1)
	(push_cond a2 b2) (push_cond b2 c1) (push_cond c2 c1) (push_cond d2 d1) (push_cond e2 d1) (push_cond f2 e2)
	(push_cond a3 b2) (push_cond b3 c2) (push_cond c3 c2) (push_cond d3 d2) (push_cond e3 d2) (push_cond f3 e2)
	(push_cond a4 b3) (push_cond b4 c3) (push_cond c4 c3) (push_cond d4 d3) (push_cond e4 d3) (push_cond f4 e3)
	(push_cond a5 b4) (push_cond b5 c4) (push_cond c5 c4) (push_cond d5 d4) (push_cond e5 d4) (push_cond f5 e4)
	(push_cond a6 b5) (push_cond b6 c5) (push_cond c6 c5) (push_cond d6 d5) (push_cond e6 d5) (push_cond f6 e5)
   )

  (:goal 
	(trash_pushed tb tr)
  )
)  
