%% with control points - matlab

close all
%load('trajectory_points4.mat');
%cpts=[cpts [15 5 4]'];
cpts = [rrt.smoothedPath]';
cptsold=cpts;

tpts = [0 length(rrt.smoothedPath)];

tvec = 0:0.01:length(rrt.smoothedPath);


%% Distance between consecutive cpts points
% the distance between two consecutive RRT points is computed and stored
for i=2:length(cpts)
    distance(i)=sqrt((cpts(1,i)-cpts(1,i-1))^2+(cpts(2,i)-cpts(2,i-1))^2+(cpts(3,i)-cpts(3,i-1))^2);
end

%% Filtering the points too close
% in the RRT we often have distances in the order of e^-30 between consecutive points.
% Therefore the RRT points with a distance > than the treshold are eliminated

treshold_distance=0.01;
cptfiltered=[cpts(:,1)];
for i=2:length(cpts)
    if distance(i)>treshold_distance
        cptfiltered=[cptfiltered,cpts(:,i)];
    end
end

cpts=[cptfiltered,cpts(:,length(cpts))];

%% Distance between the new points
% The distane between the filtered RRT points is now computed
for i=2:length(cpts)
    distance2(i)=sqrt((cpts(1,i)-cpts(1,i-1))^2+(cpts(2,i)-cpts(2,i-1))^2+(cpts(3,i)-cpts(3,i-1))^2);
end
distance2=distance2(2:length(distance2));
totaldistance=sum(distance2);

%% Definition of the number os substeps per step
% all the trajectory is then divided in to substeps of length
% "substeplength"
substeplength=0.2; %it can be changed to obtain more or less points
nsubsteps=floor(distance2/substeplength);

for i=1:length(nsubsteps)
    if nsubsteps(i)==0
       nsubsteps(i)=1;
    end
end

ntotalsteps=sum(nsubsteps);
%% Division in substeps
x=[];
y=[];
z=[];
for i=1:length(cpts)-1
    xstep=linspace(cpts(1,i),cpts(1,i+1),nsubsteps(i));
    x=[x,xstep];
    ystep=linspace(cpts(2,i),cpts(2,i+1),nsubsteps(i));
    y=[y,ystep];
    zstep=linspace(cpts(3,i),cpts(3,i+1),nsubsteps(i));
    z=[z,zstep];
end

figure(2)
plot3(x,y,z);

x_n=x;
y_n=y;
z_n=z;





