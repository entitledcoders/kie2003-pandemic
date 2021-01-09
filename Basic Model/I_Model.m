%% Set Parameters
I0 = 10; % Initial number of infected.
a = 1.5; % Coefficient in weak^-1

tmax = 10; % Number of weeks
dt = 0.01; % Size of time step in weeks
Imax = 5e4; % Max number infected for graph

%% Initialize Vectors
t = 0:dt:tmax; % Time vector
Nt = length(t); % Number of time steps
I = zeros(1,Nt); % Infection vector
I(1) = I0; % Set initial infection value

%% Calculations
for it = 1:Nt-1
    dI = a*I(it); % Rate of change per week;
    I(it+1) = I(it) + dI * dt; 
end

%% Plots
plot(t, I, '-b', 'LineWidth', 2)
axis([0 tmax 0 Imax])
grid on
grid minor
xlabel('Times (weeks)')
ylabel('Number Infected')
title('Number of infections vs. Time')