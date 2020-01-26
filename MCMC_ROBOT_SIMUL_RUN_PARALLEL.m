function [] = MCMC_ROBOT_SIMUL_RUN_PARALLEL(njumps,numchains,chainIdx,commIdx)
set(0,'defaultAxesFontSize',22)
rng(chainIdx+1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
LB         = [0 0 0 0 0 0 0 0 0 0 0];  %LOWERBOUNDS FOR SAMPLING nuA nuB nuAB nuAAB nuBAB tauA tauB tauAB cA cB cAB 
UB         = [1 1 1 1 1 1 1 1 1 1 1];  %UPPERBOUNDS FOR SAMPLING nuA nuB nuAB nuAAB nuBAB tauA tauB tauAB cA cB cAB 
x0         = (UB+LB)./2;
sig        = (UB-LB)./6; % 3 sigma rule
offset     = 1; % start from transfer 1, not 0.
prior      = 1; % 0 -> Uniform , 1 -> Gauissian
% burnin      = floor(njumps*0.25);
% sampleevery = 10;
% TO SEE ALL THE VALUES IN THE CHAIN %
burnin      = 0;
sampleevery = 1;
% therapies to include : here we include all, one can knock out certain
% datasets for self-experimenting 
thrIncl     = [1 2 3 4 5 6]; 
%%%%%%%%%%%%%%%% DIRECTORIES %%%%%%%%%%%%%%%%%%%%%%
readDataDirec  = './EXPERIMENTAL_DATA/';
saveDataDirec  = ['./SIMULATION_RESULTS/EXP_' num2str(commIdx) '/'];
foldernameData = [saveDataDirec 'NJUMPS_' num2str(njumps) '_NCHAINS_' num2str(numchains) '_SIMUL/CHAINS/'];
mkdir(foldernameData)
filname   = [foldernameData '/MCMC_SIMUL_chain_' num2str(chainIdx) '_thr'];
for i=1:length(thrIncl)
    filname = [filname '_' num2str(thrIncl(i))];
end
RUN_MCMC_ALL_SIMUL_PARALLEL(readDataDirec,commIdx,thrIncl,offset,LB,UB,x0,burnin,sampleevery,njumps,prior,sig,filname);

end

