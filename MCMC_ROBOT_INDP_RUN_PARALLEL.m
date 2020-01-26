function [] = MCMC_ROBOT_INDP_RUN_PARALLEL(njumps,numchains,chainIdx,commIdx)
set(0,'defaultAxesFontSize',22)
rng(chainIdx+1) %RANDOMIZE THE SEED
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
%%%%%%%%%%%%%%%% DIRECTORIES %%%%%%%%%%%%%%%%%%%%%%
readDataDirec  = './EXPERIMENTAL_DATA/';
saveDataDirec  = ['./SIMULATION_RESULTS/EXP_' num2str(commIdx) '/'];
foldernameData = [saveDataDirec 'NJUMPS_' num2str(njumps) '_NCHAINS_' num2str(numchains) '_INDP/CHAINS/'];
mkdir(foldernameData)
for therapy=1:6 %1->NO TREATMENT, 2->MONO_A, 3->MONO_B, 4->COMBO, 5->CYC, 6->MIX
    filname   = [foldernameData '/MCMC_INDP_chain_' num2str(chainIdx) '_thr_' num2str(therapy)];
    RUN_MCMC_ALL_INDP_PARALLEL(readDataDirec,commIdx,therapy,offset,LB,UB,x0,burnin,sampleevery,njumps,prior,sig,filname)
end

end

