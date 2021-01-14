
%% Set Parameters
I0 = .01; % Initial proportion of infected.

% a_mean = 0.5; % Infection Rate in weak^-1  ( )
% b_mean = 0.1; % Recovery Coeficient in weak^-1    ( )
% c_mean = 0.01; % Death Coeficient in weak^-1      ( )

year = 1;
tmax = 52*year; % Number of weeks
dt = 0.01; % Size of time step in weeks

plotchoice = 5; 
% 1=S | 2=I | 3=R | 4=D | 5=SIRD

%% Initialize Vectors
t = 0:dt:tmax; % Time vector
Nt = length(t); % Number of time steps
S = zeros(1,Nt); % Suspectable vector
I = zeros(1,Nt); % Infection vector
R = zeros(1,Nt); % Recovered vector
D = zeros(1,Nt); % Death vector

I(1) = I0; % Set initial infection value

%% Calculations
for it = 1:Nt-1
%     a = infection_rate(a_list);
%     b = recovery_rate()
%     c = death_rate(mean(c_list))
%     
%     S(it) = 1 - I(it) - R(it) - D(it); 
%     
%     dI = a*I(it)*S(it) - b*I(it) - c*I(it);
%     I(it+1) = I(it) + dI*dt;
%     
%     dR = b*I(it);
%     R(it+1) = R(it) + dR*dt;
%     
%     dD = c*I(it);
%     D(it+1) = D(it) + dD*dt;
end
S(Nt) = S(Nt-1);

%% Plots
switch plotchoice
    case 1
        plot(t,S,'-k','LineWidth',2)
        axis([0 tmax 0 max(S)])
        grid on
        grid minor
        xlabel('Times (weeks)')
        ylabel('Proportion suspectable')
        title('Proportion of suspectable vs. Time')

    case 2
        plot(t,I,'-r','LineWidth',2)
        axis([0 tmax 0 max(I)])
        grid on
        grid minor
        xlabel('Times (weeks)')
        ylabel('Proportion infected')
        title('Proportion of infections vs. Time')
        
    case 3
        plot(t,R,'-b','LineWidth',2)
        axis([0 tmax 0 max(R)])
        grid on
        grid minor
        xlabel('Times (weeks)')
        ylabel('Proportion recovered')
        title('Proportion of recovered vs. Time')
        
    case 4
        plot(t,D,'-m','LineWidth',2)
        axis([0 tmax 0 max(D)])
        grid on
        grid minor
        xlabel('Times (weeks)')
        ylabel('Proportion of death')
        title('Proportion of death vs. Time')
        
    case 5
        plot(t,S,'-k',...
             t,I,'-r',...
             t,R,'-b',...
             t,D,'-m','LineWidth',2)
        axis([0 tmax 0 1])
        grid on
        grid minor
        xlabel('Times (weeks)')
        ylabel('Proportion of SIRD')
        title('Proportion of SIRD vs. Time')
        legend('S','I','R','D',...
               'Location','East')
end