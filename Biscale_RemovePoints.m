function repPts=Biscale_RemovePoints(simPts, obsPts)
% Removes one simulated point closest to each observed point inside S*

repPts = simPts;

if isempty(repPts) || isempty(obsPts)
    return;
end

for i = 1:size(obsPts,1)
    if isempty(repPts)
        break;
    end

    dx = repPts(:,1) - obsPts(i,1);
    dy = repPts(:,2) - obsPts(i,2);
    d2 = dx.^2 + dy.^2;

    [~, idx] = min(d2);
    repPts(idx,:) = [];
end
end
