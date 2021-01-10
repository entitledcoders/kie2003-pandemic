x = linspace(0,2*pi,1000);
y = sin(x);

h = animatedline;

xlabel('x')
ylabel('sin(x)');
title('Plot of the Sine Function');
axis([0 2*pi -1 1])

for i = 1:length(x)
   addpoints(h,x(i),y(i));
   drawnow;
end

