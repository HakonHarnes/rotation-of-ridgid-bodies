
%--------------------------------------------------------------------------
%                                 RKF45.m
% 
% Description: 
%    Class for Runge-Kutta-Fehlberg method 
%
% Properties: 
%    h      Step size 
%    tEnd   When to stop (tEnd = step size * number of iterations)
%    TOL    Tolerance 
%
% Properties (Constant): 
%    A                  First part of the Butcher tableau
%    B                  Second part of the Butcher tableau
%    MAX_ITERATIONS     Maximum iterations for dividing step size in two
%
% Remark: 
%   Here, tEnd is used as a stopping criteria, as opposed to the number of
%   iterations. The reason for this is that for RK4, the step size is
%   constant, so t(end) will always be h*n. However, in RKf45, h varies.
%   This means that t(end) might be smaller or bigger than h*n. This makes
%   comparing RK4 and RKF45 difficult. By stopping when t(end) = tEnd
%   (h*n), we ensure that RK4 and RKF45 simulate the spinning T-Handle for
%   the exact same amount of seconds. 
%
%   Also note that the variables are not pre-allocated, as we do not know
%   how big they will eventually be. 
%
%--------------------------------------------------------------------------

classdef RKF45
    
    properties
       h;
       tEnd; 
       TOL;
    end
    
    properties(Constant)
       A = [ 0              0            0           0           0      0
             1/4            0            0           0           0      0
             3/32          9/32          0           0           0      0
             1932/2197  -7200/2197   7296/2197       0           0      0
             439/216       -8        3680/513    -845/4104       0      0
             -8/27          2       -3544/2565    1859/4104   -11/40    0  ]; 
         
       B = [ 25/216         0        1408/2565    2197/4104    -1/5     0
             16/135         0        6656/12825   28561/56430  -9/50  2/55 ];  
         
       MAX_ITERATIONS = 10; 
    end
        
    methods
        function obj = RKF45(h, n, TOL)
            obj.h = h; 
            obj.tEnd = h*n; 
            obj.TOL = TOL; 
        end
        
        % Calculates the approximate solution 
        function [t, W, E, h] = solve(obj, X0, I, L)
            
            % Initializes variables 
            W{1} = X0; 
            t(1) = 0; 
            E(1) = 0; 
            h(1) = obj.h; 
            
            i = 1; 
            while(t(i) < obj.tEnd)
                
                % Calculates the approximate solution  
                [t(i+1), W{i+1}, E(i+1)] = obj.step(t(i), W{i}, I, L);  
                iterations = 0; 
                
                % Checks if the error is tolerable 
                if(E(i+1) > obj.TOL)
                    obj = obj.adjustStep(E(i+1));
                    [t(i+1), W{i+1}, E(i+1)] = obj.step(t(i), W{i}, I, L);         
                end
                
                % Checks if the error is tolelerable now 
                while(E(i+1) > obj.TOL)
                    
                    % Divides step size in two
                    obj.h = obj.h / 2; 
                    
                    % Recalculates the approximation 
                    [t(i+1), W{i+1}, E(i+1)] = obj.step(t(i), W{i}, I, L);         
                    
                    % Checks if max iterations is exceeded 
                    iterations = iterations + 1; 
                    if(iterations > obj.MAX_ITERATIONS)
                        error('MAX ITERATIONS EXCEEDED')
                    end
                end
                
                % Forces the last t-value to be tEnd 
                if(t(i+1) > obj.tEnd)
                    obj.h = obj.tEnd - t(i); 
                    [t(i+1), W{i+1}, E(i+1)] = obj.step(t(i), W{i}, I, L);  
                end
                
                h(i+1) = obj.h;
                
                % Adjusts the step for the next iteration 
                obj = obj.adjustStep(E(i+1));
                i = i + 1;
            end
            
            h(end) = obj.h; 
        end
        
        % One step in RKF45 
        function [tout, Wout, E] = step(obj, tin, Win, I, L)
            
            % Calculates sigma 
            S1 = Sigma.toMatrix(I^(-1) * Win' * L); 
            S2 = Sigma.toMatrix(I^(-1) * Exp.e(-obj.h, obj.A(2, 1)*S1) * Win' * L);  
            S3 = Sigma.toMatrix(I^(-1) * Exp.e(-obj.h, obj.A(3, 1)*S1 + obj.A(3, 2)*S2) * Win' * L); 
            S4 = Sigma.toMatrix(I^(-1) * Exp.e(-obj.h, obj.A(4, 1)*S1 + obj.A(4, 2)*S2 + obj.A(4, 3)*S3) * Win' * L); 
            S5 = Sigma.toMatrix(I^(-1) * Exp.e(-obj.h, obj.A(5, 1)*S1 + obj.A(5, 2)*S2 + obj.A(5, 3)*S3 + obj.A(5, 4)*S4) * Win' * L); 
            S6 = Sigma.toMatrix(I^(-1) * Exp.e(-obj.h, obj.A(6, 1)*S1 + obj.A(6, 2)*S2 + obj.A(6, 3)*S3 + obj.A(6, 4)*S4 + obj.A(6, 5)*S5) * Win' * L); 
                
            % Calculates t
            tout = tin + obj.h; 
                
            % Calculates W and Z 
            Wout = obj.wStep(Win, S1, S2, S3, S4, S5, S6); 
            Zout = obj.zStep(Win, S1, S2, S3, S4, S5, S6); 
                
            % Calculates the error 
            DW = Wout - Zout; 
            E = trace(transpose(DW) * DW); 
        end
        
        % One step for calculating W
        function Wout = wStep(obj, Win, S1, S2, S3, S4, S5, S6)
            Wout = Win * Exp.e(obj.h, obj.B(1, 1)*S1 + obj.B(1, 2)*S2 + obj.B(1, 3)*S3 + obj.B(1, 4)*S4 + obj.B(1, 5)*S5 + obj.B(1, 6)*S6);   
        end
        
        % One step for calculating Z 
        function Zout = zStep(obj, Win, S1, S2, S3, S4, S5, S6)
            Zout = Win * Exp.e(obj.h, obj.B(2, 1)*S1 + obj.B(2, 2)*S2 + obj.B(2, 3)*S3 + obj.B(2, 4)*S4 + obj.B(2, 5)*S5 + obj.B(2, 6)*S6);   
        end
        
        % Adjusts the step size to ensure tolerance is met 
        function obj = adjustStep(obj, E)
            if(E == 0)
                obj.h = 2 * obj.h; 
            else
                obj.h = 0.8 * (obj.TOL / E)^(1/6) * obj.h;
            end
            
            if(obj.h == inf)
                disp(['Error', num2str(E)]) 
            end
        end
    end
end