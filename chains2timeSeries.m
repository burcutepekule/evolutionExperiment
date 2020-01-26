function [] = chains2timeSeries(njumps,nchains,commIdx,estTypeIdx)
close all;clc;
figureTitles = {'NO TREATMENT','MONO A','MONO B','COMBINATION','CYCLING','MIXING'};
figureNames  = {'NO_TREATMENT.png','MONO_A.png','MONO_B.png','COMBINATION.png','CYCLING.png','MIXING.png'};
if(estTypeIdx==0)
    estType       = 'INDP';
    thrInclStrVec = {'1','2','3','4','5','6'};
    for t=1:length(thrInclStrVec)
        thrInclStr     = thrInclStrVec{t};
        chainsDirec    = ['./SIMULATION_RESULTS/EXP_' num2str(commIdx) '/NJUMPS_' num2str(njumps) '_NCHAINS_' num2str(nchains) '_' estType '/CHAINS'];
        predsDirec     = ['./SIMULATION_RESULTS/EXP_' num2str(commIdx) '/NJUMPS_' num2str(njumps) '_NCHAINS_' num2str(nchains) '_' estType '/TIMESERIES'];
        filname        = [predsDirec '/MCMC_' estType '_thr_' thrInclStr '.mat'];
        if ~exist(predsDirec, 'dir')
            mkdir(predsDirec)
        end
        posteriors = [];
        for chainIndex=1:nchains
            load([chainsDirec '/MCMC_' estType '_chain_' num2str(chainIndex) '_thr_' thrInclStr '.mat'])
            singleChain = cell2mat(chains);
            NN          = size(singleChain,1);
            singleChain = singleChain(NN/2+1:end,:);
            posteriors  = [posteriors;singleChain];
        end
        predTemp   = fhngen_ROBOT_ALL(median(posteriors),opt);
        pred       = reshape(predTemp,opt.tint(end),5);
        save(filname,'posteriors','pred','opt','y','LB','UB','x0','burnin','njumps')
        f = figure('visible','off');
        plot(pred,'linewidth',2)
        grid on;
        legend('U','WT','A','B','AB')
        xlabel('Transfer Index','FontSize',18)
        ylabel('Frequency','FontSize',18)
        title(figureTitles{t})
        saveas(f,string([predsDirec '/' estType '_' figureNames{t}]))
    end
elseif(estTypeIdx==1)
    estType       = 'SIMUL';
    thrInclStr    = '1_2_3_4_5_6';
    chainsDirec    = ['./SIMULATION_RESULTS/EXP_' num2str(commIdx) '/NJUMPS_' num2str(njumps) '_NCHAINS_' num2str(nchains) '_' estType '/CHAINS'];
    predsDirec     = ['./SIMULATION_RESULTS/EXP_' num2str(commIdx) '/NJUMPS_' num2str(njumps) '_NCHAINS_' num2str(nchains) '_' estType '/TIMESERIES'];
    filname        = [predsDirec '/MCMC_' estType '_thr_' thrInclStr '.mat'];
    if ~exist(predsDirec, 'dir')
        mkdir(predsDirec)
    end
    for t=1:6
        posteriors = [];
        for chainIndex=1:nchains
            load([chainsDirec '/MCMC_' estType '_chain_' num2str(chainIndex) '_thr_' thrInclStr '.mat'])
            singleChain = cell2mat(chains);
            NN          = size(singleChain,1);
            singleChain = singleChain(NN/2+1:end,:);
            posteriors  = [posteriors;singleChain];
        end
        opt        = optAll{t};
        predTemp   = fhngen_ROBOT_ALL(median(posteriors),opt);
        pred       = reshape(predTemp,opt.tint(end),5);
        save(filname,'posteriors','pred','opt','yAll','LB','UB','x0','burnin','njumps')
        f = figure('visible','off');
        plot(pred,'linewidth',2)
        grid on;
        legend('U','WT','A','B','AB')
        xlabel('Transfer Index','FontSize',18)
        ylabel('Frequency','FontSize',18)
        title(figureTitles{t})
        saveas(f,string([predsDirec '/' estType '_' figureNames{t}]))
    end
end
end

