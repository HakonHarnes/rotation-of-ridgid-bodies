
%--------------------------------------------------------------------------
%                                Sigma.m
% 
% Description: 
%    Class used to convert between sigma matrices and vectors 
%
%--------------------------------------------------------------------------

classdef Sigma 
    methods(Static)
        
        % Converts sigma vector to sigma matrix 
        function S = toMatrix(s)
            S = [  0    -s(3)  s(2)
                  s(3)    0   -s(1)
                 -s(2)   s(1)   0   ];
        end
    end
end