function executePlan(plan, subTb, subTr, pubTb, field)

global turtlebotStates
global trashStates
splan = string(plan); % Plan as string array instead of cell array

for i = 1:length(plan(:,1))
    if plan{i,1} == "move_turtlebot"
        fprintf("Führe %i.Schritt des Plans aus: Fahre von Feld %s nach Feld %s\n", i, splan(i,2), splan(i,3));
        receive(subTb, 10);
        currPos.position.x = turtlebotStates.position.x;
        currPos.position.y = turtlebotStates.position.y;
        dest.position.x = eval("field." + plan(i,3) + ".center.x");
        dest.position.y = eval("field." + plan(i,3) + ".center.y");
        driveToDest(subTb, pubTb, field, currPos, dest, 0.3, 0.2, 0.2);
    elseif plan{i,1} == "push_trash"
        fprintf("\n\nFühre %i.Schritt des Plans aus: Schiebe den Müll von Feld %s aus Feld %s\n", i, splan(i,2), splan(i,3));
        receive(subTb, 10);
        currPos.position.x = turtlebotStates.position.x;
        currPos.position.y = turtlebotStates.position.y;
        receive(subTr, 10);
        dest.position.x = trashStates.position.x;
        dest.position.y = trashStates.position.y;
        pushTrash(subTb, subTr, pubTb, field, currPos, dest, 0.3, 0.2, 0.2)
    end
end

% Fahre kurz rückwärts, bevor der nächste Plan ausgeführt wird, um zu vermeiden, 
% dass der Turtlebot bei der Drehung mit dem Müll kollidiert
msg = rosmessage(pubTb);
msg.Linear.X = -0.1;
send(pubTb, msg);
pause(0.5);
msg.Linear.X = 0.0;
send(pubTb, msg);

end