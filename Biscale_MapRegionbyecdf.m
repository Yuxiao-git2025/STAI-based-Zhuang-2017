function SNew=Biscale_MapRegionbyecdf(S, u, v, w1, w2, nEdge)
% Maps polygon boundary using weighted empirical CDFs
pts = [];
for i = 1:size(S,1)
    j = i + 1;
    if j > size(S,1)
        j = 1;
    end

    x1 = S(i,1);
    y1 = S(i,2);
    x2 = S(j,1);
    y2 = S(j,2);

    a = linspace(0, 1, nEdge + 1)';
    if i < size(S,1)
        a = a(1:end-1);
    end

    xs = x1 + a * (x2 - x1);
    ys = y1 + a * (y2 - y1);

    pts = [pts; xs ys];
end

xNew = Biscale_ecdf(u, w1, pts(:,1));
yNew = Biscale_ecdf(v, w2, pts(:,2));

SNew = [xNew yNew];

% Remove exact duplicate neighboring points.
keep = true(size(SNew,1),1);
for i = 2:size(SNew,1)
    if norm(SNew(i,:) - SNew(i-1,:)) < 1e-12
        keep(i) = false;
    end
end

SNew = SNew(keep,:);

SNew(:,1) = min(max(SNew(:,1), 0), 1);
SNew(:,2) = min(max(SNew(:,2), 0), 1);
end
