
%% Set Parameters
I0 = .01; % Initial proportion of infected.

% a_mean = 0.5; % Infection Rate in weak^-1  ( )
% b_mean = 0.1; % Recovery Coeficient in weak^-1    ( )
% c_mean = 0.01; % Death Coeficient in weak^-1      ( )

year = 1;
tmax = 52*year; % Number of weeks
dt = 0.01; % Size of time step in weeks

plotchoice = 20; 
% 1=S | 2=I | 3=R | 4=D | 5=SIRD
% 10=Data plot | 11=death_list
% 20=List plot | 21= c_list | 22= b_list

%% Data analysis
data = readmatrix("covid_data.csv");
[row,column] = size(data);
maxWeek = row/7;

infect_list = zeros(1,maxWeek);
recover_list = zeros(1,maxWeek);
death_list = zeros(1,maxWeek);

a_list = zeros(1,maxWeek);
b_list = zeros(1,maxWeek);
c_list = zeros(1,maxWeek);

for i = 1:maxWeek
    infect_list(i) = sum(data(1+(i-1)*7:7*i , 2));
    recover_list(i) = sum(data(1+(i-1)*7:7*i , 3));
    death_list(i) = sum(data(1+(i-1)*7:7*i , 4));
    
    b_list(i) = recover_list(i) / data(i*7,5);
    c_list(i) = death_list(i) / data(i*7,5);
end

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
    a = infection_rate(a_list);
    b = recovery_rate(b_list);
    c = death_rate(c_list);
    
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
           
    case 10
        plot(1:maxWeek,infect_list,'-r',...
             1:maxWeek,recover_list,'-b',...
             1:maxWeek,death_list,'-m','LineWidth',2)
        grid on
        grid minor
        xlabel('Weeks of data')
        ylabel('Value of data')
        title('Weekly value of IRD')
        legend('Infected','Recovered','Death',...
               'Location','East')
           
    case 11
        plot(1:maxWeek, mean(death_list)*ones(maxWeek), '-r',...
             1:maxWeek,death_list,'-b','LineWidth',2)
        grid on
        grid minor
        xlabel('Weeks of data')
        ylabel('Value of death')
        title('Death value')
        
    case 20
        plot(1:maxWeek,b_list,'-r',...
             1:maxWeek,c_list,'-m','LineWidth',2)
        grid on
        grid minor
        xlabel('Weeks of data')
        ylabel('Value of list')
        title('Weekly value of list')
        legend('b-list','c-list',...
               'Location','East')
           
    case 21
        plot(1:maxWeek, mean(c_list)*ones(maxWeek), '-r',...
             1:maxWeek,c_list,'-m','LineWidth',2)
        grid on
        grid minor
        xlabel('Weeks of data')
        ylabel('Value of c-list')
        title('c-list')
        
    case 22
        plot(1:maxWeek, mean(b_list)*ones(maxWeek), '-b',...
             1:maxWeek,b_list,'-r','LineWidth',2)
        grid on
        grid minor
        xlabel('Weeks of data')
        ylabel('Value of b-list')
        title('b-list')
        
end