function new_rate = infection_rate(current_rate)
random_num = rand(1);
new_rate = 0.5 + (random_num - 0.5)*10;
end