function Plan = FF_Planner()


    javaaddpath(fullfile('../'));
    ff=javaff.JavaFF;

    delete('Plan.txt')
    diary Plan.txt
    pl = ff.plan(javaObject('java.io.File', '../javaff/DomainTurtlebot.pddl'),...
                 javaObject('java.io.File', '../javaff/ProblemTurtlebot.pddl'));
    diary off

    fid = fopen('Plan.txt','r');
    i = 1;
    tline = fgetl(fid);
    A{i} = tline;
    while ischar(tline)
        i = i+1;
        tline = fgetl(fid);
        A{i} = tline;
    end
    fclose(fid);

    plOutput = A(4:(end-3));
    numActions = str2double(cell2mat(plOutput(1)));

    for i=1:numActions
        Actions{i} = plOutput{numActions+i};
    end

    Actions = erase(Actions, "(");
    Actions = erase(Actions, ")");

    
    for i=1:length(Actions)

        if contains(Actions(i),"move_turtlebot")
            params = split(Actions(i), " ");
            params(end-1:end);
            action_name = params(1);
            current_pos = params(end-1);
            target_pos = params(end);
        elseif contains(Actions(i),"push_trash")
            params = split(Actions(i), " ");
            params(end-1:end);
            action_name = params(1);
            current_pos = params(3);
            target_pos = params(end);
        end

        Plan{i, 1} = string(action_name);
        Plan{i, 2} = string(current_pos);
        Plan{i, 3} = string(target_pos);   

    end    
end
