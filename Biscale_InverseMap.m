function xOrig=Biscale_InverseMap(z, zObs, xObs, lowerBound, upperBound, isNearMag)
% Inverse empirical map by linear interpolation.
% If isNearMag is true, output values are rounded to one decimal place
if nargin < 6
    isNearMag = false;
end

z = z(:);
zObs = zObs(:);
xObs = xObs(:);

[zs, idx] = sort(zObs);
xs = xObs(idx);

gridZ = [0; zs; 1];
gridX = [lowerBound; xs; upperBound];

[gridZUnique, ia] = unique(gridZ, 'stable');
gridXUnique = gridX(ia);

xOrig = interp1(gridZUnique, gridXUnique, z, 'linear', 'extrap');

% First clamp to the valid original range
xmin = min(lowerBound, upperBound);
xmax = max(lowerBound, upperBound);
xOrig = min(max(xOrig, xmin), xmax);

% For magnitudes, most catalogs use one decimal place
if isNearMag
    fprintf('# Mags are restricted to dM=0.1 \n');
    xOrig = round(xOrig * 10) / 10;
    % Clamp again because rounding may push values slightly outside bounds.
    xOrig = min(max(xOrig, xmin), xmax);
end

end
