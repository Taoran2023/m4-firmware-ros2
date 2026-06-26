# Aerial PVA setpoint emitted by the local planner executor (S6 / F2).
# All quantities are in the ROS odometry (ENU, FLU body) frame named by header.frame_id;
# NO frame conversion is done here — the firmware transforms to the PX4 NED frame
# (same TF path as /auto/waypoint) before publishing px4_msgs/TrajectorySetpoint.
std_msgs/Header          header        # frame_id = odom ENU frame

geometry_msgs/Point      position      # ENU, meters
geometry_msgs/Vector3    velocity      # ENU, m/s   (feed-forward)
geometry_msgs/Vector3    acceleration  # ENU, m/s^2 (feed-forward)
geometry_msgs/Quaternion orientation   # desired heading (ENU FLU body); null quat = yaw uncontrolled
float64                  yawspeed      # rad/s about ENU up axis; NaN = uncontrolled
