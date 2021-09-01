
%--------------------------------------------------------------------------
%                              Visualization.m
% 
% Description: 
%    Class that visualizes (plots and animates) the T-Handle 
%
% Properties: 
%    tHandle    The T-Handle to be animated 
%    output       The current output (used for defining output path) 
%
%--------------------------------------------------------------------------

classdef Visualization
    
    properties 
        tHandle; 
        output; 
    end
    
    methods
        function obj = Visualization(tHandle, output)
            obj.tHandle = tHandle; 
            obj.output = output; 
            
            % Creates output folder for figures  
            path = [pwd, '/figures/', output, '/f_components']; 
            if ~isfolder(path)
                mkdir(path); 
            end
            
            % Creates output folder for animations  
            path = [pwd, '/animations/', output, '/']; 
            if ~isfolder(path)
                mkdir(path); 
            end
        end
        
        % Plots all the X-components in a grid 
        function plotX(obj, t, X)
            path = [pwd, '/figures/', obj.output, '/']; 
            
            for i = 1:9
                
                % The x component 
                Xc = cellfun(@(x) x(i), X);
                
                % Creates plot for the x-component 
                f = figure('visible', 'off');
                plot(t, Xc, 'LineWidth', 3);
                xlim([0, t(end)]); ylim([-1, 1]);
                xlabel('Time (t)'); ylabel(['X', num2str(i)]); 
                
                % Saves plot as png 
                print([path, 'f_components/F', num2str(i)], '-dpng');
                
                close(f); 
            end

            % Creates image collage from each plot
            image = [imread([path, 'f_components/F1.png']) imread([path, 'f_components/F2.png']) imread([path, 'f_components/F3.png']); ...
                     imread([path, 'f_components/F4.png']) imread([path, 'f_components/F5.png']) imread([path, 'f_components/F6.png']); ...
                     imread([path, 'f_components/F7.png']) imread([path, 'f_components/F8.png']) imread([path, 'f_components/F9.png'])]; 

            imwrite(image, [path, 'F.png']); % Saves image
        end
        
        % Plots the step-size diagram 
        function plotH(obj, t, h)
            path = [pwd, '/figures/', obj.output, '/']; 
            
            f = figure('visible', 'off');
            plot(t, h, 'LineWidth', 3);
            xlim([0, t(end - 1)]); 
            xlabel('Time (t)'); ylabel('Step size'); 
                
            % Saves plot as .epsc 
            print([path, 'h'], '-depsc');
                
            close(f); 
        end
        
        % Plots the step-size diagram 
        function plotHX(obj, t, h, X, c)
            path = [pwd, '/figures/', obj.output, '/']; 
            
            % The x component 
            Xc = cellfun(@(x) x(c), X);
            
            f = figure('visible', 'off');
            
            xlim([0, t(end)]);
            xlabel('Time (t)'); 
            
            % Plots Xc
            yyaxis left   
            plot(t, Xc, 'LineWidth', 3);
            ylabel(['X', num2str(c)]); 
            
            % Plots h  
            yyaxis right 
            plot(t, h, 'LineWidth', 3); 
            ylabel('Step Length');
                
            % Saves plot as .epsc 
            print([path, 'HX', num2str(c)], '-depsc');
                
            close(f); 
        end
        
        % Plots the energy diagram 
        function plotEnergy(obj, t, energy)
            path = [pwd, '/figures/', obj.output, '/']; 
            
            f = figure('visible', 'off');
            plot(t, energy, 'LineWidth', 3);
            xlim([0, t(end)]); 
            xlabel('Time (t)'); ylabel('Energy'); 
                
            % Saves plot as .epsc 
            print([path, 'Energy'], '-depsc');
                
            close(f); 
        end
        
        % Plots the error diagram 
        function plotError(obj, t, E)
            path = [pwd, '/figures/', obj.output, '/']; 
            
            f = figure('visible', 'off');
            plot(t, E, 'LineWidth', 3, 'Color', '#d44700');
            xlim([0, t(end)]); 
            xlabel('Time (t)'); ylabel('Error'); 
                
            % Saves plot as .epsc 
            print([path, 'Error'], '-depsc');
                
            close(f); 
        end
        
        % Plots the X-Error diagram 
        function plotErrorX(obj, t, X, c, E)
            path = [pwd, '/figures/', obj.output, '/']; 
            
            % Calculates the x component 
            Xc = cellfun(@(x) x(c), X);
            
            f = figure('visible', 'off');
            
            xlim([0, t(end)]);
            xlabel('Time (t)'); 
            
            % Plots Xc
            yyaxis left   
            plot(t, Xc, 'LineWidth', 3);
            ylabel(['X', num2str(c)]); 
            
            % Plots error 
            yyaxis right 
            plot(t, E, 'LineWidth', 3); 
            ylabel('Error');
                
            % Saves plot as .epsc 
            print([path, 'ErrorX1'], '-depsc');
                
            close(f); 
        end
        
        % Plots the Energy-Error diagram 
        function plotErrorEnergy(obj, t, energy, E, c)
            path = [pwd, '/figures/', obj.output, '/']; 
            
            f = figure('visible', 'off');
            
            hold on 
            
            plot(t, energy, 'LineWidth', 3);
            plot(t, (E * c) + energy(1), 'LineWidth', 3); 
            
            xlim([0, t(end)]);
            xlabel('Time (t)'); 
            ylabel('Error / Energy'); 
            
            hold off 
                
            % Saves plot as .epsc 
            print([path, 'ErrorEnergy'], '-depsc');
                
            close(f); 
        end
        
        % Plots the accumulative error diagram 
        function plotAccumulativeError(obj, t, E)
            path = [pwd, '/figures/', obj.output, '/']; 
            
            % Calculates accumulative error 
            for i = 2:length(E)
                E(i) = E(i) + E(i-1); 
            end
            
            f = figure('visible', 'off');
            plot(t, E, 'LineWidth', 3, 'Color', '#d44700');
            xlim([0, t(end)]); 
            xlabel('Time (t)'); ylabel('Accumulative Error'); 
                
            % Saves plot as .epsc 
            print([path, 'AccumulativeError'], '-depsc');
                
            close(f); 
        end
        
        % Plots the accumulative error diagram 
        function plotAccumulativeErrorX(obj, t, X, c, E)
            path = [pwd, '/figures/', obj.output, '/']; 
            
            % The x component 
            Xc = cellfun(@(x) x(c), X);
            
            % Calculates accumulative error 
            for i = 2:length(E)
                E(i) = E(i) + E(i-1); 
            end
            
            f = figure('visible', 'off');
     
            xlim([0, t(end)]);
            xlabel('Time (t)'); 
            
            % Plots Xc
            yyaxis left   
            plot(t, Xc, 'LineWidth', 3);
            ylabel(['X', num2str(c)]); 
            
            % Plots accumulative error 
            yyaxis right 
            plot(t, E, 'LineWidth', 3); 
            ylabel('Accumulative Error'); 
                
            % Saves plot as .epsc 
            print([path, 'AccumulativeErrorX1'], '-depsc');
                
            close(f); 
        end
        
        % Plots the accumulative error diagram 
        function plotAccumulativeErrorEnergy(obj, t, energy, E, c)
            path = [pwd, '/figures/', obj.output, '/']; 
            
            % Calculates accumulative error 
            E(1) = E(1); 
            for i = 2:length(E)
                E(i) = E(i) + E(i-1); 
            end
            
            E = E * c; 
            E = E + energy(1); 
            
            f = figure('visible', 'off');
            
            % Plots energy 
            hold on
            xlim([0, t(end)]);
            xlabel('Time (t)'); 
            ylabel('Energy/Accumulative Error'); 
            
            plot(t, energy, 'LineWidth', 3);
            plot(t, E, 'LineWidth', 3); 
            
            box on
            hold off 
                
            % Saves plot as .epsc 
            print([path, 'AccumulativeErrorEnergy'], '-depsc');
                
            close(f); 
        end
        
        % Animates the spinning T-Handle 
        function animateTHandle(obj, X, h)
            path = [pwd, '/animations/', obj.output]; 
            
            % Length of cylinders
            L1 = obj.tHandle.L1; 
            L2 = obj.tHandle.L2; 
            
            % Used for indexing    
            x = 1; y = 2; z = 3;
            
            % Point A 
            A = [ -1    % x
                   0    % y
                   0 ]; % z
            
            % Pre-allocation for speed
            B = cell(1, length(X)); 
            C = cell(1, length(X)); 
            D = cell(1, length(X)); 
            
            % Updates points B, C and D in relation to X 
            for i = 1:length(X)
                e1 = X{i}(:, 1);
                e2 = X{i}(:, 2);
                e3 = X{i}(:, 3);

                B{i} = A + L1/2 * e2; 
                C{i} = A - L1/2 * e2; 
                D{i} = L2 * e1; 
            end

            % Sets up figure window 
            figure('visible', 'off'); 
            plot3(0, 0, 0);

            xlabel('X (cm)'); 
            ylabel('Y (cm)'); 
            zlabel('Z (cm)'); 

            axis equal; 
            
            xlim(L1*[-1, 1]); 
            ylim(L1*[-1, 1]);
            zlim(L2*[-1, 1]);
            
            grid on; 

            % Draws the T-Handle 
            AD = line('xdata', [A(x), D{1}(x)],    'ydata', [A(y), D{1}(y)],    'zdata', [A(z), D{1}(z)],    'color', 'k', 'linewidth', 5);
            BC = line('xdata', [B{1}(x), C{1}(x)], 'ydata', [B{1}(y), C{1}(y)], 'zdata', [B{1}(z), C{1}(z)], 'color', 'k', 'linewidth', 5);
            
            % Starts animation 
            animation = VideoWriter([path, '/THandle'], 'MPEG-4');
            animation.FrameRate = 1/h;       
            open(animation);

            n = 0; 
            for i = 1:length(X)
                
                % Redraws T-Handle in new orientation 
                set(AD, 'xdata', [A(x), D{i}(x)],    'ydata', [A(y), D{i}(y)],    'zdata', [A(z), D{i}(z)]);
                set(BC, 'xdata', [B{i}(x), C{i}(x)], 'ydata', [B{i}(y), C{i}(y)], 'zdata', [B{i}(z), C{i}(z)]);
                
                % Writes frame to video 
                writeVideo(animation, getframe(gcf)); 
            end
            
            % Stops animation 
            close(animation); 
        end
    end
end