function draw_robot_arm(th1, th2)

% This function draw a simple, two-link arm.
%
% Inputs:
% th1 = absolute angle (rad), measured CCW wrt x axis
% th2 = relative angle (rad), measured CCW wrt th1

if ~exist('L1','var') || isempty(L1)
    L1 = 13.7; % (meters)F2020 version of arm
end
if ~exist('L2','var') || isempty(L2)
    L2 = 9.65; % F2020 version of arm
end

%% First, define some variables:
xee = L1*cos(th1) + L2*cos(th1+th2);
yee = L1*sin(th1) + L2*sin(th1+th2);
my_blue = [.4 .8 1];
my_green = [.6 1 .8];
av = pi*[0:.01:1]-pi/2;
r = 0.5;

%% Below: create POLAR COORDINATES (r and a) to define links 1 and 2:
x1 = [0 L1+r*cos(av) r*cos(av+pi)];
y1 = [-r r*sin(av) r*sin(av+pi)];
r1 = (x1.^2 + y1.^2).^.5;
a1 = atan2(y1,x1);
x2 = [0 L2+r*cos(av) r*cos(av+pi)];
y2 = [-r r*sin(av) r*sin(av+pi)];
r2 = (x2.^2 + y2.^2).^.5;
a2 = atan2(y2,x2);

%% Finally, draw the shapes
patch(r1.*cos(a1+th1),r1.*sin(a1+th1),'k-','FaceColor',my_blue,...
    'FaceAlpha',.5);
hold on
patch(L1*cos(th1) + r2.*cos(a2+th1+th2),L1*sin(th1) + r2.*sin(a2+th1+th2),'k-','FaceColor',my_green,...
    'FaceAlpha',.5);
plot(0,0,'k+','LineWidth',2)
plot(xee,yee,'k.','LineWidth',2)
axis image % this forces the x and y axes to scale the same way
xlabel('Centimeters As Units')