classdef app < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                 matlab.ui.Figure
        GridLayout               matlab.ui.container.GridLayout
        LeftPanel                matlab.ui.container.Panel
        RightPanel               matlab.ui.container.Panel
        TabGroup                 matlab.ui.container.TabGroup
        DataAnalysisPlotTab      matlab.ui.container.Tab
        PlotDropDownLabel        matlab.ui.control.Label
        PlotDropDown             matlab.ui.control.DropDown
        SIRDPlotTab              matlab.ui.container.Tab
        PlotDropDown_2Label      matlab.ui.control.Label
        PlotDropDown_2           matlab.ui.control.DropDown
        I_naughtSpinnerLabel     matlab.ui.control.Label
        I_naughtSpinner          matlab.ui.control.Spinner
        YearDurationSliderLabel  matlab.ui.control.Label
        YearDurationSlider       matlab.ui.control.Slider
        PLOTButton               matlab.ui.control.Button
        CALCULATEButton          matlab.ui.control.Button
        UIAxes                   matlab.ui.control.UIAxes
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
        plotchoice      % choice for our plot
        tmax            % duration of plot
        a_list          % rate of S -> I
        b_list          % rate of I -> R
        c_list          % rate of I -> D
        infect_list
        recover_list
        death_list
        S
        I
        I0
        R
        D
        t
        maxWeek
    end
    
    methods (Access = private)
        
        % CALCULATE SIRD SIMULATION
        function calc(app)
            % Adjust vector size to timescale
            dt = 0.01;
            app.t = 0:dt:app.tmax; % Time vector
            Nt = length(app.t); % Number of time steps
            app.S = zeros(1,Nt); % Suspectable vector
            app.I = zeros(1,Nt); % Infection vector
            app.R = zeros(1,Nt); % Recovered vector
            app.D = zeros(1,Nt); % Death vector
            
            app.I(1) = app.I0; % Set initial infection value
            
            % Calculation
            for it = 1:Nt-1
                a = randn*(2.5e-3) + mean(app.a_list);          % Gaussian Distribution (miu = mean(a_list), sigma = 2.5e-3)
                b = rand/5;                                     % Uniform Distribution from 0 to 0.2
                c = -log(rand) * mean(app.c_list);              % Exponential Distribution (miu = mean(c_list))
                
                % S-RATE
                app.S(it) = 100 - app.I(it) - app.R(it) - app.D(it); 
                
                % I-RATE
                dI = a*app.I(it)*app.S(it) - b*app.I(it) - c*app.I(it);
                app.I(it+1) = app.I(it) + dI*dt;
                
                % R-RATE
                dR = b*app.I(it);
                app.R(it+1) = app.R(it) + dR*dt;
                
                % D-RATE
                dD = c*app.I(it);
                app.D(it+1) = app.D(it) + dD*dt;
            end
            
            app.S(Nt) = app.S(Nt-1); % Final value adjustment
        end
        
        % PLOTTING FUNCTION
        function plotGraph(app)
            switch app.plotchoice
                case '1'
                    plot(app.UIAxes, app.t, app.S,'-k','LineWidth',2);
                    axis(app.UIAxes, [0 app.tmax 0 max(app.S)]);
                    xlabel(app.UIAxes, 'Week');
                    ylabel(app.UIAxes, 'Suspectable (%)');
                    title (app.UIAxes, 'Percentage of suspectable vs. Time');
                    legend(app.UIAxes, 'off');
            
                case '2'
                    plot(app.UIAxes, app.t, app.I,'-r','LineWidth',2);
                    axis(app.UIAxes, [0 app.tmax 0 max(app.I)]);
                    xlabel(app.UIAxes, 'Times (weeks)');
                    ylabel(app.UIAxes, 'Proportion infected');
                    title (app.UIAxes, 'Proportion of infections vs. Time');
                    legend(app.UIAxes, 'off');
                    
                case '3'
                    plot(app.UIAxes, app.t, app.R,'-b','LineWidth',2);
                    axis(app.UIAxes, [0 app.tmax 0 max(app.R)]);
                    xlabel(app.UIAxes, 'Times (weeks)');
                    ylabel(app.UIAxes, 'Proportion recovered');
                    title (app.UIAxes, 'Proportion of recovered vs. Time');
                    legend(app.UIAxes, 'off');
                    
                case '4'
                    plot(app.UIAxes, app.t, app.D,'-m','LineWidth',2);
                    axis(app.UIAxes, [0 app.tmax 0 max(app.D)]);
                    xlabel(app.UIAxes, 'Times (weeks)');
                    ylabel(app.UIAxes, 'Proportion of death');
                    title (app.UIAxes, 'Proportion of death vs. Time');
                    legend(app.UIAxes, 'off');
                    
                case '5'
                    plot(app.UIAxes, ...
                         app.t,app.S,'-k',...
                         app.t,app.I,'-r',...
                         app.t,app.R,'-b',...
                         app.t,app.D,'-m','LineWidth',2);
                    axis(app.UIAxes, [0 app.tmax 0 max(app.S)]);
                    xlabel(app.UIAxes, 'Times (weeks)');
                    ylabel(app.UIAxes, 'Proportion of SIRD');
                    title (app.UIAxes, 'Proportion of SIRD vs. Time');
                    legend(app.UIAxes, ...
                           'S','I','R','D',...
                           'Location','East');
                       
                 case '6'
                    plot(app.UIAxes, ...
                         app.t,app.I,'-r',...
                         app.t,app.R,'-b',...
                         app.t,app.D,'-m','LineWidth',2);
                    axis(app.UIAxes, [0 app.tmax 0 max(app.R)]);
                    xlabel(app.UIAxes, 'Times (weeks)');
                    ylabel(app.UIAxes, 'Proportion of IRD');
                    title (app.UIAxes, 'Proportion of IRD vs. Time');
                    legend(app.UIAxes, ...
                           'I','R','D',...
                           'Location','East');
                case '10'
                    plot(app.UIAxes, ...
                         1:app.maxWeek,app.infect_list,'-r',...
                         1:app.maxWeek,app.recover_list,'-b',...
                         1:app.maxWeek,app.death_list,'-m','LineWidth',2);
                    xlabel(app.UIAxes, 'Weeks of data');
                    ylabel(app.UIAxes, 'Value of data');
                    title (app.UIAxes, 'Weekly value of IRD');
                    legend(app.UIAxes, 'Infected','Recovered','Death',...
                           'Location','East');
                       
                case '11'
                    plot(app.UIAxes, 1:app.maxWeek,app.infect_list,'-r','LineWidth',2);
                    xlabel(app.UIAxes, 'Weeks of data');
                    ylabel(app.UIAxes, 'Value of infected');
                    title (app.UIAxes, 'Infected weekly value');
                    legend(app.UIAxes, 'off');
                    
                case '12'
                    plot(app.UIAxes, 1:app.maxWeek,app.recover_list,'-b','LineWidth',2);
                    xlabel(app.UIAxes, 'Weeks of data');
                    ylabel(app.UIAxes, 'Value of recovered');
                    title (app.UIAxes, 'Recovered weekly value');
                    legend(app.UIAxes, 'off');
                    
                case '13'
                    plot(app.UIAxes, 1:app.maxWeek,app.death_list,'-m','LineWidth',2);
                    xlabel(app.UIAxes, 'Weeks of data');
                    ylabel(app.UIAxes, 'Value of death');
                    title (app.UIAxes, 'Death weekly value');
                    legend(app.UIAxes, 'off');
                    
                    
                case '20'
                    plot(app.UIAxes, ...
                         1:app.maxWeek,app.a_list,'-b',...
                         1:app.maxWeek,app.b_list,'-g',...
                         1:app.maxWeek,app.c_list,'-r','LineWidth',2);
                    
                    xlabel(app.UIAxes, 'Week');
                    ylabel(app.UIAxes, 'Constants values');
                    title (app.UIAxes, 'Variation of a,b,c values over weeks');
                    legend(app.UIAxes, 'a-value','b-value','c-value',...
                           'Location','East');
                       
                case '21'
                    plot(app.UIAxes, ...
                         1:app.maxWeek, mean(app.a_list)*ones(app.maxWeek), '-k',...
                         1:app.maxWeek, app.a_list,'-b','LineWidth',2);
                    xlabel(app.UIAxes, 'Week');
                    ylabel(app.UIAxes, 'Values of a');
                    title (app.UIAxes, 'Varying values of a over weeks');
                    legend(app.UIAxes, 'off');
                    
                case '22'
                    plot(app.UIAxes, ...
                         1:app.maxWeek, mean(app.b_list)*ones(app.maxWeek), '-k',...
                         1:app.maxWeek, app.b_list,'-g','LineWidth',2);
                    xlabel(app.UIAxes, 'Week');
                    ylabel(app.UIAxes, 'Value of b');
                    title (app.UIAxes, 'Varying values of b over weeks');
                    legend(app.UIAxes, 'off');
                    
                 case '23'
                    plot(app.UIAxes, ...
                         1:app.maxWeek, mean(app.c_list)*ones(app.maxWeek), '-k',...
                         1:app.maxWeek, app.c_list,'-r','LineWidth',2);
                    xlabel(app.UIAxes, 'Week');
                    ylabel(app.UIAxes, 'Values of c');
                    title (app.UIAxes, 'Varying values of c over weeks');
                    legend(app.UIAxes, 'off');
                 
            end
        end
        
        
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            % Values initialisation
            app.I0 = 1;
            app.tmax = 52;
            app.plotchoice = '10';
            
            % Vectors initialisation
            data = readmatrix("resources/covid_data.csv");
            [row,~] = size(data);
            app.maxWeek = row/7;
            
            app.infect_list     = zeros(1,app.maxWeek);
            app.recover_list    = zeros(1,app.maxWeek);
            app.death_list      = zeros(1,app.maxWeek);
            
            app.a_list          = zeros(1,app.maxWeek);
            app.b_list          = zeros(1,app.maxWeek);
            app.c_list          = zeros(1,app.maxWeek);
            
            % Fetch data from .csv
            for i = 1:app.maxWeek
                app.infect_list(i)  = sum(data(1+(i-1)*7:7*i , 3));
                app.recover_list(i) = sum(data(1+(i-1)*7:7*i , 4));
                app.death_list(i)   = sum(data(1+(i-1)*7:7*i , 5));
                
                app.a_list(i)       = app.infect_list(i)  / data(i*7,7);
                app.b_list(i)       = app.recover_list(i) / data(i*7,6);
                app.c_list(i)       = app.death_list(i)   / data(i*7,6);
            end
        end

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.UIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 2x1 grid
                app.GridLayout.RowHeight = {729, 729};
                app.GridLayout.ColumnWidth = {'1x'};
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 1;
            else
                % Change to a 1x2 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {12, '1x'};
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 2;
            end
        end

        % Button pushed function: PLOTButton
        function PLOTButtonPushed(app, event)
            app.plotchoice
            plotGraph(app);
        end

        % Button pushed function: CALCULATEButton
        function CALCULATEButtonPushed(app, event)
            calc(app);
        end

        % Value changed function: YearDurationSlider
        function YearDurationSliderValueChanged(app, event)
            year = app.YearDurationSlider.Value;
            app.tmax = year*52;
        end

        % Value changed function: PlotDropDown
        function PlotDropDownValueChanged(app, event)
            app.plotchoice = app.PlotDropDown.Value;
        end

        % Value changed function: PlotDropDown_2
        function PlotDropDown_2ValueChanged(app, event)
            app.plotchoice = app.PlotDropDown_2.Value;
        end
        
        % Value changed function: I_naughtSpinner
        function I_naughtSpinnerValueChanged(app, event)
            app.I0 = app.I_naughtSpinner.Value;
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 1073 729];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {12, '1x'};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.BackgroundColor = [0.502 0.502 0.502];
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.ForegroundColor = [1 1 1];
            app.RightPanel.BackgroundColor = [0.651 0.651 0.651];
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 2;

            % Create TabGroup
            app.TabGroup = uitabgroup(app.RightPanel);
            app.TabGroup.TabLocation = 'bottom';
            app.TabGroup.Position = [360 25 405 103];

            % Create DataAnalysisPlotTab
            app.DataAnalysisPlotTab = uitab(app.TabGroup);
            app.DataAnalysisPlotTab.Title = 'Data Analysis Plot';
            app.DataAnalysisPlotTab.BackgroundColor = [0.8 0.8 0.8];

            % Create PlotDropDownLabel
            app.PlotDropDownLabel = uilabel(app.DataAnalysisPlotTab);
            app.PlotDropDownLabel.BackgroundColor = [0.8 0.8 0.8];
            app.PlotDropDownLabel.HorizontalAlignment = 'right';
            app.PlotDropDownLabel.FontSize = 20;
            app.PlotDropDownLabel.FontColor = [0.149 0.149 0.149];
            app.PlotDropDownLabel.Position = [82 31 40 24];
            app.PlotDropDownLabel.Text = 'Plot';

            % Create PlotDropDown
            app.PlotDropDown = uidropdown(app.DataAnalysisPlotTab);
            app.PlotDropDown.Items = {'Weekly Data', 'Weekly Infected', 'Weekly Recovered', 'Weekly Death', 'Constants', 'a values', 'b values', 'c values', ''};
            app.PlotDropDown.ItemsData = {'10', '11', '12', '13', '20', '21', '22', '23'};
            app.PlotDropDown.ValueChangedFcn = createCallbackFcn(app, @PlotDropDownValueChanged, true);
            app.PlotDropDown.FontSize = 20;
            app.PlotDropDown.FontColor = [0.149 0.149 0.149];
            app.PlotDropDown.BackgroundColor = [1 1 1];
            app.PlotDropDown.Position = [137 30 176 25];
            app.PlotDropDown.Value = '10';

            % Create SIRDPlotTab
            app.SIRDPlotTab = uitab(app.TabGroup);
            app.SIRDPlotTab.Title = 'SIRD Plot';
            app.SIRDPlotTab.BackgroundColor = [0.8 0.8 0.8];

            % Create PlotDropDown_2Label
            app.PlotDropDown_2Label = uilabel(app.SIRDPlotTab);
            app.PlotDropDown_2Label.HorizontalAlignment = 'right';
            app.PlotDropDown_2Label.FontSize = 20;
            app.PlotDropDown_2Label.FontColor = [1 1 1];
            app.PlotDropDown_2Label.Position = [28 24 41 31];
            app.PlotDropDown_2Label.Text = 'Plot';

            % Create PlotDropDown_2
            app.PlotDropDown_2 = uidropdown(app.SIRDPlotTab);
            app.PlotDropDown_2.Items = {'S', 'I', 'R', 'D', 'SIRD', 'IRD', ''};
            app.PlotDropDown_2.ItemsData = {'1', '2', '3', '4', '5', '6'};
            app.PlotDropDown_2.ValueChangedFcn = createCallbackFcn(app, @PlotDropDown_2ValueChanged, true);
            app.PlotDropDown_2.FontSize = 20;
            app.PlotDropDown_2.FontColor = [0.149 0.149 0.149];
            app.PlotDropDown_2.Position = [84 30 97 25];
            app.PlotDropDown_2.Value = '1';

            % Create I_naughtSpinnerLabel
            app.I_naughtSpinnerLabel = uilabel(app.SIRDPlotTab);
            app.I_naughtSpinnerLabel.HorizontalAlignment = 'right';
            app.I_naughtSpinnerLabel.FontSize = 20;
            app.I_naughtSpinnerLabel.FontColor = [0.149 0.149 0.149];
            app.I_naughtSpinnerLabel.Position = [234 33 83 24];
            app.I_naughtSpinnerLabel.Text = 'I_naught';

            % Create I_naughtSpinner
            app.I_naughtSpinner = uispinner(app.SIRDPlotTab);
            app.I_naughtSpinner.Limits = [0 50];
            app.I_naughtSpinner.ValueChangedFcn = createCallbackFcn(app, @I_naughtSpinnerValueChanged, true);
            app.I_naughtSpinner.FontSize = 20;
            app.I_naughtSpinner.FontColor = [0.149 0.149 0.149];
            app.I_naughtSpinner.Position = [327 33 43 25];
            app.I_naughtSpinner.Value = 1;

            % Create YearDurationSliderLabel
            app.YearDurationSliderLabel = uilabel(app.RightPanel);
            app.YearDurationSliderLabel.HorizontalAlignment = 'center';
            app.YearDurationSliderLabel.FontSize = 16;
            app.YearDurationSliderLabel.Position = [129 90 77 36];
            app.YearDurationSliderLabel.Text = {'Year'; '(Duration)'};

            % Create YearDurationSlider
            app.YearDurationSlider = uislider(app.RightPanel);
            app.YearDurationSlider.Limits = [1 6];
            app.YearDurationSlider.MajorTicks = [1 2 3 4 5 6];
            app.YearDurationSlider.MajorTickLabels = {'1', '2', '3', '4', '5', '6'};
            app.YearDurationSlider.ValueChangedFcn = createCallbackFcn(app, @YearDurationSliderValueChanged, true);
            app.YearDurationSlider.MinorTicks = [];
            app.YearDurationSlider.FontSize = 14;
            app.YearDurationSlider.FontWeight = 'bold';
            app.YearDurationSlider.Position = [52 65 230 3];
            app.YearDurationSlider.Value = 1;

            % Create PLOTButton
            app.PLOTButton = uibutton(app.RightPanel, 'push');
            app.PLOTButton.ButtonPushedFcn = createCallbackFcn(app, @PLOTButtonPushed, true);
            app.PLOTButton.BackgroundColor = [0.149 0.149 0.149];
            app.PLOTButton.FontSize = 40;
            app.PLOTButton.FontWeight = 'bold';
            app.PLOTButton.FontColor = [0.902 0.902 0.902];
            app.PLOTButton.Position = [820 25 197 66];
            app.PLOTButton.Text = 'PLOT';

            % Create CALCULATEButton
            app.CALCULATEButton = uibutton(app.RightPanel, 'push');
            app.CALCULATEButton.ButtonPushedFcn = createCallbackFcn(app, @CALCULATEButtonPushed, true);
            app.CALCULATEButton.BackgroundColor = [0.149 0.149 0.149];
            app.CALCULATEButton.FontSize = 18;
            app.CALCULATEButton.FontWeight = 'bold';
            app.CALCULATEButton.FontColor = [0.902 0.902 0.902];
            app.CALCULATEButton.Position = [820 97 197 36];
            app.CALCULATEButton.Text = 'CALCULATE';

            % Create UIAxes
            app.UIAxes = uiaxes(app.RightPanel);
            title(app.UIAxes, 'Title')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.XColor = [0 0 0];
            app.UIAxes.YColor = [0 0 0];
            app.UIAxes.XGrid = 'on';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.FontSize = 20;
            app.UIAxes.GridColor = [0 0 0];
            app.UIAxes.Position = [13 144 1025 565];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end