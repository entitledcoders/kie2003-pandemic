%% Set Parameters
data = readmatrix("resources/covid_data.csv");
[row,column] = size(data);
maxWeek = row/7;

infect_list = zeros(1,maxWeek);
recover_list = zeros(1,maxWeek);
death_list = zeros(1,maxWeek);

a_list = zeros(1,maxWeek);
b_list = zeros(1,maxWeek);
c_list = zeros(1,maxWeek);

plotchoice = 23;
% 10=Data plot | 11=infect_list  | 12= recover_list | 13=_list
% 20=List plot | 21= a_list      | 22= b_list       | 23=c_list

%% Data analysis
for i = 1:maxWeek
    infect_list(i) = sum(data(1+(i-1)*7:7*i , 3));
    recover_list(i) = sum(data(1+(i-1)*7:7*i , 4));
    death_list(i) = sum(data(1+(i-1)*7:7*i , 5));
    
    a_list(i) = infect_list(i) / data(i*7,7);
    b_list(i) = recover_list(i) / data(i*7,6);
    c_list(i) = death_list(i) / data(i*7,6);
end

%% Plots
switch plotchoice
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
        plot(1:maxWeek,infect_list,'-r','LineWidth',2)
        grid on
        grid minor
        xlabel('Weeks of data')
        ylabel('Value of infected')
        title('Infected weekly value')
        
    case 12
        plot(1:maxWeek,recover_list,'-b','LineWidth',2)
        grid on
        grid minor
        xlabel('Weeks of data')
        ylabel('Value of recovered')
        title('Recovered weekly value')
        
    case 13
        plot(1:maxWeek,death_list,'-m','LineWidth',2)
        grid on
        grid minor
        xlabel('Weeks of data')
        ylabel('Value of death')
        title('Death weekly value')
        
        
    case 20
        plot(1:maxWeek,a_list,'-b',...
             1:maxWeek,b_list,'-g',...
             1:maxWeek,c_list,'-r','LineWidth',2)
        grid on
        grid minor
        xlabel('Weeks of data')
        ylabel('Value of list')
        title('Weekly value of list')
        legend('a-list','b-list','c-list',...
               'Location','East')
           
    case 21
        plot(1:maxWeek, mean(a_list)*ones(maxWeek), '-k',...
             1:maxWeek,a_list,'-b','LineWidth',2)
        grid on
        grid minor
        xlabel('Weeks of data')
        ylabel('Value of a-list')
        title('a-list')
        
    case 22
        plot(1:maxWeek, mean(b_list)*ones(maxWeek), '-k',...
             1:maxWeek,b_list,'-g','LineWidth',2)
        grid on
        grid minor
        xlabel('Weeks of data')
        ylabel('Value of b-list')
        title('b-list')
        
     case 23
        plot(1:maxWeek, mean(c_list)*ones(maxWeek), '-k',...
             1:maxWeek,c_list,'-r','LineWidth',2)
        grid on
        grid minor
        xlabel('Weeks of data')
        ylabel('Value of c-list')
        title('c-list')
        
end