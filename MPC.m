
global r_0 t timestep   %global variables 
%% constants
tic
Ts = 0.12;
%number of obstacles
Nobs=3;

%% create controller

numStates = 12;
numOutputs = 6;
numControl = 4;

nlobj = nlmpc(numStates,numOutputs,numControl);
nlobj.Ts = Ts;
nlobj.PredictionHorizon = 8;
nlobj.ControlHorizon = 3;

nlobj.Model.StateFcn = "droneDT";
nlobj.Model.IsContinuousTime = false;
nlobj.Model.NumberOfParameters = 1;

nlobj.Model.OutputFcn = @(x,u,Ts) x(1:numOutputs);

%% define constraints
nlobj.Weights.OutputVariables = [1 1 1 1 1 1]*5;
nlobj.Weights.ManipulatedVariablesRate = [1 1 1 1]*0.1;


%% initialization
x0 = [-13 -12 0.5 0 0 0 0 0 0 0 0 0]';
u0 = zeros(numControl,1);

EKF = extendedKalmanFilter(@droneStateFcn,@droneMeasurementFcn);
EKF.State = x0;
uk = u0;

nloptions = nlmpcmoveopt;
nloptions.Parameters = {Ts};

%% run on simulated data
duration = round(length(x_n)/10); %changed by Fra to make it always consistent with trajectory.
yref = [x_n' y_n' z_n' x_n'-x_n' x_n'-x_n' x_n'-x_n'];
        
y = x0(1:6);

ukHistory = zeros(numControl,round(duration/Ts));
xHistory = zeros(numStates,round(duration/Ts+1));
xHistory(:,1) = x0;

xktotal=[];

  
c=1;
for timestep = 1:(length(x_n))
    t=timestep  % ensures that in the IneqConFunction all the variables are updated 
    xk = correct(EKF,y)
    xktotal=[xktotal,xk];  
   %compute optimal control actions
   
        if  xk(2)>4.5    %The drone gets in the room with obstacles when y>5
           if c==1
            nlobj.Weights.OutputVariables = [1 1 1 1 1 1]*1.7;
            nlobj.Weights.ManipulatedVariablesRate = [1 1 1 1]*0.1;         
            nlobj.PredictionHorizon = 6;
            nlobj.ControlHorizon = 1;
            c=c+1;
           end
     
            nlobj.Optimization.CustomIneqConFcn = "myIneqConFunction";
          
        else
           nlobj.Optimization.CustomIneqConFcn = "myIneqConFunction_blank";
        end

    % Compute control imputs trough mpc 
    [uk,nloptions,info] = nlmpcmove(nlobj,xk,uk,yref(timestep:min(timestep+9,(length(x_n))),:),[],nloptions);
    info.ExitFlag   % provide informations about the optimization 
    %Save control inputs 
    ukHistory(:,timestep) = uk;
    % Predict prediction model states for the next iteration
    predict(EKF,[uk; Ts]);
    % Implement first optimal control move
    x = droneDT(xk,uk,Ts);
    % Generate sensor data
    y = x(1:numOutputs) + randn(numOutputs,1)*0.01;
    % Save plant states
    xHistory(:,timestep+1) = x;

    
end

toc
