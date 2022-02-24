# asap
Architektur und Pfadplanung - Projekt mit dem Turtlebot3 und einem MATLAB FF-Planer

Autoren: Blerim Gashi, Andrej Leber

Voraussetzungen: Matlab2020a mit installierter ROS Toolbox, ROS Melodic Desktop Full Package inkl. Gazebo
		 (Hinweis: Abweichende MATLAB-Versionen wurden nicht getestet und könnten unter Umständen zu Fehlern führen!)


Anleitung zum Aufsetzen des Systems:

1. In der Bashrc ist es notwendig, das verwendete Turtlebot-Model auf "Burger" zu setzten. Dazu folgenden Befehl im Terminal ausführen:

          echo "export TURTLEBOT3_MODEL=burger" >> ~/.bashrc

2. Die ROS_MASTER_URI muss innerhalb der Bashrc auf die IP-Adresse des Rechners gesetzt werden, damit MATLAB mit dem ROS-Master kommunizieren kann. Dazu folgenden Befehl im Terminal ausführen ("type.in.your.ip" mit der entsprechenden IP ersetzen):

          echo "ROS_MASTER_URI=http://type.in.your.ip:11311" >> ~/.bashrc

3. Damit die Änderungen wirksam werden, entweder ein neues Terminal öffnen oder die Bashrc im aktuellen Terminal sourcen.

4. ZIP-Datei entpacken und im Terminal aufs entsprechende Verzeichnis wechseln:

          cd /path_to_folder_asap 

5. Catkin Workspace erstellen (Es sollten keine Fehler auftreten):

          catkin_make

6. Environment-Variable $ROS_PACAKGE_PATH dauerhaft (in Bashrc) auf den neuen Catkin Workspace setzen und anschließend neues Terminal öffnen oder Bashrc im aktuellen Terminal neu sourcen:  

          echo "export ROS_PACKAGE_PATH=/path_to_folder_asap/src:/opt/ros/melodic/share" >> ~/.bashrc

7. Launch-File starten um die Umgebung in Gazebo zu öffnen:

          roslaunch asap asap.launch

8. Ins Verzeichnis src des heruntergelandenen Pakets wechseln und MATLAB starten

          cd /path_to_folder_asap/src/asap/src
          matlab

9. Innerhalb der Funktion rosInit() in Matlab die IP-Adresse entsprechend "type.in.your.ip" aus Schritt 2 anpassen.

10. In Matlab das m-File main ausführen.

Falls Sie Probleme beim Aufsetzen des Systems haben sollten, können Sie uns gerne unter aleber@stud.hs-heilbronn.de und/oder bgashi@stud.hs-heilbronn.de kontaktieren.

-----------------------------------------------------------------------------

Hinweis: Um die Steuerung des Roboters zu verbesseren und ein "Schieben" der Dose zu ermöglichen wurden die Radreibungen des Turtlebot3 sowie das Gewicht der Cola-Dose wie folgt angepasst (Nur relevante Ausschnitte hier eingefügt):

gedit $(rospack find turtlebot3_description)/urdf/turtlebot3_burger.gazebo.xacro

	<gazebo reference="wheel_left_link">
    		<mu1>0.5</mu1>
    		<mu2>0.5</mu2>
    		...
  	</gazebo>

  	<gazebo reference="wheel_right_link">
    		<mu1>0.5</mu1>
    		<mu2>0.5</mu2>
   		...
  	</gazebo>

gedit ~/.gazebo/models/coke_can/model.sdf

	<inertial>
        	...
        	<mass>0.1</mass>
		...
        </inertial>

	 <friction>
            <ode>
              <mu>0.5</mu>
              <mu2>0.5</mu2>
            </ode>
          </friction>

