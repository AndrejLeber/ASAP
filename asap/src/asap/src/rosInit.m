function rosInit()

% shuts down existing rosinit
rosshutdown;
% connection
rosinit('http://192.168.100.32:11311');
% HelperClass For Gazebo Communications
gazebo = ExampleHelperGazeboCommunicator();

end