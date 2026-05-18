std_msgs/Header header

# Current robot morphology configuration
# Matches M4ModeCmd.mode values:
#   -2 = SIT
#   -1 = INIT / UNKNOWN
#    0 = STAND
#    1 = UAV
#    2 = CROUCH1
#    4 = CROUCH2
int32 configuration

# Offboard state (aerial AUTO mode)
#   0 = INACTIVE
#   1 = PRE_ARM   (offboard heartbeat active, waiting for IMU settle)
#   2 = TRACKING  (armed, position control active)
#   3 = DESCENDING (odom lost, velocity descent mode)
int32 offboard_state

bool auto_mode_active  # AUTO switch is engaged
bool odom_healthy      # localization source is fresh
bool arm_pending       # G2A transform done, waiting for IMU settle before ARM
