function trashCallback(obj, src, message)
global trashStates

i = find(src.Name ==  "Coke");

trashStates.position.x = src.Pose(i).Position.X;
trashStates.position.y = src.Pose(i).Position.Y;
trashStates.position.z = src.Pose(i).Position.Z;

trashStates.orientation.x = src.Pose(i).Orientation.X;
trashStates.orientation.y = src.Pose(i).Orientation.Y;
trashStates.orientation.z = src.Pose(i).Orientation.Z;
trashStates.orientation.w = src.Pose(i).Orientation.W;

%% Kovertiere Orientierung im Quaternion-Format ins Euler-Format
eulerAngles = quat2eul([trashStates.orientation.x, trashStates.orientation.y, trashStates.orientation.z, trashStates.orientation.w]);

trashStates.orientation.alpha = rad2deg(eulerAngles(1)); % Rotation um x [°]
trashStates.orientation.beta = rad2deg(eulerAngles(2)); % Rotation um y [°]
trashStates.orientation.gamma = rad2deg(eulerAngles(3)); % Rotation um z [°]

%fprintf("Trash: x = %1.2f , y = %1.2f, z = %1.2f, alpha = %1.2f\n", trashStates.position.x, trashStates.position.y, trashStates.position.z, trashStates.orientation.gamma);
     
end