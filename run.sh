#!/bin/bash

xhost +

REPOSITORY_NAME="$(basename "$(dirname -- "$( readlink -f -- "$0"; )")")"

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

export HOST_UID=$(id -u)

docker compose -f $SCRIPT_DIR/docker-compose.yml run \
--volume $(pwd)/piper_ros:/colcon_ws/src/piper_ros \
--volume /tmp/.X11-unix \
--env DISPLAY \
${REPOSITORY_NAME} bash
