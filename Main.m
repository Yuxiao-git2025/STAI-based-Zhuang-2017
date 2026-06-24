% =========================================================================
%                     Written by X.A.Yu 2026/06/20
% Methods: 
% Based on the assumption that earthquake magnitudes are independent of
% their occurrence times,  the whole process can transformed into a
% homogeneous Poisson process on the unit square by a biscale empirical
% transformation
% =========================================================================
% Readme:
% 1. For the input of S0, can either be provided directly or obtained
% from the transformed image
% 2. This version is limited to missing data within a single polygon.
% If the earthquake sequence has multiple missing locations,
% you can either perform the operation multiple times or modify the
% corresponding functions to enable simultaneous computation 
% (e.g., using a cell array for S0)
% 3. This version can limit the simulated magnitude to a precision of 0.1
% =========================================================================
% 
%% >> Load data
load('Data\NCEDC2019.mat');
cut=2e3;
T=max(t)+1e-2;  % default to Max(Time)
% S0=[
%     0.00 0.00
%     0.35 0.00
%     0.3 0.4
%     0.00 0.4
% ];
S0=[0.1319    0.9864
    0.1319    0.2376
    0.5680    0.2447];
S0=Biscale_Mapecdf(t,m,S0,false);  % Use exist
% S0=Biscale_Mapecdf(t,m,[],true); % Plot now
%% >> Doing Replenish
[tMiss,mMiss,tNew,mNew,info]=BiscaleReplenish(t, m, T, S0, 1e-4, 20, 20);

%% >> Check New data
% Biscale_Mapecdf(t,m,S0,false);
% Biscale_Mapecdf(tNew,mNew,S0,false);
Biscale_MapMT(t,m,tMiss,mMiss);

