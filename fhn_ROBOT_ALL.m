function dydt=fhn_ROBOT_ALL(t,y,opt)
 
drugPressure_A  = opt.drugPressure_A;
drugPressure_B  = opt.drugPressure_B;
drugPressure_AB = opt.drugPressure_AB;
optionCommunity = opt.optionCommunity;
 
dydt = 0*y;
 
% Populations
U  = y(1);
WT = y(2);
A  = y(3);
B  = y(4);
AB = y(5);
 
% drug pressure variables

[~,i] = min(abs(opt.tint-t));
fA  = drugPressure_A(i);
fB  = drugPressure_B(i);
fAB = drugPressure_AB(i);
 
if(optionCommunity==0) % FULLY SENS COMMUNITY
    mS  = 0.8510638;
    mU  = 0.1489362;
    mA  = 0;
    mB  = 0;
    mAB = 0;
elseif(optionCommunity==1) % SINGLE RES COMMUNITY
    mS  = 0.5744681;
    mU  = 0.2127660;
    mA  = 0.1063830;
    mB  = 0.1063830;
    mAB = 0;
else % SINGLE AND DOUBLE RES COMMUNITY
    mS  = 0.5212766;
    mU  = 0.2127660;
    mA  = 0.1063830;
    mB  = 0.1063830;
    mAB = 0.0531915;
end
% FIXED PARAMETERS
mu      = 0.2;
beta    = 0.3;
% ESTIMATED PARAMETERS
nuA   = opt.nuA; 
nuB   = opt.nuB;
nuAB  = opt.nuAB;
nuAAB = opt.nuAAB;
nuBAB = opt.nuBAB;
tauA  = opt.tauA;
tauB  = opt.tauB;
tauAB = opt.tauAB;
cA    = opt.cA;
cB    = opt.cB;
cAB   = opt.cAB;   
 
if((fA+fB+fAB)==0)%%%%%%%%% NO TREATMENT %%%%%%%%%%%
    %%%%%%%%% U %%%%%%%%%%
dydt(1)  = +mU*mu - mu*U + (fA*tauA+fB*tauB+fAB*tauAB)*mS*mu + tauA*(fA+fAB)*mB*mu + tauB*(fB+fAB)*mA*mu ... %turnover + immigration
    + 0 ... %mutation
    + (fA*tauA+fB*tauB+fAB*tauAB)*WT ...%clearance
    + tauB*(fB+fAB)*A ...%clearance
    + tauA*(fA+fAB)*B ... %clearance
    - beta*WT*U ...%infection %     - beta*WT*U ...%infection
    - beta*A*U ...%infection
    - beta*B*U ...%infection
    - beta*AB*U ... %infection
    + 0; %superinfection
 
%%%%%%%%% WT (S) %%%%%%%%%%
dydt(2)  = + (1-(fA*tauA+fB*tauB+fAB*tauAB))*mS*mu - mu*WT ... %turnover + immigration
    - fA*nuA*WT ...%mutation
    - fB*nuB*WT ...%mutation
    - fAB*nuAB*WT ... % mutation
    - (fA*tauA+fB*tauB+fAB*tauAB)*WT ... %clearance
    + beta*WT*U ... %infection %
    - beta*(1-cA)*WT*A ... %superinfection
    - beta*(1-cB)*WT*B ... %superinfection
    - beta*(1-cAB)*WT*AB; %superinfection
 
%%%%%%%%% A %%%%%%%%%%
dydt(3)  = + (1-tauB*(fB+fAB))*mA*mu - mu*A ...%turnover + immigration
    + fA*nuA*WT ...%mutation
    - (fB+fAB)*nuAAB*A ... %mutation
    - tauB*(fB+fAB)*A ...%clearance
    + beta*A*U ... %infection %
    - beta*(1-cAB)*A*AB ... %superinfection
    - beta*(1-cB)*A*B ... %superinfection
    + beta*(1-cA)*B*A ... %superinfection
    + beta*(1-cA)*WT*A; %superinfection
 
%%%%%%%%% B %%%%%%%%%%
dydt(4)  = + (1-tauA*(fA+fAB))*mB*mu - mu*B ...%turnover + immigration
    + fB*nuB*WT ...%mutation
    - (fA+fAB)*nuBAB*B ... %mutation
    - tauA*(fA+fAB)*B ...%clearance
    + beta*B*U ... %infection 
    - beta*(1-cAB)*B*AB ...%superinfection
    - beta*(1-cA)*B*A ...%superinfection
    + beta*(1-cB)*A*B ...%superinfection
    + beta*(1-cB)*WT*B;%superinfection
 
%%%%%%%%% AB %%%%%%%%%%
dydt(5)  = mAB*mu - mu*AB...%turnover + immigration
    + fAB*nuAB*WT... % mutation
    + (fA+fAB)*nuBAB*B ... %mutation
    + (fB+fAB)*nuAAB*A ... %mutation
    - 0 ...%clearance
    + beta*AB*U... %infection
    + beta*(1-cAB)*A*AB ... %superinfection
    + beta*(1-cAB)*B*AB ... %superinfection
    + beta*(1-cAB)*WT*AB; %superinfection
    
else%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TREATMENT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%% U %%%%%%%%%%
dydt(1)  = +mU*mu - mu*U + (fA*tauA+fB*tauB+fAB*tauAB)*mS*mu + tauA*(fA+fAB)*mB*mu + tauB*(fB+fAB)*mA*mu ... %turnover + immigration
    + 0 ... %mutation
    + (fA*tauA+fB*tauB+fAB*tauAB)*WT ...%clearance
    + tauB*(fB+fAB)*A ...%clearance
    + tauA*(fA+fAB)*B ... %clearance
    - beta*(1-(fA+fB+fAB))*WT*U ... %infection 
    - beta*(1-cA)*fA*A*U ... %infection
    - beta*(1-cB)*fB*B*U ...%infection
    - beta*(1-cAB)*(fA+fB+fAB)*AB*U ... %infection
    + 0; %superinfection
 
%%%%%%%%% WT (S) %%%%%%%%%%
dydt(2)  = + (1-(fA*tauA+fB*tauB+fAB*tauAB))*mS*mu - mu*WT ... %turnover + immigration
    - fA*nuA*WT ...%mutation
    - fB*nuB*WT ...%mutation
    - fAB*nuAB*WT ... % mutation
    - (fA*tauA+fB*tauB+fAB*tauAB)*WT ... %clearance
    + beta*(1-(fA+fB+fAB))*WT*U ... %infection %   
    - beta*(1-cA)*(fA*WT)*A ... %superinfection
    - beta*(1-cB)*(fB*WT)*B ... %superinfection
    - beta*(1-cAB)*((fA+fB+fAB)*WT)*AB; %superinfection
 
%%%%%%%%% A %%%%%%%%%%
dydt(3)  = + (1-tauB*(fB+fAB))*mA*mu - mu*A ...%turnover + immigration
    + fA*nuA*WT ...%mutation
    - (fB+fAB)*nuAAB*A ... %mutation
    - tauB*(fB+fAB)*A ...%clearance
    + beta*(1-cA)*fA*A*U ... %infection
    - beta*(1-cAB)*((fB+fAB)*A)*AB ... %superinfection
    - beta*(1-cB)*(fB*A)*B ... %superinfection
    + beta*(1-cA)*(fA*B)*A ... %superinfection
    + beta*(1-cA)*(fA*WT)*A; %superinfection
 
%%%%%%%%% B %%%%%%%%%%
dydt(4)  = + (1-tauA*(fA+fAB))*mB*mu - mu*B ...%turnover + immigration
    + fB*nuB*WT ...%mutation
    - (fA+fAB)*nuBAB*B ... %mutation
    - tauA*(fA+fAB)*B ...%clearance
    + beta*(1-cB)*fB*B*U ... %infection 
    - beta*(1-cAB)*((fA+fAB)*B)*AB ...%superinfection
    - beta*(1-cA)*(fA*B)*A ...%superinfection
    + beta*(1-cB)*(fB*A)*B ...%superinfection
    + beta*(1-cB)*(fB*WT)*B;%superinfection
 
%%%%%%%%% AB %%%%%%%%%%
dydt(5)  = mAB*mu - mu*AB...%turnover + immigration
    + fAB*nuAB*WT... % mutation
    + (fA+fAB)*nuBAB*B ... %mutation
    + (fB+fAB)*nuAAB*A ... %mutation
    - 0 ...%clearance
    + beta*(1-cAB)*(fA+fB+fAB)*AB*U... %infection
    + beta*(1-cAB)*((fB+fAB)*A)*AB ... %superinfection
    + beta*(1-cAB)*((fA+fAB)*B)*AB ... %superinfection
    + beta*(1-cAB)*((fA+fB+fAB)*WT)*AB; %superinfection
end
end
 
 

