%% Set Parameters
I0 = .01; % Initial proportion of infected.
a = 1.0; % Infection Coefficient in weak^-1
b = 0.5; % Removal Coeficient

tmax = 52; % Number of weeks
dt = 0.01; % Size of time step in weeks
Imax = 1.1; % Max number infected for graph

plotchoice = 4; % 1=S, 2=I, 3=R, 4=All

%% Initialize Vectors
t = 0:dt:tmax; % Time vector
Nt = length(t); % Number of time steps
I = zeros(1,Nt); % Infection vector
S = zeros(1,Nt);
R = zeros(1,Nt);
I(1) = I0; % Set initial infection value

%% Calculations
for it = 1:Nt-1
    S(it) = 1 - I(it) - R(it);
    dI = a*I(it) * S(it) - b*I(it); % Rate of change per week;
    I(it+1) = I(it) + dI * dt;
    dR = b*I(it);
    R(it+1) = R(it) + dR * dt;
end
S(Nt) = 1 - I(Nt) - R(Nt);

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
             t,I,'-r',...
             t,R,'-b','LineWidth',2)
        axis([0 tmax 0 Imax])
        grid on
        grid minor
        xlabel('Times (weeks)')
        ylabel('Proportion of S, I and R')
        title('Proportion of S, I and R vs. Time')
        legend('Suspectable','Infected','Removed',...
               'Location','East')
        
end