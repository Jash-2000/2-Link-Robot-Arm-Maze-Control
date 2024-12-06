close all; clear all;
%% Tuned Parameters
L1 = 13.7;
L2 = 9.65;
Kp1 = 11.4196; % Kp for PD controller (for "motor 1")
Kd1 = 1.6169; % Kd for PD controller (for "motor 1")
Kp2 = Kp1; % Kp for PD controller (for "motor 2")
Kd2 = Kd1; % for PD controller (for "motor 2")
f = 0.75; % value for "velocity filter"
A = (1-f)/0.005; % value for "velocity filter"
offset1 = 169*(pi/180);
offset2 = -147*(pi/180);
[x_off, y_off] = FK(offset1,offset2, L1, L2);
x_init = 6;
y_init = 6;
x_sharp = [-6 -6  12.5 15 17  15   10   6.5  5  5    4.5 6   9 11  12.5 13  12 6];
y_sharp = [3  -6  -5   1  7.5 14.5 15.5 14.5 12 9.5  4   2.5 4 4.5 6.5  9.5 12 11];
% Define the number of smooth waypoints
n = 1000;
% Create a finer set of x-values (between 1 and the number of sharp points)
x_fine = linspace(1, length(x_sharp), n);
% Interpolate the x and y values using cubic spline
sim_x = interp1(1:length(x_sharp), x_sharp, x_fine, 'spline');
sim_y = interp1(1:length(y_sharp), y_sharp, x_fine, 'spline');
%% Final set of values for time and trajectory
t_ref = zeros(1,length(sim_x));
for i = 2:length(t_ref)
  t_ref(i) = t_ref(i-1) + 0.005;
end
theta1_ref = zeros(1,length(t_ref));
theta2_ref = zeros(1,length(t_ref));
for i = 1:length(t_ref)
  [theta1_ref(i), theta2_ref(i)] = IK(sim_x(1,i),sim_y(1,i), L1, L2);
end
theta1_ref = real(theta1_ref);
theta2_ref = real(theta2_ref);
sim('Rec5_TwoLinkArmWithBacklash');
run('Automated_Scoring.m');
