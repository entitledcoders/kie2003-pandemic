function new_rate = infection_rate(current_rate)
random_num = rand(1)
new_rate = current_rate + (random_num - 0.5)*current_rate*10;

end

