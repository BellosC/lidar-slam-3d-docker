# lidar-slam-3d-docker

1. Make account to docker and download docker (https://docs.docker.com/get-docker/)

1. At your "Home" folder, create another folder with the name "shared_dir"

1. Connect LIDAR (Livox Horizon) to PC using Ethernet.

1. Open terminal and type:
```sh
docker run -it --rm --volume=$HOME/shared_dir:/root/shared_dir:rw --net=host costasbellos/lidar-slam-3d-docker:latest
```

> Docker will try to **pull and run** the docker image *costasbellos/lidar-slam-3d-docker:latest* that i have build and pushed to Dockerhub.

> If you want at the end of the command you can add a <name_of_my_file> and a number for the IMU between 0 and 2, for example <0>. 

> From default if you don't add something the program will give automatically a name to your file and also set the IMU parameter to zero (0). Everything will be saved at the *shared_dir* folder that you created previously.

> IMU: choose IMU information fusion strategy, there are 3 mode:

> 0 - whithout using IMU information, pure lidar SLAM.

> 1 - using gyroscope integration angle to eliminate the rotation distortion of the lidar point cloud in each frame.

> 2 - tightly coupling IMU and lidar information to improve SLAM effects. Requires a careful initialization process, and still in beta stage.


5. When it starts running, capture data (.bag file) for as much as you like.

1. <kbd>Ctrl</kbd> + <kbd>C</kbd>
   
1. wait until the .bag file that you created previously will be filtered through the SLAM algorithm. When the time on the screen ends your *slammed .bag file* will be ready for use.
   
   If you have rviz (and ROS) installed in your computer, **simultaneously with step 7** you can open **another tab at your terminal** and run the command 
   ```sh
   rosrun rviz rviz -d horizon_highway_slam/rviz_cfg/horizon_highway_slam.rviz
   ```

   
2. <kbd>CTRL</kbd> + <kbd>C</kbd>
   
3. Now the program will create .pcd files for you and  if you have the pcl_viewer installed, a window with your 3D model will open automatically.

4. If you want to open the .pcd files with another program like CloudCompare, first change the ownership of the folder inside you shared_dir folder from root to user in order to be able to use the .pcd files:
   ```sh
   sudo chown -R $USER:$USER <path of my file/folder>
   ```
    then drug and drop them to CloudCompare. After that, you can save them as .E57 format if you want through the CloudCompare.

-----------------------------------------------------
----------------------------------------------------------------------------------------------------------


### **SOME EXTRAS ONLY FOR COOL UBUNTU USERS**
CoolStep1: At your "Home" directory, create a folder named "shared_dir"

CoolStep2: Open your bashrc file with VS code:
```sh
code .bashrc
```
CoolStep3: Add the following at the end:

```sh
function sex_drugs_and_rock_n_roll() {
    mkdir -p "${HOME}/shared_dir"

    docker run \
        -it \
        --rm \
        --volume="${HOME}/shared_dir":/root/shared_dir:rw \
        --net=host \
        --env BAGNAME="${1:-lidar-bag}" \
        --env IMU="${2:-0}" \
        costasbellos/lidar-slam-3d-docker:latest

    if command -v pcl_viewer >/dev/null; then
        pcl_viewer $HOME/shared_dir/${1:-lidar-bag}_pcd/*
    else
        echo "pcl_viewer not found. Install with \`sudo apt-get install pcl-tools\`."
    fi
}
```

CoolStep4: open a terminal and type:
```sh
sex_drugs_and_rock_n_roll <name_of_my_file> <IMU_0_or_1_or_2>
```

>You can now follow the original procedure from **Step 5**
-------------------------------------------------
-------------------------------------------------
### **INFO**: The docker image **costasbellos/lidar-slam-3d-docker:latest** it is mostly a combination of **livox_ros_driver** package in order to capture .bag files, and of **horizon_highway_slam** package in order to apply slam to the captured data. ###
