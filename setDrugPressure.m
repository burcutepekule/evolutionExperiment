function [drugPressure_A,drugPressure_B,drugPressure_AB] = setDrugPressure(therapyIdx,offset,T)
drugPressure_A=[];
drugPressure_B=[];
drugPressure_AB=[];
if(therapyIdx==1) %NO TREATMENT
    drugPressure_A  = zeros(T,1);
    drugPressure_B  = zeros(T,1);
    drugPressure_AB = zeros(T,1);
elseif(therapyIdx==2) %MONO_A
    if (offset==1)
        drugPressure_A  = [0;ones(T-1,1)];
        drugPressure_B  = zeros(T,1);
        drugPressure_AB = zeros(T,1);
    else
        drugPressure_A  = ones(T,1);
        drugPressure_B  = zeros(T,1);
        drugPressure_AB = zeros(T,1);
    end
elseif(therapyIdx==3)%MONO_B
    if (offset==1)
        drugPressure_A  = zeros(T,1);
        drugPressure_B  = [0;ones(T-1,1)];
        drugPressure_AB = zeros(T,1);
    else
        drugPressure_A  = zeros(T,1);
        drugPressure_B  = ones(T,1);
        drugPressure_AB = zeros(T,1);
    end
elseif(therapyIdx==4)%COMBO
    if (offset==1)
        drugPressure_A  = zeros(T,1);
        drugPressure_B  = zeros(T,1);
        drugPressure_AB = [0;ones(T-1,1)];
    else
        drugPressure_A  = zeros(T,1);
        drugPressure_B  = zeros(T,1);
        drugPressure_AB = ones(T,1);
    end
elseif(therapyIdx==5) %CYC
    colA = [1;1;0;0]; colB = [0;0;1;1];
    if (offset==1)
        remDiv = rem((T-1),4);
        repDiv = floor((T-1)/4);
        drugPressure_A  = [0;repmat(colA,repDiv,1);colA(1:remDiv)];
        drugPressure_B  = [0;repmat(colB,repDiv,1);colB(1:remDiv)];
        drugPressure_AB = zeros(T,1);
    else
        remDiv = rem(T,4);
        repDiv = floor(T/4);
        drugPressure_A  = [repmat(colA,repDiv,1);colA(1:remDiv)];
        drugPressure_B  = [repmat(colB,repDiv,1);colB(1:remDiv)];
        drugPressure_AB = zeros(T,1);
    end
elseif(therapyIdx==6) %MIX
    if (offset==1)
        drugPressure_A  = [0;0.5*ones(T-1,1)];
        drugPressure_B  = [0;0.5*ones(T-1,1)];
        drugPressure_AB = zeros(T,1);
    else
        drugPressure_A  = 0.5*ones(T,1);
        drugPressure_B  = 0.5*ones(T,1);
        drugPressure_AB = zeros(T,1);
    end
end
end

