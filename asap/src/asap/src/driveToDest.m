function driveToDest(subscriber, publisher, field, currPos, dest, turnSpeed, driveSpeed, accuracy)

global turtlebotStates

theta = turtlebotStates.orientation.gamma; % Momentaner Roboterwinkel um z [°]
offset.x = 0.0; offset.y = 0.0; % Offset vom Messpnkt zur Robotermitte [m]
thetaAim = computeDrivingAngle(currPos, dest, offset); % Zielwinkel [°]
dtheta = theta - thetaAim; % Winkeldifferenz [°]
fprintf("theta = %1.2f, thetaAim = %1.2f\n", theta, thetaAim);

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
    receive(subscriber, 10);
    theta = turtlebotStates.orientation.gamma;
    %fprintf("Aktueller Roboter-Winkel %1.1f\n", theta);
    if (theta >= thetaAim - accuracy && theta <= thetaAim + accuracy)
        msg.Angular.Z = 0.0;
        send(publisher, msg);
        fprintf("Drehmanöver abgeschlossen, theta = %1.1f°\n", theta);
        break;
    end
    
end

%% Fahrmanäver
pause(0.5);
msg.Linear.X = driveSpeed; 
send(publisher, msg);

destField = getModelFieldPos(field, dest);
fprintf("Beginne Fahrmanäver nach Feld %s\n", destField);
allowedDistRange = 0.01;
tic;
counter = 0;

while true
    
    receive(subscriber, 10);
    x = turtlebotStates.position.x;
    y = turtlebotStates.position.y;

    %fprintf("Aktuelle Roboter-Position: x = %1.1f, y = %1.1f\n", x, ys);
    distToAim = sqrt(power(dest.position.x - x + offset.x, 2)+power(dest.position.y - y + offset.y, 2));
    if (counter == 0)
        distStorage = distToAim;
    end
    counter = counter + 1;
    
    t = toc;
    if (t > 0.5)
        fprintf("Aktueller Abstand zum Zielfeld: d = %1.2fm\n", distToAim);
        fprintf("Distanzänderung = %1.2f\n", distToAim - distStorage);
        tic;
        distStorage = distToAim;
    end
    if (distToAim <= allowedDistRange || distToAim - distStorage > 0.02)
        msg.Linear.X = 0.0;
        send(publisher, msg);
        fprintf("Fahrmanöver abgeschlossen, x = %1.1fm, y = %1.1fm\n", x, y);
        pause(0.1);
        break;
    end
    
end

end