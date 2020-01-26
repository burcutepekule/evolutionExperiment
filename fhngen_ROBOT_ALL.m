function y=fhngen_ROBOT_ALL(x,opt)
opt.nuA   = x(1);
opt.nuB   = x(2);
opt.nuAB  = x(3);
opt.nuAAB = x(4);
opt.nuBAB = x(5);
opt.tauA  = x(6);
opt.tauB  = x(7);
opt.tauAB = x(8);
opt.cA    = x(9);
opt.cB    = x(10);
opt.cAB   = x(11);

odeopt = odeset('Nonnegative',5);
sol    = ode15s(@(t,x)(fhn_ROBOT_ALL(t,x,opt)),opt.tspan,opt.y0,odeopt);

y = deval(sol,opt.tint);
y = y';

y=y(:);

