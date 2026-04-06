# How to connect to the robot
The robot has to be powered on and connected to the same router as your laptop (host). You can ssh into the robot using the hostname:

```bash
ssh num4@num4.local
```

Input the password (num4). Once you have successfully ssh'd into the robot you can follow the following steps to use the software. If any of the code has to be built/re-built we are using a ros docker running ros-noetic. Then you can do the usual catkin build pipeline to update the code. 

# Software Use on M4
The `startup.sh` script will automatically run the various interfaces needed to control the robot (you might need to run this using sudo).
Once the boot is complete the LED indicator lights up (if the LED is properly connected - see script in led folder to find out which pin is being activated) to indicate that the robot is operational and can be controlled via remote control.

# Concepts
The robot is operated by a master **Jetson Orin** (decision making) connected to **Cube Orange** (flight control). It is also equipped with additional sensors for later applications (see [user manual](docs/manual.pdf) for a list of components).

The software architecture relies on getting user inputs from a remote control and translating them into commands distributed via ROS. The slaves are left to operate freely towards execution of the commands, feedback is only sent upon acceptance or safe completion.

# Dev Know-How
Here are some of the main things to consider when using the robot:

* If you want `startup.sh` to be launched on startup, you need to put it into /etc/rc.local which runs everytime the Nvidia Jetson Orin boots up. It launches two tmux sessions named `interface` and `control` **using sudo**. 
If the user wishes to see the information provided from the `interfaces.launch` and the `m4_control.launch` scripts which are running in the two tmux sessions, they must call `sudo tmux a -t interface` to attach to the interface session and `sudo tmux a -t control` to attach to the control session.
Sudo is necessary every time tmux is called. For example when looking for active sessions the user must specify `sudo tmux ls`.

* To exit the control script `ssh` into the onboard computer, and run `sudo tmux send-keys -t control 'C-c'`. This should kill the m4_control.launch script, move the robot to sit configuration and switch of the servos.
* To properly switch off the robot the user should also terminate the interfaces.launch script by running `sudo tmux send-keys -t interface 'C-c'`

* If you wish to re-launch the interfaces.launch script after it has been exited, without rebooting the onboard computer, you must **unplug the pixhawk from the orin and plug it in again** before launching the script again. The control script can then be launched as normal i.e. `sudo tmux send-keys -t control 'roslaunch m4_base m4_control.launch'`

# General debugging FAQ
  * Devices that need to be connecteed are pixhawk, u2d2, and teensy. They should show up in /dev/ folder if the udev setup rules (`setup_scripts/set_udev_rules.sh`) have been setup correctly and if there is no hardware fault.
  * If you don't see the devices either the device is not configured correctly or the USB connection is at fault.
  * If you are unable to connect to the robot, power on the NVIDIA and plug in a monitor (before boot), a mouse, and a keyboard in order to setup the computer properly from the Ubuntu Graphic User Interface.
  * If the robot controllers are not running or something is faulty, all error messages are in the tmux running terminals, that you can access as explained above.
  * If the tmux terminals aren't running go back and inspect the startup script for potential faults.
