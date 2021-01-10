%% Set Parameters
I0 = .001; % Initial proportion of infected.
a = 1; % Coefficient in weak^-1

tmax = 10; % Number of weeks
dt = 0.01; % Size of time step in weeks
Imax = 1; % Max number infected for graph

plotchoice = 3; % 1=S, 2=I, 3=All

%% Initialize Vectors
t = 0:dt:tmax; % Time vector
Nt = length(t); % Number of time steps
I = zeros(1,Nt); % Infection vector
S = zeros(1,Nt);
I(1) = I0; % Set initial infection value

%% Calculations
for it = 1:Nt-1
    S(it) = 1 - I(it);
    dI = a*I(it) * S(it); % Rate of change per week;
    I(it+1) = I(it) + dI * dt; 
end
S(Nt) = 1 -I(Nt);

%% Plots
switch plotchoice
    case 1
        plot(t,S,'-b','LineWidth',2)
        axis([0 tmax 0 Imax])
        grid on
        grid minor
        xlabel('Times (weeks)')
        ylabel('Proportion Infected')
        title('Proportion of infections vs. Time')
        
    case 2
        plot(t,I,'-r','LineWidth',2)
        axis([0 tmax 0 Imax])
        grid on
        grid minor
        xlabel('Times (weeks)')
        ylabel('Proportion Infected')
        title('Proportion of infections vs. Time')
        
    case 3
        plot(t,I,'-r',...
             t,S,'-b','LineWidth',2)
        axis([0 tmax 0 Imax])
        grid on
        grid minor
        xlabel('Times (weeks)')
        ylabel('Proportion of S and I')
        title('Proportion of S and I vs. Time')
        
end