%This function actually creates the TCP curve
%Andrew Dhawan
%9th April 2017
%Takes in the max dose given to the patient, alpha, beta radiosensitivity
%parameters, the growth rate following radiotherapy, dose to the patient in
%each fraction, the percentage of this dose in the AM (if hyperfractionated
%schedule is considered), the end time of the simulation, the doubling time
%of the tumour, a logical of whether we are considering proton therapy or
%not (in which case we need to scale dose to a CGE), and the output
%filenames

function [times_log, recurrence_rates_time]= TCP_calc (max_dose_pt, alpha, beta, rho_2, dose_pt,percent_in_morning, t_end,t_dbl, isProton, fName,fName2)
IC = 10^6; %This is the initial number of cells of the tumour
t_end_rad = 0.0104; %This is how long it takes radiation dose to be administered
t_fraction = 1; 

if (isProton == 1) %CGE equivalent
    max_dose = max_dose_pt * 1.1;
    dose = dose_pt * 1.1;
else
    max_dose = max_dose_pt;
    dose = dose_pt;
end

t_dose_given = floor(ceil(max_dose/dose)/5)*7-2 + ((2 + rem(ceil(max_dose/dose),5) ) * (mod(ceil(max_dose/dose),5)>0)); %Calculates dose schedule
rho_1 = log(2)/t_dbl;
params = [dose ; t_fraction ; t_end_rad ; t_dose_given ; alpha; beta; rho_1 ; percent_in_morning ;max_dose]; 

times_vec= 0:0.0005:t_end;

[Y]=ode4(@(t,y)(dCells(t,y,params)),times_vec,IC); %Calls on the ode model to get the average number of cells

TCP_time_fcn = exp(-Y); %Poisson probability
plot(times_vec,TCP_time_fcn) %Plotting
%title('TCP')
%xlabel('Time (days)')
%ylabel('Probability of tumour control')
figure();
doses_and_times = [];
for i=1:length(times_vec)
    doses_and_times(i) = dose_time_fcn(times_vec(i),params);
end
figure();
plot(times_vec, doses_and_times)
figure();
doses_vec = 0:1:max_dose;
req_TCP = [];
for k = 1:length(doses_vec);
    req_dose = doses_vec(k);
    for i=2:length(doses_and_times)
        cur_dose = doses_and_times(i);
        prev_dose = doses_and_times(i-1);
        if (cur_dose >= req_dose && prev_dose <= req_dose )
            req_TCP(k) =TCP_time_fcn(i) ;% times_vec(i);
            break;
        end
    end
end

TCP_dose_curve = [doses_vec' req_TCP'];

finalTCP = req_TCP(length(req_TCP));

initial_log_growth_cond = -log(finalTCP) %IC for logistic growth

%1826 days in 5 years, simulate out growth for 10 years
[times_log, y_log] = ode23s(@(t,y)(dLogistic(t,y,rho_2)),[0,3652],initial_log_growth_cond);

recurrence_rates_time = ones(length(times_log),1)-poisscdf(10^6,y_log);

plot(times_log, recurrence_rates_time,'red')
title('Probability of Cancer Recurrence vs. Time')
xlabel('Time (days)')
ylabel('Probability')

final_value_logistic = y_log(length(y_log));

recurrence_rate = 1 - poisscdf(10^6,final_value_logistic);

recurTime = interp1(y_log,times_log,(10^6)*0.999)
dosesVec =doses_vec';
TCPdose = req_TCP';

save(fName,'times_vec', 'TCP_time_fcn','times_log','y_log','recurrence_rates_time','recurTime','dosesVec','TCPdose')
h = figure;
subplot(1,2,1)
plot(times_vec,TCP_time_fcn)
subplot(1,2,2)
plot(times_log,recurrence_rates_time)
saveas(h, fName2,'fig')
end

function cumulative_dose = dose_time_fcn (t, params)

dose = params(1);
t_fraction = params(2);
t_end_rad = params(3);
t_dose_given = params(4);
alpha = params(5);
beta = params(6);
rho = params(7);
percent_in_morning = params(8);
max_dose = params(9);
dose_1 = percent_in_morning * dose;
dose_2 = dose - dose_1;

cur_day  = floor(t);
cur_frac = cur_day - (floor(t/7) * 2)+1;
if (t >= t_dose_given)
    cumulative_dose = max_dose;
else
    if (mod(t,7) >= 5)
        cumulative_dose = (floor(t/7) + 1) * 5 * dose;
    else
        if (mod(t,1) < t_end_rad )
            cumulative_dose = (dose_1 / t_end_rad) .* (mod(t,t_fraction)) + (dose * (cur_frac-1));
        elseif (mod(t,1) > 0.25 && (mod(t,1) < (t_end_rad + 0.25)))
            cumulative_dose = (dose_2 / t_end_rad) .* (mod(t-0.25,t_fraction)) + (dose * (cur_frac-1)) + dose_1;
        else
            cumulative_dose = dose*(cur_frac-1)+ (dose_1 * (mod(t,1)>=t_end_rad))+(dose_2 * (mod(t,1)>=(t_end_rad+0.25)));

        end
    end
end

end

