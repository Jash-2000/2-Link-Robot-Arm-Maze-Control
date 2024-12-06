function [xee,yee] = FK(theta1,theta2,L1, L2)
% FK = "forward kinematics"
% Inputs: theta1, theta2 are motor angles (in RADIANS)
%         L1 and L2 are link lengths (in METERS)
% Outputs: (xee,yee) give coordinates of END EFFECTOR (in METERS)
xee = L1 * cos (theta1) + L2 * cos (theta1+theta2);
yee = L1 * sin (theta1) + L2 * sin (theta1+theta2);
