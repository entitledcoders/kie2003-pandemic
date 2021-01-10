
%% Set Parameters
I0 = .01; % Initial proportion of infected.

a_mean = 0.4; % Infection Coefficient in weak^-1
b_mean = 0.5; % Rate E to I Coeficient
c_mean = 0.1; % Recovery Coeficient
d_mean = 0.01; % Death Coeficient

tmax = 52; % Number of weeks
dt = 0.01; % Size of time step in weeks
Imax = 1.1; % Max number infected for graph

plotchoice = 4; % 1=S, 2=I, 3=R, 4=All

%% Initialize Vectors
t = 0:dt:tmax; % Time vector
Nt = length(t); % Number of time steps
S = zeros(1,Nt);
E = zeros(1,Nt);
I = zeros(1,Nt); % Infection vector
R = zeros(1,Nt);
D = zeros(1,Nt);

I(1) = I0; % Set initial infection value

%% Calculations
for it = 1:Nt-1
    a = infection_rate(a_mean);
    b = infection_rate(b_mean);
    c = infection_rate(c_mean);
    d = infection_rate(d_mean);

    
    S(it) = 1 - E(it)- I(it) - R(it) - D(it); 
    
    dE = a*I(it)*S(it) - b*E(it);
    E(it+1) = E(it) + dE*dt;
    
    dI = b*E(it) - c*I(it) - d*I(it);
    I(it+1) = I(it) + dI*dt;
    
    dR = c*I(it);
    R(it+1) = R(it) + dR*dt;
    
    dD = d*I(it);
    D(it+1) = D(it) + dD*dt;
end
S(Nt) = S(Nt-1);

%% Plots
switch plotchoice
    case 1
        plot(t,S,'-k','LineWidth',2)
        axis([0 tmax 0 Imax])
        grid on
        grid minor
        xlabel('Times (weeks)')
        ylabel('Proportion Suspectable')
        title('Proportion of suspectable vs. Time')
        
    case 2
        plot(t,I,'-r','LineWidth',2)
        axis([0 tmax 0 Imax])
        grid on
        grid minor
        xlabel('Times (weeks)')
        ylabel('Proportion Infected')
        title('Proportion of infections vs. Time')
        
    case 3
        plot(t,R,'-b','LineWidth',2)
        axis([0 tmax 0 Imax])
        grid on
        grid minor
        xlabel('Times (weeks)')
        ylabel('Proportion Removed')
        title('Proportion of removed vs. Time')
        
    case 4
        plot(t,S,'-k',...
             t,E,'-c',...
             t,I,'-r',...
             t,R,'-b',...
             t,D,'-m','LineWidth',2)
        axis([0 tmax 0 Imax])
        grid on
        grid minor
        xlabel('Times (weeks)')
        ylabel('Proportion of S, I and R')
        title('Proportion of S, I and R vs. Time')
        legend('S','E','I','R','D',...
               'Location','East')
        
end