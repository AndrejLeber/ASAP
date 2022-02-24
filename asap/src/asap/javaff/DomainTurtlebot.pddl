(define (domain DomainTurtlebot)

    (:requirements 
        :typing
    ) 

    (:types
        turtlebot - object
        trash - object
        field - object
    )

    (:predicates 
        (clear ?x)
        (turtlebot-at ?turtlebot - turtlebot ?f_tb - field)
        (trash-at ?trash - trash ?f_tr - field)
        (next_to ?f_start ?f_next_to - field)
        (push_cond ?f_tb ?f_tr - field)
        (trash_pushed ?turtlebot - turtlebot ?trash - trash)
    ) 
	
    (:action move_turtlebot
        :parameters (
            ?tb - turtlebot
            ?f_tb ?f_target - field
        )
        :precondition (
            and
            (clear ?f_target)
            (turtlebot-at ?tb ?f_tb)
            (next_to ?f_tb ?f_target)
        )
        :effect
            (turtlebot-at ?tb ?f_target)
    )

    (:action push_trash
        :parameters (
	    ?tb - turtlebot
            ?f_tb - field
	    ?tr - trash
            ?f_tr - field
        )
        :precondition (
            and
            (turtlebot-at ?tb ?f_tb)
	    (trash-at ?tr ?f_tr)
            (push_cond ?f_tb ?f_tr)
        )
        :effect
	    (trash_pushed ?tb ?tr)
    )

)


