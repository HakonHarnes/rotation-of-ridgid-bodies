
%--------------------------------------------------------------------------
%                                  Exp.m
% 
% Description: 
%    Calculates an orthogonal matrix with determinant = 1    
%
% Input:
%    h      Step length    
%    o      [ 0   -wZ    wY         
%             wZ   0    -wX
%            -wY   wX    0  ]
%
% Output: 
%    X      Orthogonal matrix 
%
%--------------------------------------------------------------------------

classdef Exp
    methods (Static)
        
        % Calculates the exp 
        function X = e(h, o)
            w = Omega.length(o);
            X = eye(3) + (1 - cos(w*h)) * (o^2/w^2) + sin(w*h) * (o/w);  
        end
        
        % Checks X * X^T = I (within tolerance) 
        function result = test(X, TOL)
            result = min(min(ismembertol(X * X.', eye(3), TOL))); 
        end
    end
end