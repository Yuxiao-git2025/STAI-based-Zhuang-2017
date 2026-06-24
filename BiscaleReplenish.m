function [tMiss,mMiss,tNew,mNew,info]=BiscaleReplenish(t, m, T, S0, tol, maxIter, nEdge)
% Implements the bi-scale replenishment idea in Zhuang et al. (2017).
%
% Inputs:
%   t       : observed event times, preferably relative to catalog start
%   m       : observed magnitudes
%   T       : catalog time window length
%   S0      : polygon of initially identified missing region in [0,1]^2
%             format: [x1 y1; x2 y2; ...]
%   tol     : convergence tolerance, e.g. 1e-4
%   maxIter : maximum iteration number, e.g. 50
%   nEdge   : number of interpolation points per polygon edge, e.g. 20
seed=2026;
rng(seed);
fprintf('# Random seed is %d \n',seed);

if nargin < 3 || isempty(T)
    T = max(t);
end
if nargin < 5 || isempty(tol)
    tol = 1e-4;
end

if nargin < 6 || isempty(maxIter)
    maxIter = 50;
end

if nargin < 7 || isempty(nEdge)
    nEdge = 20;
end
t = t(:);
m = m(:);
n = length(t);
% Initial empirical bi-scale transform.
u = Biscale_ecdf(t, ones(n,1), t);
v = Biscale_ecdf(m, ones(n,1), m);
S = S0;
for iter = 1:maxIter
    inside = inpolygon(u, v, S(:,1), S(:,2));

    vLen = Biscale_pCrossLength(S, u, 'vertical');
    hLen = Biscale_pCrossLength(S, v, 'horizontal');

    denom1 = max(1 - vLen, eps);
    denom2 = max(1 - hLen, eps);

    w1 = double(~inside) ./ denom1;
    w2 = double(~inside) ./ denom2;

    if sum(w1) <= 0 || sum(w2) <= 0
        error('# All points are inside the missing region. Please check S0.');
    end
    uNew = Biscale_ecdf(u, w1, u);
    vNew = Biscale_ecdf(v, w2, v);
    SNew = Biscale_MapRegionbyecdf(S, u, v, w1, w2, nEdge);
    delta = max(max(abs(uNew - u)), max(abs(vNew - v)));

    u = uNew;
    v = vNew;
    S = SNew;

    if delta < tol
        fprintf('# Have itered %d times and break now \n',iter);
        break;
    end
end

insideFinal = inpolygon(u, v, S(:,1), S(:,2));
nInsideObs = sum(insideFinal);
nOutsideObs = n - nInsideObs;

areaS = abs(polyarea(S(:,1), S(:,2)));
areaS = min(max(areaS, 0), 1);

pOutside = max(1 - areaS, eps);

% Number of total events expected inside S*, conditional on outside count.
% Function: nbinrnd(r,p) returns failures before r successes.
if exist('nbinrnd', 'file') == 2
    Ktotal = nbinrnd(nOutsideObs, pOutside);
else
    Ktotal = Biscale_NBSampler(nOutsideObs, pOutside);
end

% Ensure the simulated total inside count is not smaller than already observed.
while Ktotal < nInsideObs
    if exist('nbinrnd', 'file') == 2
        Ktotal = nbinrnd(nOutsideObs, pOutside);
    else
        Ktotal = negative_binomial_simple(nOutsideObs, pOutside);
    end
end
simPts = Biscale_SamplePolygon(S, Ktotal);
obsInside = [u(insideFinal), v(insideFinal)];
% Remove simulated points closest to already observed points inside S*
repPts=Biscale_RemovePoints(simPts, obsInside);
if isempty(repPts)
    tMiss = [];
    mMiss = [];
else
    uMiss = repPts(:,1);
    vMiss = repPts(:,2);
    isNearMag=false;
    tMiss = Biscale_InverseMap(uMiss, u, t, 0, T,isNearMag);
%     isNearMag=true;
    isNearMag=false;
    mMiss = Biscale_InverseMap(vMiss, v, m, min(m), max(m),isNearMag);
end
% Combined the data
tNew = [t(:); tMiss(:)];
mNew = [m(:); mMiss(:)];
[tNew, idx]=sort(tNew);
mNew = mNew(idx);

info.u = u;
info.v = v;
info.S = S;
info.iter = iter;
info.areaS = areaS;
info.nInsideObserved = nInsideObs;
info.nOutsideObserved = nOutsideObs;
info.KtotalInside = Ktotal;
info.nReplenished = length(tMiss);
end
