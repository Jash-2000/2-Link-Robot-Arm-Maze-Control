function Prelab0_animate(data1,data2)
%% knowns given 
L1 = 0.137 ;                 % length of link 1 (F2020 value)
L2 = 0.0965 ;                % length of link 2 (F2020 value)

t = data1.time;
if 0 % WITH TRUE BACKLASH!
    theta1 = data1.signals.values(:,3); % WITH BACKLASH!
    theta2 = data2.signals.values(:,3);
else
    theta1 = data1.signals.values(:,1);
    theta2 = data2.signals.values(:,1);
end

xpnts = [ zeros(length(t),1), L1 * cos(theta1), L1 * cos(theta1) + L2 * cos(theta1+theta2)];
ypnts = [ zeros(length(t),1), L1 * sin(theta1), L1 * sin(theta1) + L2 * sin(theta1+theta2)];

gcf;
ground = plot( (L1+L2)*[-1,1], [0,0], 'k','LineWidth',6); hold on
arm1 = plot(xpnts(1,1:2),ypnts(1,1:2),'b','LineWidth',8); 
arm2 = plot(xpnts(1,2:3),ypnts(1,2:3),'g','LineWidth',8); grid on;
jnt1 = plot(0,0,'ro','MarkerSize',10,'MarkerFaceColor','r');
jnt2 = plot(xpnts(1,2),ypnts(1,2),'ro','MarkerSize',8,'MarkerFaceColor','r'); 
jnt3 = plot(xpnts(1,3),ypnts(1,3),'mo','MarkerSize',8,'MarkerFaceColor','m'); 
limits = (L1+L2) * [-1,1,-0.3,1];
axis(limits);
axis equal
xlabel('m');
ylabel('m');



pause(t(1));
for i = 2:10:length(t)
    set(arm1,'XData',xpnts(i,1:2),'YData',ypnts(i,1:2));
    set(arm2,'XData',xpnts(i,2:3),'YData',ypnts(i,2:3));
    set(jnt2,'XData',xpnts(i,2),'YData',ypnts(i,2));
    set(jnt3,'XData',xpnts(i,3),'YData',ypnts(i,3));
    axis(limits);
    %drawnow
    pause(.1*(t(i)-t(i-1)));
end

end