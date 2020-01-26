function [] = RUN_MCMC_ALL_SIMUL_PARALLEL(readDataDirec,commIdx,thrIncl,offset,LB,UB,x0,burnin,sampleevery,njumps,prior,sig,filname)
offset  = offset+1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LOAD DATA FOR NO TREATMENT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
therapy    = 1;
load([readDataDirec 'EXP_' num2str(commIdx) '_NO_TREATMENT' ])
data_mean  = dataExp(offset:end,:);
y_1        = data_mean(:);
y0_1       = data_mean(1,:)';
T_1        = size(data_mean,1); % total duration
nt_1       = size(data_mean,1); % number of time points to simulate
[drugPressure_A,drugPressure_B,drugPressure_AB] = setDrugPressure(therapy,offset,T_1);
opt_1.tspan           = [1 T_1];             % interval of the simulation
opt_1.tint            = linspace(1,T_1,nt_1)';  % all time points
opt_1.y0              = y0_1;
opt_1.drugPressure_A  = drugPressure_A;
opt_1.drugPressure_B  = drugPressure_B;
opt_1.drugPressure_AB = drugPressure_AB;
opt_1.optionCommunity = commIdx;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LOAD DATA MONO A %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
therapy    = 2;
load([readDataDirec 'EXP_' num2str(commIdx) '_MONO_A' ])
data_mean  = dataExp(offset:end,:);
y_2        = data_mean(:);
y0_2       = data_mean(1,:)';
T_2        = size(data_mean,1); % total duration
nt_2       = size(data_mean,1); % number of time points to simulate
[drugPressure_A,drugPressure_B,drugPressure_AB] = setDrugPressure(therapy,offset,T_2);
opt_2.tspan           = [1 T_2];             % interval of the simulation
opt_2.tint            = linspace(1,T_2,nt_2)';  % all time points
opt_2.y0              = y0_2;
opt_2.drugPressure_A  = drugPressure_A;
opt_2.drugPressure_B  = drugPressure_B;
opt_2.drugPressure_AB = drugPressure_AB;
opt_2.optionCommunity = commIdx;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LOAD DATA MONO B %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
therapy    = 3;
load([readDataDirec 'EXP_' num2str(commIdx) '_MONO_B' ])
data_mean  = dataExp(offset:end,:);
y_3        = data_mean(:);
y0_3       = data_mean(1,:)';
T_3        = size(data_mean,1); % total duration
nt_3       = size(data_mean,1); % number of time points to simulate
[drugPressure_A,drugPressure_B,drugPressure_AB] = setDrugPressure(therapy,offset,T_3);
opt_3.tspan           = [1 T_3];             % interval of the simulation
opt_3.tint            = linspace(1,T_3,nt_3)';  % all time points
opt_3.y0              = y0_3;
opt_3.drugPressure_A  = drugPressure_A;
opt_3.drugPressure_B  = drugPressure_B;
opt_3.drugPressure_AB = drugPressure_AB;
opt_3.optionCommunity = commIdx;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LOAD DATA COMBINATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
therapy    = 4;
load([readDataDirec 'EXP_' num2str(commIdx) '_COMBINATION' ])
data_mean  = dataExp(offset:end,:);
y_4        = data_mean(:);
y0_4       = data_mean(1,:)';
T_4        = size(data_mean,1); % total duration
nt_4       = size(data_mean,1); % number of time points to simulate
[drugPressure_A,drugPressure_B,drugPressure_AB] = setDrugPressure(therapy,offset,T_4);
opt_4.tspan           = [1 T_4];             % interval of the simulation
opt_4.tint            = linspace(1,T_4,nt_4)';  % all time points
opt_4.y0              = y0_4;
opt_4.drugPressure_A  = drugPressure_A;
opt_4.drugPressure_B  = drugPressure_B;
opt_4.drugPressure_AB = drugPressure_AB;
opt_4.optionCommunity = commIdx;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LOAD DATA CYCLING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
therapy    = 5;
load([readDataDirec 'EXP_' num2str(commIdx) '_CYCLING' ])
data_mean  = dataExp(offset:end,:);
y_5        = data_mean(:);
y0_5       = data_mean(1,:)';
T_5        = size(data_mean,1); % total duration
nt_5       = size(data_mean,1); % number of time points to simulate
[drugPressure_A,drugPressure_B,drugPressure_AB] = setDrugPressure(therapy,offset,T_5);
opt_5.tspan           = [1 T_5];             % interval of the simulation
opt_5.tint            = linspace(1,T_5,nt_5)';  % all time points
opt_5.y0              = y0_5;
opt_5.drugPressure_A  = drugPressure_A;
opt_5.drugPressure_B  = drugPressure_B;
opt_5.drugPressure_AB = drugPressure_AB;
opt_5.optionCommunity = commIdx;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LOAD DATA MIXING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
therapy    = 6;
load([readDataDirec 'EXP_' num2str(commIdx) '_MIXING' ])
data_mean  = dataExp(offset:end,:);
y_6        = data_mean(:);
y0_6       = data_mean(1,:)';
T_6        = size(data_mean,1); % total duration
nt_6       = size(data_mean,1); % number of time points to simulate
[drugPressure_A,drugPressure_B,drugPressure_AB] = setDrugPressure(therapy,offset,T_6);
opt_6.tspan           = [1 T_6];             % interval of the simulation
opt_6.tint            = linspace(1,T_6,nt_6)';  % all time points
opt_6.y0              = y0_6;
opt_6.drugPressure_A  = drugPressure_A;
opt_6.drugPressure_B  = drugPressure_B;
opt_6.drugPressure_AB = drugPressure_AB;
opt_6.optionCommunity = commIdx;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

params.burnin =burnin;    % #iterations before sampling starts
params.njumps =njumps;    % #sampling iterations
params.nchains=1;   % #chains -> because parallel
params.sampleevery=sampleevery;     % #thinning of the chain
params.thrIncl=thrIncl;

chains       =mh_SIMUL(prior,sig,...
    y_1,y_2,y_3,y_4,y_5,y_6,x0,...
    @(x)(fhngen_ROBOT_ALL(x,opt_1)),...
    @(x)(fhngen_ROBOT_ALL(x,opt_2)),...
    @(x)(fhngen_ROBOT_ALL(x,opt_3)),...
    @(x)(fhngen_ROBOT_ALL(x,opt_4)),...
    @(x)(fhngen_ROBOT_ALL(x,opt_5)),...
    @(x)(fhngen_ROBOT_ALL(x,opt_6)),...
    LB,UB,params);

optAll{1} = opt_1;
optAll{2} = opt_2;
optAll{3} = opt_3;
optAll{4} = opt_4;
optAll{5} = opt_5;
optAll{6} = opt_6;

yAll{1} = y_1;
yAll{2} = y_2;
yAll{3} = y_3;
yAll{4} = y_4;
yAll{5} = y_5;
yAll{6} = y_6;

save(filname,'chains','optAll','yAll','LB','UB','x0','burnin','njumps','params','thrIncl')

end

