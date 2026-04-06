#!/bin/bash

echo "Sourcing startup scripts"
source /home/jetson/.profile
source /home/jetson/.bashrc

echo "Going to /home/jetson/whiteM4_ros2/m4-firmware-ros2"

cd /home/jetson/whiteM4_ros2/m4-firmware-ros2

# echo "Creating two tmux sessions (interface, control)"
echo "Creating tmux sessions (control)"

# Start two detached (-d) tmux sessions called interface and control
# tmux new-session -d -s interface
tmux new-session -d -s control

# echo "Starting docker on both of them"

# Start docker on both of them
# tmux send-keys -t interface './run_docker.sh' Enter

# sleep 3

# tmux send-keys -t control './new_docker_terminal.sh' Enter

# sleep 3

# echo "Starting interfaces.launch on interface"

# # start interfaces.launch
# tmux send-keys -t interface 'cd m4_ws' Enter
# tmux send-keys -t interface 'source devel/setup.bash' Enter
# tmux send-keys -t interface 'roslaunch m4_base interfaces.launch' Enter

# sleep 3

echo "Starting m4_control.launch.py on control"

# start m4_control.launch  <with tmux only>
tmux send-keys -t control 'cd /home/jetson/whiteM4_ros2/m4-firmware-ros2/m4_home/m4_ws' Enter
tmux send-keys -t control 'source install/setup.bash' Enter
tmux send-keys -t control 'ros2 launch m4_firmware m4_control.launch.py' Enter

sleep 3

# python3 led/on.py

echo "Robot Operational !"
