function updateModelPose(pose, publisher, modelName)

msg = rosmessage(publisher); % Erstelle Nachricht mit richtigem msg-Typ
msg.ModelName = modelName;

% Pose
msg.Pose.Position.X = pose.x;
msg.Pose.Position.Y = pose.y;
msg.Pose.Position.Z = pose.z;

% Orientierung
if (modelName == "turtlebot3_burger")
eul = [pose.theta 0.0 0.0]; % Euler Winkel
elseif (modelName == "Coke")
eul = [pose.theta pose.theta pose.theta]; % Euler Winkel
end
q = eul2quat(eul); % Konvertierung zu Quaternion
msg.Pose.Orientation.W = q(1);
msg.Pose.Orientation.X = q(2);
msg.Pose.Orientation.Y = q(3);
msg.Pose.Orientation.Z = q(4);


% Senden der Nachricht
send(publisher, msg);

end