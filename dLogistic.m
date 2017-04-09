%Andrew Dhawan
%9th April 2017
%Code for logistic growth of cells following radiotherapy
function dy=dLogistic(t,y,rho)

K = 10^6; % this is the max carrying capacity for the logistic growth

dy = rho * y * (1 - (y / K) ) ;


end
