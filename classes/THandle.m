
%--------------------------------------------------------------------------
%                               THandle.m
% 
% Description: 
%    Class for T-Handle 
%
% Properties: 
%    R1     Radius of cylinder 1
%    R2     Radius of cylinder 2
%    L1     Length og cylinder 1
%    L2     Length og cylinder 2
%    M      Mass of T-Handle 
%    p      Mass density of cylinders 
%    I      Moment of inertia matrix 
%
%--------------------------------------------------------------------------

classdef THandle
    properties
        R1; R2;
        L1; L2; 
        M;
        P; 
        I; 
    end
    
    methods
        function obj = THandle(r1, r2, l1, l2, m, p)
           obj.R1 = r1; obj.R2 = r2;
           obj.L1 = l1; obj.L2 = l2;
           obj.M = m; 
           obj.P = p; 
        end
        
        % Calculates the moment of inertia
        function [I, obj] = calculateMomentOfInertia(obj)
            TOL = 1e-12; 

            % Calculates masses 
            M1 = pi * obj.R1^2 * obj.L1 * obj.P; 
            M2 = pi * obj.R2^2 * obj.L2 * obj.P; 

            % Verifies that the masses add up to the total mass 
            if (M1 + M2) - obj.M > TOL
                error('Invalid input for masses! M1 + M2 ~= M'); 
            end

            % Calculates components of I 
            Ixx = (M1 * obj.R1^2)/4 + (M1 * obj.L1^2)/12 + (M2 * obj.R2^2)/2; 
            Iyy = (M1 * obj.R1^2) + (M2 * obj.L2^2)/4 + (M1 * obj.R1^2)/2 + (M2 * obj.R2^2)/4 + (M2 * obj.L2^2)/12; 
            Izz = (M1 * obj.R1^2) + (M2 * obj.L2^2)/4 + (M1 * obj.R1^2)/4 + (M1 * obj.L1^2)/12 + (M2 * obj.R2^2)/4 + (M2 * obj.L2^2)/12; 

            % Creates moment of inertia matrix 
            I = diag([Ixx Iyy Izz]); 
            obj.I = I; 
        end
    end
end