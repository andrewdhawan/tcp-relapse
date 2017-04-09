%Andrew Dhawan
%9th April 2017
%This is the code that produces the data for the TCP curves, as well as
%recurrence time. This is the only file that needs to be run by the end
%user.

%this is the case where we vary the time of doubling between 10-100 days
close all
%generate the data
dbl_times_sens = 10:5:100; %the doubling times under consideration
for i=dbl_times_sens
    t_dbl=i;
    
    TCP_calc(60,0.26,0.026,log(2)/t_dbl, 2,1, 120,t_dbl,1,strcat('t_dbl_',num2str(i),'_proton_conv.mat'), strcat('t_dbl_',num2str(i),'_proton_conv'))
    close all

    TCP_calc(60,0.26,0.026,log(2)/t_dbl, 3,1, 120,t_dbl,1,strcat('t_dbl_',num2str(i),'_proton_hypo.mat'), strcat('t_dbl_',num2str(i),'_proton_hypo'))
    close all

    TCP_calc(60,0.25,0.025,log(2)/t_dbl, 2,1, 120,t_dbl,0,strcat('t_dbl_',num2str(i),'_photon_conv_alpha_025.mat'), strcat('t_dbl_',num2str(i),'_photon_conv'))
    close all

    TCP_calc(60,0.25,0.025,log(2)/t_dbl, 3,1, 120,t_dbl,0,strcat('t_dbl_',num2str(i),'_photon_hypo_alpha_025.mat'), strcat('t_dbl_',num2str(i),'_photon_conv'))
    close all
end

%This is code to plot the contour plot / sensitivity curve for the doubling
%time
to_plot = zeros(length(dbl_times_sens),61);
count = 1;
for i=dbl_times_sens
   load(strcat('t_dbl_',num2str(i),'_photon_conv.mat'))
   to_plot(count,1:61) = TCPdose;
   count = count + 1;
end
contourf(to_plot)
colorbar




h1 = openfig('../sens_photon_conv_alpha_025.fig','reuse'); % open figure
ax1 = gca; % get handle to axes of figure
h2 = openfig('../sens_photon_hypo_alpha_025.fig','reuse');
ax2 = gca;

% h3 = openfig('../sens_photon_conv_alpha_03.fig','reuse'); % open figure
% ax3 = gca; % get handle to axes of figure
% h4 = openfig('../sens_photon_hypo_alpha_03.fig','reuse');
% ax4 = gca;

h3 = openfig('../sens_proton_conv_alpha_026.fig','reuse'); % open figure
ax3 = gca; % get handle to axes of figure
h4 = openfig('../sens_proton_hypo_alpha_026.fig','reuse');
ax4 = gca;

h7 = figure

s1 = subplot(2,2,1); %create and get handle to the subplot axes
s2 = subplot(2,2,2);
s3 = subplot(2,2,3);
s4 = subplot(2,2,4);
% s5 = subplot(3,2,5);
% s6 = subplot(3,2,6);

fig1 = get(ax1,'children'); %get handle to all the children in the figure
fig2 = get(ax2,'children');
fig3 = get(ax3,'children');
fig4 = get(ax4,'children');
% fig5 = get(ax5,'children');
% fig6 = get(ax6,'children');

copyobj(fig1,s1); %copy children to new parent axes i.e. the subplot axes
copyobj(fig2,s2);
copyobj(fig3,s3);
copyobj(fig4,s4);
% copyobj(fig5,s5);
% copyobj(fig6,s6);
