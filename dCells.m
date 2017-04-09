% Andrew Dhawan
% 9th April 2017, Describes growth of cells given radiotherapy

function dy=dCells(t,y,params)
dose = params(1);
t_fraction = params(2);
t_dose_given = params(3);
t_end_rad = params(4);
alpha = params(5);
beta = params (6);
rho = params(7);
percent_in_morning = params(8);

dose= percent_in_morning * dose;
dose_2 = (1-percent_in_morning) * dose;

if (mod (t,7) < 5)
    if (mod(t,t_fraction)  < t_dose_given && t<= t_end_rad )
        dy = rho * y - ((alpha + (2 * beta * (dose * mod(t,t_dose_given) / t_dose_given))) * dose * y / t_dose_given );
    elseif (mod(t,t_fraction)  < t_dose_given+ 0.25 && t<= t_end_rad && mod(t,t_fraction) > 0.25)
        dy = rho * y - ((alpha + (2 * beta * (dose_2 * mod(t,t_dose_given)/t_dose_given)))* dose_2 * y / t_dose_given) ;
        else
    dy = rho * y;
    end
else
    dy = rho * y;
end

end
