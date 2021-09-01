
%--------------------------------------------------------------------------
%                                Energy.m
% 
% Description: 
%    Calculates the energy, K, for object 
%
% Input:
%    X      SO(3), matrix in the Lie-group 
%    I      Moment of inertia 
%    w      Rotation vector 
%
% Output: 
%    K      Energy for object  
%
%--------------------------------------------------------------------------

classdef Energy
    methods (Static)
        function K = calculate(L, w) 
            K = (1/2) * dot(L, w);
        end
    end
end