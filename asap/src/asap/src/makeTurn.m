function makeTurn(subscriber, publisher, currPos, dest, speed, accuracy, goalAngle)

global turtlebotStates

theta = turtlebotStates.orientation.gamma; % Momentaner Roboterwinkel um z [°]
thetaAim = goalAngle;
dtheta = goalAngle - theta;

if (nargin < 7)
    thetaAim = computeDrivingAngle(currPos, dest, 0.1); % Zielwinkel [°]
    dtheta = thetaAim-theta; % Winkeldifferenz [°]
end

if (dtheta >= 0)
    turndirection = 1;
else
    turndirection = -1;
end

msg = rosmessage(publisher);
msg.Linear.X = 0.0; msg.Linear.Y = 0.0; msg.Linear.Z = 0.0;
msg.Angular.X = 0.0; msg.Angular.Y = 0.0;

msg.Angular.Z = turndirection * speed;
send(publisher, msg);
fprintf("Beginne Drehung nach %1.1f°\n", thetaAim);

while true
    receive(subscriber, 10);
    theta = turtlebotStates.orientation.gamma;
    %fprintf("Aktueller Winkel %1.1f\n", theta);
    if (theta >= thetaAim - accuracy && theta <= thetaAim + accuracy)
        msg.Angular.Z = 0.0;
        send(publisher, msg);
        fprintf("Dreh-Manöver abgeschlossen, theta = %1.1f°\n", theta);
        pause(0.1);
        break;
    end
    
end

end