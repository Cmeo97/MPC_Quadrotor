Here you can find instructions on how to run the simulation. You need to run multiple files in order to obtain the final results. 
The particular steps are given below:

1. First run the file "RRT_runme.m". With this file the trajectory for the static environment is generated. The files "get_axis_handle.m", "obstacles.txt", "RrtPlanner.m", "RrtPlannerTests.m" must be at the same folder.

2. By running the "RRT_runme.m" several times, different trajectories can be generated. This means that the weights of the MPC etc, need retuning in order to obtain a nice result, as shown in the paper. Alternatively, we suggest that you load the data we have already saved ("trajectory_points.mat") for a particular trajectory.

3. Next step is to run the file “trajectory.m”, which filters the data and produces a desirable number of points equally spaced.

4. Then Run “MPC.m”, by running it Drone’s control inputs and states are computed. 

4.a If you want to see the simulation results we shown in the video, instead of running “MPC.m”, you can load directly the data: “Simulation.mat”.

5. Finally, run the “visualization.m” to obtain the video simulation with the drone navigating through the dynamic environment. At the end of the script a video called "DroneVideo"
   in which the real time simulaation is smoothly represented.
