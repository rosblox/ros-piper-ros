# Dockerized piper_ros ROS 2 package for the AgileX Piper

## Usage

On host:
```
./build.sh #Builds and tags Docker image
./run.sh   #Runs Docker image with correct options 
```
    
Inside container:
```
build   #Alias to build colcon_ws as root user
run     #Alias to run ROS package as correct user
```
