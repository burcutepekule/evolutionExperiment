function chains = mh_SIMUL(varargin)

[kernel,sig,y_1,y_2,y_3,y_4,y_5,y_6,x0,genfunc_1,genfunc_2,genfunc_3,genfunc_4,genfunc_5,genfunc_6,LB,UB,params]=parseinputargs(varargin,nargin);

thrIncl       = params.thrIncl;
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
    s_1=genfunc_1(x0); % system response to initial guess
    s_2=genfunc_2(x0); % system response to initial guess
    s_3=genfunc_3(x0); % system response to initial guess
    s_4=genfunc_4(x0); % system response to initial guess
    s_5=genfunc_5(x0); % system response to initial guess
    s_6=genfunc_6(x0); % system response to initial guess
    % Depending on which therapies to include...
    yAll = [];
    sAll = [];
    for i=1:length(thrIncl)
        thrIdx = thrIncl(i);
        fhTemp = str2func(['genfunc_' num2str(i)]);
        yAll   = [yAll; eval(genvarname(['y_' num2str(thrIdx)]))];
        sAll   = [sAll; eval(genvarname(['s_' num2str(thrIdx)]))];
    end
    N             = length(yAll); % number of data points x dimension of data
    [N size(yAll) size(sAll)]
    loglikelihood = sumloglikelihoods(yAll,sAll);
    kernels        = unifpdf(p(varIndx_bound),LB(varIndx_bound),UB(varIndx_bound));
    logkernel      = sum(log(kernels));
    e             = loglikelihood+logkernel;
    acc   = zeros(1,length(p));
    rej   = zeros(1,length(p));
    keepp = zeros(params.njumps,length(p));
    prop  = ones(1,length(p)); %proposal distribution
    for i=1:params.njumps+params.burnin
        prog = 100*i/(params.njumps+params.burnin);
        if(floor(prog)==prog)
            X = ['Processing SIMUL : ' num2str(prog),'%'];
            disp(X)
        end
        for k=1:length(p)
            oldp=p;
            % here transition model is gaussian
            % Q(theta' | theta) = N(theta,std) (here std is zero)
            % if I want a uniform transition model -> p(k) should just be
            % sampled from a uniform distribution
            if(kernel==1)
                if(ismember(k,fixIdxs))
                    p(k) = LB(k);
                else
                    p(k) = p(k)+sig(k)*randn*prop(k); %Gaussian
                end
            elseif(kernel==0)
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
                % generate the dynamical system response
                s_0=genfunc_1(p); % system response to initial guess
                s_2=genfunc_2(p); % system response to initial guess
                s_3=genfunc_3(p); % system response to initial guess
                s_4=genfunc_4(p); % system response to initial guess
                s_5=genfunc_5(p); % system response to initial guess
                s_6=genfunc_6(p); % system response to initial guess
                
                sAll = [];
                for ii=1:length(thrIncl)
                    thrIdx = thrIncl(ii);
                    fhTemp = str2func(['genfunc_' num2str(ii)]);
                    sAll   = [sAll; eval(genvarname(['s_' num2str(thrIdx)]))];
                end
                olde          = e;
                loglikelihood = sumloglikelihoods(yAll,sAll);
                kernels        = unifpdf(p(varIndx_bound),LB(varIndx_bound),UB(varIndx_bound));
                logkernel      = sum(log(kernels));
                e             = loglikelihood+logkernel;
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

function [kernel,sig,y_1,y_2,y_3,y_4,y_5,y_6,x0,genfunc_1,genfunc_2,genfunc_3,genfunc_4,genfunc_5,genfunc_6,LB,UB,params]=parseinputargs(varargin,nargin)
kernel=varargin{1};
sig  =varargin{2};
y_1  =varargin{3};
y_2  =varargin{4};
y_3  =varargin{5};
y_4  =varargin{6};
y_5  =varargin{7};
y_6  =varargin{8};
x0   =varargin{9};
genfunc_1 =varargin{10};
genfunc_2 =varargin{11};
genfunc_3 =varargin{12};
genfunc_4 =varargin{13};
genfunc_5 =varargin{14};
genfunc_6 =varargin{15};

if(nargin>15);LB=varargin{16};else LB=-inf*ones(size(x0));end
if(nargin>16);UB=varargin{17};else UB=+inf*ones(size(x0));end
if(nargin>17);
    params=varargin{18};
else
    params=struct('burnin',1000,'njumps',5000,'nchains',100,'sampleevery',10,'update',20);
end
if(~isfield(params,'burnin'));params.burnin=1000;end
if(~isfield(params,'njumps'));params.njumps=5000;end
if(~isfield(params,'nchains'));params.nchains=100;end
if(~isfield(params,'sampleevery'));params.sampleevery=10;end
if(~isfield(params,'update'));params.update=20;end





