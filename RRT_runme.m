clear all
clc
% The static environment is generated with planes. Each plane is described
% by the 4 corner points. These are defined in "obstacles.txt".
obstacleFilename = 'obstacles.txt';
seedsPerAxis = 7;
treesMax = seedsPerAxis^3*3+2;

% The main algorithm of the RRT is documented in MATLAB and our RRT is
% based on that. Moreover, in the "RrtPlanner.m" we can define the size of
% our environment, the star and the goal.
rrt = RrtPlanner(treesMax,seedsPerAxis,obstacleFilename);
rrt.drawingSkipsPerDrawing = 30;
rrt = RrtPlanner(treesMax,seedsPerAxis,obstacleFilename);
rrt.Run()
plot3(rrt.path(:,1),rrt.path(:,2),rrt.path(:,3),'k*');
 