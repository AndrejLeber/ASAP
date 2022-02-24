function updateProblemPDDL(fieldpos_tb, fieldpos_tr)

%% Read file
file = fileread('../javaff/ProblemTurtlebot.pddl');

%% Find actual turtlebot position
tb_index = strfind(file,"(turtlebot-at");
tb_line = file(tb_index:tb_index+19);
%% Find actual trash position
tr_index = strfind(file,"(trash-at");
tr_line = file(tr_index:tr_index+15);

%% Update positions
file = strrep(file, tb_line, "(turtlebot-at tb " + fieldpos_tb + ")");
file = strrep(file, tr_line, "(trash-at tr " + fieldpos_tr + ")");

%% Write updates
fid = fopen('../javaff/ProblemTurtlebot.pddl', 'w');
fwrite(fid, file);
fclose(fid);

end
