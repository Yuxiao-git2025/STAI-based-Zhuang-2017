function pts=Biscale_SamplePolygon(poly, n)
% Rejection sampling from a polygon

if n <= 0
    pts = zeros(0,2);
    return;
end

xmin = min(poly(:,1));
xmax = max(poly(:,1));
ymin = min(poly(:,2));
ymax = max(poly(:,2));

pts = zeros(n,2);
count = 0;

while count < n
    batch = max(1000, 2 * (n - count));

    xr = xmin + (xmax - xmin) * rand(batch,1);
    yr = ymin + (ymax - ymin) * rand(batch,1);

    inside = inpolygon(xr, yr, poly(:,1), poly(:,2));
    cand = [xr(inside), yr(inside)];

    take = min(size(cand,1), n - count);

    if take > 0
        pts(count+1:count+take,:) = cand(1:take,:);
        count = count + take;
    end
end
end
