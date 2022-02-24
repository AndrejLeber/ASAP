function pushTrash(subscriberTurtlebot, subscriberTrash, publisher, field, startPosTurtlebot, dest, turnSpeed, driveSpeed, accuracy)

global turtlebotStates
global trashStates

thetaTb = turtlebotStates.orientation.gamma; % Momentaner Roboterwinkel um z [°]
thetaTr = trashStates.orientation.gamma; % Momentaner Lagewinkel Müll [°]
offset.x = 0.0; offset.y = 0.0; % Offset vom Messpnkt zur Robotermitte [m]
offset.x = 0.1 * sind(abs(thetaTr) + abs(thetaTb) - 45);

thetaAim = computeDrivingAngle(startPosTurtlebot, dest, offset); % Zielwinkel [°]
dtheta = thetaTb - thetaAim; % Winkeldifferenz [°]
fprintf("theta = %1.2f, thetaAim = %1.2f\n", thetaTb, thetaAim);

if ((dtheta <= 0 || dtheta > 180) && not(dtheta <-180))
    turndirection = 1;
else
    turndirection = -1;
end

msg = rosmessage(publisher);
msg.Linear.X = 0.0; msg.Linear.Y = 0.0; msg.Linear.Z = 0.0;
msg.Angular.X = 0.0; msg.Angular.Y = 0.0;

%% Drehmanöver
pause(0.5);
msg.Angular.Z = turndirection * turnSpeed;
send(publisher, msg);
fprintf("Beginne Drehmanöver nach %1.1f°\n", thetaAim);

while true
    receive(subscriberTurtlebot, 10);
    thetaTb = turtlebotStates.orientation.gamma;
    %fprintf("Aktueller Roboter-Winkel %1.1f\n", theta);
    if (thetaTb >= thetaAim - accuracy && thetaTb <= thetaAim + accuracy)
        msg.Angular.Z = 0.0;
        send(publisher, msg);
        fprintf("Drehmanöver abgeschlossen, theta = %1.1f°\n", thetaTb);
        break;
    end
    
end

%% Fahrmanäver
pause(0.5);
msg.Linear.X = driveSpeed;
send(publisher, msg);

destField = getModelFieldPos(field, dest);
fprintf("Beginne Fahrmanäver nach Feld %s\n", destField);
tic;
counter = 0;
trashReached = false;
goIn = true;

while true
    receive(subscriberTurtlebot, 10);
    xTb = turtlebotStates.position.x;
    yTb = turtlebotStates.position.y;
    
    startField = getModelFieldPos(field, dest);
    
    receive(subscriberTrash, 10);
    trashPos.x = trashStates.position.x;
    trashPos.y = trashStates.position.y;
    currentFieldTrash = getModelFieldPos(field, trashPos);
    
    % Berechne Winkelspanne zwischen Roboter und Zielrichtung Müllzone;
    leftTrashZoneWall.position.x = 1.0; leftTrashZoneWall.position.y = 3.0;
    rightTrashZoneWall.position.x = 2.0; rightTrashZoneWall.position.y = 3.0;
    leftTrashZoneAngle = computeDrivingAngle(turtlebotStates, leftTrashZoneWall);
    rightTrashZoneAngle = computeDrivingAngle(turtlebotStates, rightTrashZoneWall);
    
    dontStop = false;
    if (thetaTb > 0.0 && thetaTb <= leftTrashZoneAngle && thetaTb >= rightTrashZoneAngle)
        dontStop = true;
    end
    %fprintf("TEST: theta = %1.2f(%i), L=%1.2f(%i), R=%1.2f(%i), dontStop =%i \n", ...
     %       thetaTb, thetaTb > 0.0, leftTrashZoneAngle, thetaTb <= leftTrashZoneAngle, ...
      %      rightTrashZoneAngle, thetaTb >= rightTrashZoneAngle, dontStop);
    
    distToAim = sqrt(power(dest.position.x - xTb + offset.x, 2)+power(dest.position.y - yTb + offset.y, 2));
    %fprintf("DistToAim = %1.2f\n", distToAim);
    if (distToAim < 0.1 && goIn == true)
        trashReached = true;
        goIn = false;
    end
    
    if (counter == 0)
        distStorage = distToAim;
        currSpeed = driveSpeed;
    end
    counter = counter + 1;
    
    t = toc;
    if (t > 0.5)
        fprintf("Aktueller Abstand zum Müll: d = %1.2fm\n", distToTrash);
        %fprintf("Distanzänderung = %1.2f\n", distToAim - distStorage);
        tic;
        currSpeed = abs((distToAim-distStorage)/t);
        distStorage = distToAim;
        %fprintf("Geschwindigkeit = %1.4f\n", currSpeed);
    end
    
    distToTrash = sqrt(power(trashPos.x - xTb + offset.x, 2)+power(trashPos.y - yTb + offset.y, 2));
    
    if (not(dontStop) && not(isequal(currentFieldTrash,startField)) || trashReached == true && distToTrash > 0.3 || currSpeed < 0.01)
        if(currSpeed < 0.01)
            fprintf("Schiebemanöver abgebrochen, vermutlich aufgrnd einer Kollision.\n");
            msg.Linear.X = -0.1;
            send(publisher, msg);
            pause(1.0);
            msg.Linear.X = 0.0;
            send(publisher, msg);
            break;
        end
        pause(0.5);
        msg.Linear.X = 0.0;
        send(publisher, msg);
        fprintf("Schiebemanöver abgeschlossen, x = %1.1fm, y = %1.1fm\n", xTb, yTb);
        pause(0.1);
        break; 
    end   
end

%% Kurzes Zurückfahren des Roboters, um zu vermeiden, dass der Roboter beim Fahren ins nächste Feld mit dem Müll kollidiert
msg.Linear.X = -0.1;
send(publisher, msg);
pause(1.0);
msg.Linear.X = 0.0;
send(publisher, msg);

end