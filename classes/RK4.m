
%--------------------------------------------------------------------------
%                                  RK4.m
% 
% Description: 
%    Class for Runge-Kutta method 
%
% Properties: 
%    h      Step size 
%    n      Number of iterations 
%    TOL    Tolerance 
%
% Properties (Constant): 
%    A                  First part of the Butcher tableau
%    B                  Second part of the Butcher tableau
%
% Remark:
%   The Butcher tableau is not necessary to calculate the approximate
%   solution in RK4. It is used for calculating the error. 
% 
%--------------------------------------------------------------------------

classdef RK4
    
    properties 
        h;
        n;
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
    end
        
    methods
        function obj = RK4(h, n)
            obj.h = h; 
            obj.n = n; 
        end
        
        % Calculates the approximate solution 
        function [t, W, E] = solve(obj, X0, I, L)
            
            % Initializes variables 
            t = zeros(1, obj.n); t(1) = 0; 
            E = zeros(1, obj.n); E(1) = 0; 
            W = cell(1, obj.n);  W{1} = X0; 

            for i = 1:obj.n
                
                % Calculates sigma 
                S1 = Sigma.toMatrix(I^(-1) * W{i}' * L); 
                S2 = Sigma.toMatrix(I^(-1) * Exp.e(-obj.h/2, S1) * W{i}' * L);  
                S3 = Sigma.toMatrix(I^(-1) * Exp.e(-obj.h/2, S2) * W{i}' * L); 
                S4 = Sigma.toMatrix(I^(-1) * Exp.e(-obj.h,   S3) * W{i}' * L);  
                
                % Calculates t
                t(i+1) = t(i) + obj.h; 
                
                % Calculates W and Z 
                W{i+1} = obj.wStep(W{i}, S1, S2, S3, S4); 
                Z = obj.zStep(W{i}, I, L); 
                
                % Calculates the error 
                DW = W{i+1} - Z; 
                E(i+1) = trace(transpose(DW) * DW); 
            end
        end
        
        % One step for calculating W
        function Wout = wStep(obj, Win, S1, S2, S3, S4)
            Wout = Win * Exp.e(obj.h/6, S1 + 2*S2 + 2*S3 + S4);   
        end
        
        % One step for calculating Z 
        function Zout = zStep(obj, Win, I, L)
            
            % Calculates sigma 
            S1 = Sigma.toMatrix(I^(-1) * Win' * L); 
            S2 = Sigma.toMatrix(I^(-1) * Exp.e(-obj.h, obj.A(2, 1)*S1) * Win' * L);  
            S3 = Sigma.toMatrix(I^(-1) * Exp.e(-obj.h, obj.A(3, 1)*S1 + obj.A(3, 2)*S2) * Win' * L); 
            S4 = Sigma.toMatrix(I^(-1) * Exp.e(-obj.h, obj.A(4, 1)*S1 + obj.A(4, 2)*S2 + obj.A(4, 3)*S3) * Win' * L); 
            S5 = Sigma.toMatrix(I^(-1) * Exp.e(-obj.h, obj.A(5, 1)*S1 + obj.A(5, 2)*S2 + obj.A(5, 3)*S3 + obj.A(5, 4)*S4) * Win' * L); 
            S6 = Sigma.toMatrix(I^(-1) * Exp.e(-obj.h, obj.A(6, 1)*S1 + obj.A(6, 2)*S2 + obj.A(6, 3)*S3 + obj.A(6, 4)*S4 + obj.A(6, 5)*S5) * Win' * L); 
            
            % Calculates Z 
            Zout = Win * Exp.e(obj.h, obj.B(2, 1)*S1 + obj.B(2, 2)*S2 + obj.B(2, 3)*S3 + obj.B(2, 4)*S4 + obj.B(2, 5)*S5 + obj.B(2, 6)*S6);   
        end
    end
end