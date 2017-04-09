# tcp-relapse
Code to calculate tumour control probability with Poisson model

Files included are:

[1] get_data_make_graphs.m - function that should be called by the user, shows how TCP_calc function is used to generate the plots and sensitivity analysis that are used in the manuscript

[2] TCP_calc.m - workhorse function, wherein the radiation schedule is calculated, the TCP and recurrence times are calculated, and saves .mat objects containing necessary information for plotting

[3] dCells.m - contains the ODE for the average number of cells during the radiotherapy treatment

[4] dLogistic.m - contains logistic growth ODE for average number of cells following treatement

[5] ode4.m - ODE solver used


<a href="https://zenodo.org/badge/latestdoi/87719667"><img src="https://zenodo.org/badge/87719667.svg" alt="DOI"></a>
