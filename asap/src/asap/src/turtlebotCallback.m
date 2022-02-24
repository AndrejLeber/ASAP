function turtlebotCallback(obj, src, msg)
global turtlebotStates

i = find(src.Name ==  "turtlebot3_burger");
turtlebotStates.position.x = src.Pose(i).Position.X;
turtlebotStates.position.y = src.Pose(i).Position.Y;
turtlebotStates.position.z = src.Pose(i).Position.Z;

turtlebotStates.orientation.x = src.Pose(i).Orientation.X;
turtlebotStates.orientation.y = src.Pose(i).Orientation.Y;
turtlebotStates.orientation.z = src.Pose(i).Orientation.Z;
turtlebotStates.orientation.w = src.Pose(i).Orientation.W;

%% Kovertiere Orientierung im Quaternion-Format ins Euler-Format
eulerAngles = quat2eul([turtlebotStates.orientation.x, turtlebotStates.orientation.y, turtlebotStates.orientation.z, turtlebotStates.orientation.w]);

turtlebotStates.orientation.alpha = rad2deg(eulerAngles(1)); % Rotation um x [°]
turtlebotStates.orientation.beta = rad2deg(eulerAngles(2)); % Rotation um y [°]
turtlebotStates.orientation.gamma = rad2deg(eulerAngles(3)); % Rotation um z [°]

%fprintf("TurtleBot: x = %1.2f , y = %1.2f, z = %1.2f, alpha = %1.2f\n", turtlebotStates.position.x, turtlebotStates.position.y, turtlebotStates.position.z, turtlebotStates.orientation.gamma);
                                   
end