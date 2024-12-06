function [theta1,theta2] = IK(xee,yee, L1, L2)
% IK = "inverse kinematic", from end effector (x,y) to required
%      joint angles (theta1, theta2)
% Inputs: desired xee and yee of desired end effector (in METERS)
%         L1 and L2 of the two-link arm (in meters)
% Outputs: theta1 and theta2 (motor angles, in RADIANS)
% Lego two-link robot arm uses these link lengths:
% L1 = 0.137 ;               % length of link 1
% L2 = 0.0965 ;              % length of link 2
%% Below, YOU MUST CHANGE THE NEXT TWO LINES, to output the actual IK
r = (xee^2 + yee^2)^0.5;
theta2  = acos( (r^2 - L1^2 - L2^2) / (2*L1*L2) );
% theta1 = atan(yee/xee) - atan((L2*sin(theta2))/(L1+L2*cos(theta2))); % for positve theta 1 
theta1 = atan2(yee,xee) - acos((L2^2 - L1^2 - r^2)/-(2* L1 * r));      % for any theta 1