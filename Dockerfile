ARG ROS_DISTRO=humble

FROM ros:${ROS_DISTRO}-ros-core

# Install packages and dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    python3-colcon-common-extensions \
    python3-pip \
    ros-${ROS_DISTRO}-ros2-control \
    ros-${ROS_DISTRO}-ros2-controllers \
    ros-${ROS_DISTRO}-controller-manager \
    ros-${ROS_DISTRO}-rviz2 \
    ros-${ROS_DISTRO}-gazebo-ros \
    ros-${ROS_DISTRO}-gazebo-ros2-control \
    ros-${ROS_DISTRO}-joint-state-publisher-gui \
    ros-${ROS_DISTRO}-xacro \
    ros-${ROS_DISTRO}-robot-state-publisher \
    ethtool \
    can-utils \
    && rm -rf /var/lib/apt/lists/*

RUN pip install python-can scipy piper_sdk

# Copy entrypoint script (which creates ros user with same uid/gid as host user)
COPY ros_entrypoint.sh /ros_entrypoint.sh

WORKDIR /colcon_ws

# Uncomment to copy and build source_packages in colcon workspace  
COPY ./piper_ros src/piper_ros 

RUN . /opt/ros/${ROS_DISTRO}/setup.sh && \
    colcon build --symlink-install --event-handlers console_direct+ --cmake-args ' -DCMAKE_BUILD_TYPE=Release'

# Set package's launch command
ENV LAUNCH_COMMAND='ros2 launch piper start_single_piper_rviz.launch.py'

# Create build and run aliases
RUN echo 'alias build="colcon build --symlink-install  --event-handlers console_direct+"' >> /etc/bash.bashrc && \
    echo 'alias run="su - ros --whitelist-environment=\"DISPLAY,ROS_DOMAIN_ID\" /run.sh"' >> /etc/bash.bashrc && \
    echo "source /colcon_ws/install/setup.bash; echo UID: $UID; echo ROS_DOMAIN_ID: $ROS_DOMAIN_ID; $LAUNCH_COMMAND" >> /run.sh && chmod +x /run.sh
