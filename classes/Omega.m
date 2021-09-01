
%--------------------------------------------------------------------------
%                                Omega.m
% 
% Description: 
%    Class used to convert between omega matrices and vectors 
%
%--------------------------------------------------------------------------

classdef Omega 
    methods(Static)
        
        % Converts omega matrix to omega vector
        function w = toVector(o)
            wX = o(3, 2); wY = o(1, 3); wZ = o(2, 1);
            w = [wX wY wZ]';     
        end
        
        % Converts omega vector to omega matrix 
        function o = toMatrix(w)
            o = [  0    -w(3)  w(2)
                  w(3)    0   -w(1)
                 -w(2)   w(1)   0   ];
        end
        
        % Calculates length of omega matrix or vector 
        function len = length(o)
            len = norm(o); 
        end
    end
end