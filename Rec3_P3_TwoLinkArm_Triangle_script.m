% Rec3_TwoLinkArm_Triangle_script
% This simple script automatically runs the Simulink model called:
%     Rec3_TwoLinkArm.slx

clear % clears the workspace (variables, etc.)
close all % close any figures in Matlab

Kp1 = 11.4196; % Kp for PD controller (for "motor 1")
Kd1 = 1.6169; % Kd for PD controller (for "motor 1")
Kp2 = Kp1; % Kp for PD controller (for "motor 2")
Kd2 = Kd1; % for PD controller (for "motor 2")
f = 0.75; % value for "velocity filter"
A = (1-f)/0.005; % value for "velocity filter"

figure(1); clf
th1 = 165*(pi/180); % RADIANS
th2 = -138*(pi/180); % RADIANS
draw_robot_arm(th1,th2)
title('Units Below Are Centimeters')
fprintf('Currently showing a random configuration of the arm:\n')
fprintf('Equilateral, with 8cm per side (somewhere in the RWS) is shown as the desird trajectory.\n')

%% knowns given
T = 0.005;                   % sample time (set)
L1 = 13.7 ;               % length of link 1
L2 = 9.65 ;              % length of link 2
offset1 = 165*(pi/180);  % Rad: starting angle of motor 1 (after calibration)
offset2 = -138*(pi/180); % Rad: starting angle of motor 2 (after calibration)
n = 100;

%% Designing the task space
[x_off, y_off] = FK(offset1,offset2,L1,L2);
x_init = x_off+10;  %% Define any initial value of x
y_init = y_off+5;   %% Define any initial value of y
sim_t =[linspace(0,8,4*n)];
%sim_x =[linspace(x_off,x_init,n), linspace(x_init,x_init+8,n), linspace(x_init+8,x_init+4,n), linspace(x_init+4,x_init,n) ];
%sim_y =[linspace(y_off,y_init,n), linspace(y_init,y_init,n), linspace(y_init,y_init+4*(3)^0.5,n), linspace(y_init+4*(3)^0.5,y_init,n) ];
sim_x =[HC(x_off,x_init,n), HC(x_init,x_init+8,n), HC(x_init+8,x_init+4,n), HC(x_init+4,x_init,n) ];
sim_y =[HC(y_off,y_init,n), HC(y_init,y_init,n), HC(y_init,y_init+4*(3)^0.5,n), HC(y_init+4*(3)^0.5,y_init,n) ];
%plot(sim_x, sim_y);

theta_1_sim = zeros(1,length(sim_t));
theta_2_sim = zeros(1,length(sim_t));

for i = 1:length(sim_t)
    [theta_1_sim(i), theta_2_sim(i)] = IK(sim_x(1,i),sim_y(1,i),L1,L2);
end
input('Run the Simulink File with the current set of generated variables.....')

%%%% After running the simulink file, we will get the actual and estimated data points
% Plots of the desired and actual JOINT ANGLES, i.e., from motor1 and motor2 encoder outputs.
plot_true_theta1 = my_data1.signals.values(:, 1);
plot_true_theta2 = my_data2.signals.values(:, 1);
plot_desired_theta1 = my_data1.signals.values(:, 6);
plot_desired_theta2 = my_data2.signals.values(:, 6);
plot_time1 = my_data1.time;

plot_vel_1 = my_data1.signals.values(:, 2);
plot_vel_2 = my_data1.signals.values(:, 5);
plot_sig_1 = my_data2.signals.values(:, 2);
plot_sig_2 = my_data2.signals.values(:, 5);

plot_true_x = zeros(1,length(plot_time1));
plot_true_y = zeros(1,length(plot_time1));
plot_desired_x = zeros(1,length(plot_time1));
plot_desired_y = zeros(1,length(plot_time1));

for i = 1:length(plot_time1)
    [plot_desired_x(i), plot_desired_y(i)] = FK(plot_desired_theta1(i),plot_desired_theta2(i),L1,L2);
    [plot_true_x(i), plot_true_y(i)] = FK(plot_true_theta1(i),plot_true_theta2(i),L1,L2);
end
plot(plot_desired_x, plot_desired_y);
plot(plot_true_x, plot_true_y);
legend('Desired Path','True Path');

figure(2);
plot(plot_time1, plot_desired_x);
hold on;
plot(plot_time1, plot_true_x);
hold on;
plot(plot_time1, plot_desired_y);
hold on;
plot(plot_time1, plot_true_y);
hold on;
legend('Desired Path: x','True Path: x', 'Desired Path: y', 'True Path: y');
xlabel('Time (s)');
ylabel('Position (cm)');

figure(3);
plot(plot_time1, plot_desired_theta1);
hold on;
plot(plot_time1, plot_desired_theta2);
hold on;
plot(plot_time1, plot_true_theta1);
hold on;
plot(plot_time1, plot_true_theta2);
legend('Desired Theta_1','Desired Theta_2', 'True Theta_1','True theta_2');
xlabel('Time (s)');
ylabel('Angle (rad)');

figure(4);
subplot(3,1,1)
plot(plot_time1,plot_desired_theta1);
hold on;
plot(plot_time1,plot_true_theta1);
xlabel('Time (s)');
ylabel('Angle (rad)');
legend('Desired','Actual');
subplot(3,1,2)
plot(plot_time1,plot_vel_1);
xlabel('Time (s)');
ylabel('Filter Velocity (rad/s)');
subplot(3,1,3)
plot(plot_time1,plot_sig_1);
xlabel('Time (s)');
ylabel('Motor Signal U(t)');
sgtitle('Motor 1');

figure(5);
subplot(3,1,1)
plot(plot_time1,plot_desired_theta2);
hold on;
plot(plot_time1,plot_true_theta2);
xlabel('Time (s)');
ylabel('Angle (rad)');
legend('Desired','Actual');
subplot(3,1,2)
plot(plot_time1,plot_vel_2);
xlabel('Time (s)');
ylabel('Filter Velocity (rad/s)');
subplot(3,1,3)
plot(plot_time1,plot_sig_2);
xlabel('Time (s)');
ylabel('Motor Signal U(t)');
sgtitle('Motor 2');
