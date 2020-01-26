function [] = RUN_MCMC_ALL_INDP_PARALLEL(readDataDirec,commIdx,therapy,offset,LB,UB,x0,burnin,sampleevery,njumps,prior,sig,filname,options)
offset = offset+1; %start from data point n+1, which is transfer n.
if(therapy==1)
    load([readDataDirec 'EXP_' num2str(commIdx) '_NO_TREATMENT' ])
elseif(therapy==2)
    load([readDataDirec 'EXP_' num2str(commIdx) '_MONO_A' ])
elseif(therapy==3)
    load([readDataDirec 'EXP_' num2str(commIdx) '_MONO_B' ])
elseif(therapy==4)
    load([readDataDirec 'EXP_' num2str(commIdx) '_COMBINATION' ])
elseif(therapy==5)
    load([readDataDirec 'EXP_' num2str(commIdx) '_CYCLING' ])
elseif(therapy==6)
    load([readDataDirec 'EXP_' num2str(commIdx) '_MIXING' ])
end
y          = dataExp(:);
y0         = dataExp(1,:)';
T          = size(dataExp,1); % total duration
nt         = size(dataExp,1); % number of time points to simulate
[drugPressure_A,drugPressure_B,drugPressure_AB] = setDrugPressure(therapy,offset,T); %SET THE DRUG PRESSURE VECTOR GIVEN THE TREATMENT
opt.tspan=[1 T];             % interval of the simulation
opt.tint=linspace(1,T,nt)';  % all time points
opt.y0=y0;
opt.drugPressure_A  = drugPressure_A;
opt.drugPressure_B  = drugPressure_B;
opt.drugPressure_AB = drugPressure_AB;
opt.optionCommunity = commIdx;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

params.burnin =burnin;    % #iterations before sampling starts
params.njumps =njumps;    % #sampling iterations
params.nchains=1;   % #chains -> because parallel
params.sampleevery=sampleevery;     % #thinning of the chain
params.therapy=therapy;

chains  =mh_INDP(prior,sig,y,x0,@(x)(fhngen_ROBOT_ALL(x,opt)),LB,UB,params);
save(filname,'chains','opt','y','LB','UB','x0','burnin','njumps','params')

end

