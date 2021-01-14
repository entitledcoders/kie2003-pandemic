mean = 5;

maxDay = 14;
daysI = (1:maxDay);
daysProb = zeros(1,maxDay);
for i = 1:maxDay
    daysProb(i) = (mean^i) * (exp(-1*mean)) / factorial(i);
end

randNum = rand()

for i = 1:maxDay
   if(randNum > sum(daysProb(1:i)))
      tempRate = daysI(i) 
   end
end

