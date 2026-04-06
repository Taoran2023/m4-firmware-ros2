#!/bin/bash

# Replace these with the appropriate values
CONTAINER_NAME="m4_ros_noetic"
CMD="m4_control.launch"

# Run the command inside the Docker container to find the PID
pid=$(docker exec "$CONTAINER_NAME" pgrep -f "$CMD")

# Check if the PID was found
if [ -n "$pid" ]; then
    echo "Sending SIGINT to PID: $pid in container $CONTAINER_NAME"
    # Send SIGINT to the process inside the container
    docker exec "$CONTAINER_NAME" kill -SIGINT "$pid"

    # Wait for 20 seconds and check if the process is still running
    sleep 20
    if docker exec "$CONTAINER_NAME" ps -p $pid > /dev/null; then
       echo "Process $pid in container $CONTAINER_NAME did not terminate, escalating to SIGKILL..."
       # Send SIGKILL to the process inside the container
       docker exec "$CONTAINER_NAME" kill -SIGKILL "$pid"
	   sleep 5
    fi

	# Check if the process is still running
	if ! docker exec "$CONTAINER_NAME" ps -p $pid > /dev/null; then
		echo "Process $pid in container $CONTAINER_NAME terminated successfully."
		sleep 1
		echo "Stopping Docker container: $CONTAINER_NAME"
		docker stop "$CONTAINER_NAME"

		# Check if the container has stopped
		while true; do
			if ! docker ps -a | grep -q "$CONTAINER_NAME"; then
				echo "Container $CONTAINER_NAME has stopped."
				break
			else
				echo "Waiting for container $CONTAINER_NAME to stop..."
				sleep 5
			fi
		done

		# Shutdown the system
		echo "Shutting down the system now..."
		sleep 1
		shutdown now
	else
		echo "Process $pid in container $CONTAINER_NAME unable to terminate. Please try to do so manually"
    fi
else
    echo "No matching process found in container $CONTAINER_NAME."
fi
