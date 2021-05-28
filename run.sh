#!/bin/bash

echo "Launching lidar-slam-3d-docker:latest"

mkdir -p ${HOME}/shared_dir

docker run \
    -it \
    --rm \
    --volume=$HOME/shared_dir:/root/shared_dir:rw \
    --net=host \
    --env BAGNAME="${1:-lidar-bag}" \
    --env IMU="${2:-0}" \
    lidar-slam-3d-docker:latest

if command -v pcl_viewer >/dev/null; then
    pcl_viewer $HOME/shared_dir/${1:-lidar-bag}_pcd/*
else
    echo "pcl_viewer not found. Install with \`sudo apt-get install pcl-tools\`."
fi
