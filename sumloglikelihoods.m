function [out] = sumloglikelihoods(y,s)
N   = length(y);
out = -N/2*log((SSQ(y,s))); %maximum likelihood estimation
end

