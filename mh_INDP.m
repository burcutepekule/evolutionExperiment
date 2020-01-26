function chains = mh_INDP(varargin)

[prior,sig,y,x0,genfunc,LB,UB,params]=parseinputargs(varargin,nargin);

therapy       = params.therapy;
diffBounds    = UB-LB;
fixIdxs       = find(~diffBounds); %Indexes of parameters that should be fixed to a certain
% number because LB=UB (use it to fixate variables to constants)
varIdxs       = find(diffBounds); %Indexes to sample from MCMC MH
varIndx_bound = find(diffBounds);

chains = [];

for ch=1:params.nchains
    %%%%% INITIAL GUESS SHOULD BE DIFFERENT FOR EACH CHAIN %%%%%
    x0 = unifrnd(LB,UB); % initial guess
    p  = x0;
    s  = genfunc(x0); % system response to initial guess
    N  = length(y); % number of data points x dimension of data
    [N size(y) size(s)]
    loglikelihood = sumloglikelihoods(y,s);
    priors        = unifpdf(p(varIndx_bound),LB(varIndx_bound),UB(varIndx_bound));
    logprior      = sum(log(priors));
    e             = loglikelihood+logprior;
    
    acc   = zeros(1,length(p));
    rej   = zeros(1,length(p));
    keepp = zeros(params.njumps,length(p));
    prop  = ones(1,length(p)); %proposal distribution
    thrps = {'NO TREATMENT','MONO A','MONO B','COMBINATION','CYCLING','MIXING'};
    for i=1:params.njumps+params.burnin
        prog = 100*i/(params.njumps+params.burnin);
        if(floor(prog)==prog)
            X = ['Processing ' thrps{therapy} ': ' num2str(prog),'%'];
            disp(X)
        end
        for k=1:length(p)
            oldp=p;
            % here transition model is gaussian
            % Q(theta' | theta) = N(theta,std) (here std is zero)
            % if I want a uniform transition model -> p(k) should just be
            % sampled from a uniform distribution
            if(prior==1)
                if(ismember(k,fixIdxs))
                    p(k) = LB(k);
                else
                    p(k) = p(k)+sig(k)*randn*prop(k); %Gaussian
                end
            elseif(prior==0)
                if(ismember(k,fixIdxs))
                    p(k) = LB(k);
                else
                    %              p(k) = (LB(k) + (UB(k)-LB(k)).*rand)*prop(k); %Uniform -> Calisiyo ama az sample icin?
                    a = -(UB(k)-LB(k));
                    b = +(UB(k)-LB(k));
                    r = a+(b-a).*rand;
                    p(k) = p(k)+r*prop(k);
                end
            end
            if(p(k)<LB(k) || p(k)>UB(k))
                p(k)=oldp(k);
                rej(k)=rej(k)+1;
            else %if the newly proposed parameter set is within margins
                s             = genfunc(p); % generate the dynamical system response
                olde          = e;
                loglikelihood = sumloglikelihoods(y,s);
                priors        = unifpdf(p(varIndx_bound),LB(varIndx_bound),UB(varIndx_bound));
                logprior      = sum(log(priors));
                e             = loglikelihood+logprior;
                if(ismember(k,fixIdxs))
                    acc(k)=acc(k)+1; %accept all the samples from that distribution
                else
                    if(exp(e-olde)>rand)
                        acc(k)=acc(k)+1;
                    else
                        p(k)=oldp(k);
                        rej(k)=rej(k)+1;
                        e=olde;
                    end
                end
            end
        end
        keepp(i,:)=p;
        if(rem(i,params.update)==0)
            prop(varIdxs)=prop(varIdxs).*sqrt((1+acc(varIdxs))./(1+rej(varIdxs)));
            acc=0*acc;
            rej=0*rej;
        end
    end
    samples=keepp(params.burnin+1:params.sampleevery:end,:);
    chains{ch}=samples;
end

function [prior,sig,y,x0,genfunc,LB,UB,params]=parseinputargs(varargin,nargin)
prior=varargin{1};
sig=varargin{2};
y=varargin{3};
x0=varargin{4};
genfunc=varargin{5};
if(nargin>5);LB=varargin{6};else LB=-inf*ones(size(x0));end
if(nargin>6);UB=varargin{7};else UB=+inf*ones(size(x0));end
if(nargin>7);
    params=varargin{8};
else
    params=struct('burnin',1000,'njumps',5000,'nchains',100,'sampleevery',10,'update',20);
end
if(~isfield(params,'burnin'));params.burnin=1000;end
if(~isfield(params,'njumps'));params.njumps=5000;end
if(~isfield(params,'nchains'));params.nchains=100;end
if(~isfield(params,'sampleevery'));params.sampleevery=10;end
if(~isfield(params,'update'));params.update=20;end





