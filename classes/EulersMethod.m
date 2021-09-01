
%--------------------------------------------------------------------------
%                              EulersMethod.m
% 
% Description: 
%    Class for eulers method 
%
% Properties: 
%    h      Step length 
%    n      Number of iterations 
%
%--------------------------------------------------------------------------

classdef EulersMethod    
    
    properties 
        h;
        n;
    end
        
    methods
        function obj = EulersMethod(h, n)
            obj.h = h; 
            obj.n = n; 
        end
        
        function [t, W] = solve(obj, X0, I, L)
            t = zeros(1, obj.n); 
            W = cell(1, obj.n); 
            
            t(1) = 0; 
            W{1} = X0;
            
            for i = 1:obj.n
                o = Omega.toMatrix(I^(-1) * W{i}' * L); 
                
                t(i+1) = t(i) + obj.h; 
                W{i+1} = obj.step(W{i}, o); 
            end
        end
        
        function Wout = step(obj, Win, o)
            Wout = Win * Exp.e(obj.h, o);   
        end
    end
end