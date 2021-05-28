FROM ros:kinetic-ros-base

RUN apt-get update && apt-get install -y cmake git
RUN apt-get update && apt-get install -y libeigen3-dev libpcl-dev libsuitesparse-dev
RUN apt-get update && apt-get install -y ros-kinetic-tf ros-kinetic-pcl-ros
RUN rm -rf /var/lib/apt/lists/*


RUN git clone --depth=1 https://github.com/Livox-SDK/Livox-SDK.git
RUN git clone --depth=1 https://github.com/Livox-SDK/livox_ros_driver.git ws_livox/src
RUN git clone --depth=1 https://github.com/BellosC/horizon_highway_slam.git root/horizon_highway_slam

WORKDIR /Livox-SDK/build

RUN cmake .. && make -j"$(($(nproc)+1))" && make install -j"$(($(nproc)+1))"

RUN /bin/bash -c '. /opt/ros/kinetic/setup.bash; cd /ws_livox; catkin_make -j"$(($(nproc)+1))"'

COPY entrypoint.sh /

WORKDIR /

ENV BAGNAME lidar-bag
ENV IMU 0

ENTRYPOINT [ "./entrypoint.sh" ]
