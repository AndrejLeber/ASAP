%% Autonomous Systems: Architectur and Planning
%  Autoren: Blerim Gashi, Andrej Leber
%  Letzte Änderung: 18.02.2022

%% Turtlebot3 Simulation mit integriertem FF-Planner
clearvars; clc;

%% Initialisierung der ROS und Gazebo Kommunikation mit dem ROS Master
rosInit();

%% Globale Parameter
global turtlebotStates
global trashStates

%% Konfiguriere und erstelle alle notwenigen Subscriber
modelStatesTurtlebot = rossubscriber('/gazebo/model_states', @turtlebotCallback);
modelTrashStates = rossubscriber('/gazebo/model_states', @trashCallback);

%% Konfiguriere und erstelle alle notwendigen Publisher
pubPose = rospublisher("/gazebo/set_model_state");
moveRobot = rospublisher("/cmd_vel");

pause(1.0); % Pause, um alle Subscriber und Publisher vollständig zu initialiseren

%% Deklaration der Gazebo-Welt-Dimensionen in Matlab
fieldSize = 3; % Länge und Breite des gesamten Feldes
numOfFields = 36; % Anzahl der äquivalenten und äquidistanten Einzelfelder (ausgenommen: Müllzone)
w = fieldSize/sqrt(numOfFields); % Länge und Breite eines Einzelfeldes
generateField(fieldSize,numOfFields);
load('field.mat');

%% Stoppe Roboter, falls Ansteuerung noch aktiv
msg = rosmessage(moveRobot);
msg.Linear.X = 0.0; msg.Linear.Y = 0.0; msg.Linear.Z = 0.0;
msg.Angular.X = 0.0; msg.Angular.Y = 0.0; msg.Angular.Z = 0.0;
send(moveRobot, msg);

%% Setze (zufällige Startposition für Roboter und Müll
% Anforderung: Der Müll darf sich nicht an den seitlichen und unteren
% Randfeldern befinden, da sonst der Transport des Mülls in die Müllzone
% durch "Schieben" oder "Kicken" quasi nicht mehr realisiert werden kann.
% Abhilfe könnte hier ein Greiferkonzept schaffen, das aber den Rahmen des
% Projekts sprengen würde.
safetyDistance = w/2; % Sicherheitsabstand, um eine Kollision von Roboter und Wand zu vermeiden [m]
% Roboter
randStartPoseTurtlebot.x = rand() * fieldSize;
randStartPoseTurtlebot.y = rand() * fieldSize;
randStartPoseTurtlebot.z = 0.0;
randStartPoseTurtlebot.theta = deg2rad(rand()*360);
if (randStartPoseTurtlebot.x > fieldSize - safetyDistance)
    randStartPoseTurtlebot.x = fieldSize - safetyDistance;
elseif (randStartPoseTurtlebot.x < safetyDistance)
    randStartPoseTurtlebot.x = safetyDistance;
elseif (randStartPoseTurtlebot.y < safetyDistance)
    randStartPoseTurtlebot.y = safetyDistance;
elseif (randStartPoseTurtlebot.y > fieldSize - safetyDistance)
    randStartPoseTurtlebot.y = fieldSize - safetyDistance;
end
% Müll
randStartPoseTrash.x = w + rand() * (fieldSize-2*w);
randStartPoseTrash.y = w + rand() * (fieldSize-2*w);
randStartPoseTrash.z = 0.0;
randStartPoseTrash.theta = deg2rad(rand()*360);

% Update Gazebo-Positionen
updateModelPose(randStartPoseTurtlebot, pubPose, 'turtlebot3_burger');
updateModelPose(randStartPoseTrash, pubPose, 'Coke');

pause(2.0);

%% Beginne Ausführung des aktuellen Plans innerhalb einer Schleife

while true
    startCycle = true;
    pause(2.0);
    % Frage aktuelle Feldposition von Roboter und Müll ab
    currentTurtlebotField = getModelFieldPos(field, turtlebotStates);
    currentTrashField = getModelFieldPos(field, trashStates);
    
    % Update ProblemTurtlebot.pddl in Bezug auf die aktuellen Feldpositionen
    updateProblemPDDL(currentTurtlebotField, currentTrashField)
    
    planningPossible = true;
    if (contains(currentTrashField,"a") || contains(currentTrashField,"f") || ...
            contains(currentTrashField,"6"))
        planningPossible = false;
    end
    
    %% Erstelle Plan
    % Um zu vermeiden, dass der Roboter während der Fahrt zur
    % "Schiebeposition" durch das Feld fährt, auf dem sich der Müll
    % befindet und den Müll im Worst-Case an den unteren Rand des Gebäudes
    % schiebt, ist es notwendig, den Plan solange erneut erstellen zu
    % lassen, bis eine Möglichkeit gefunden wurde, das Müllfeld bei der
    % Anfahrt zu umfahren. Dies ist nachfolgend implementiert ...
    % Hinweis: Normalerweise sollte diese Anforderung in der
    % DomainTurtlebot.pddl implementiert werden. Leider unterstützt der
    % eingesetzte Planer aber nicht das "Equality-Requierement"
    % (Bool'scher Vergleich von Variablen), sodass von uns keine
    % Möglichkeit gefunden wurde, die Anforderung innerhalb der Domain
    % umzusetzen.
    
    cnt = 0;
    n = 1;
    
    while true
        if (planningPossible == true)
            plan = FF_Planner();
        else
            fprintf("\n\n\nMüll kann von aktueller Position aus nicht in die Müllzone gebracht werden.\nProgrammabbruch ...\n");
            rosshutdown;
            return;
        end
        
        for i = 1:length(plan(:,1))
            splan = string(plan);
            if (splan(i,1) == "move_turtlebot" && splan(i,3) == currentTrashField && not(splan(i,2) == splan(i,3)))
                cnt = cnt+1;
                currentTurtlebotField = getModelFieldPos(field, turtlebotStates);
                currentTrashField = getModelFieldPos(field, trashStates);
                updateProblemPDDL(currentTurtlebotField, currentTrashField);
                fprintf("Plan entspricht nicht den Anforderungen, Planung wird erneut durchgeführt.\n\n\n");
            end
        end
        n = n+1;
        if cnt == 0
            break;
        elseif n == 10
            n = 1;
            pause(1.0);
            if (trashStates.position.x < fieldSize/2)
                 makeTurn(modelStatesTurtlebot, moveRobot, 0, 0, 0.3, 5.0, 45);
            else
                 makeTurn(modelStatesTurtlebot, moveRobot, 0, 0, 0.3, 5.0, 135);
            end
            msg.Linear.X = -0.2;
            send(moveRobot, msg);
            pause(3.0);
            msg.Linear.X = 0.0;
            send(moveRobot, msg);
        end
        cnt = 0;
    end
    
    %% Führe Plan aus
    if (not(startCycle == true))        
        msg.Linear.X = -0.1;
        send(moveRobot, msg);
        pause(1.0);
        msg.Linear.X = 0.0;
        send(moveRobot, msg);
        startCycle = false;
    end
    executePlan(plan, modelStatesTurtlebot, modelTrashStates, moveRobot, field);
    
    %% Beende Schleife, wenn Müll innerhalb der Müllzone ist
    currentTrashField = getModelFieldPos(field, trashStates);
    if (isequal(currentTrashField, "trash_zone"))
        % Fahre Robter aus der Mpllzone heraus
        pause(1.0);
        msg.Linear.X = -0.1;
        send(moveRobot, msg);
        pause(5.0);
        msg.Linear.X = 0.0;
        send(moveRobot, msg);
        % Programmende
        fprintf("\n\n\nMüll befindet sich innerhalb der Müllzone.\nProgrammende ...\n");
        rosshutdown;
        break;
    end
end
