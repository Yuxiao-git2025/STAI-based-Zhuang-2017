function ys=Biscale_ecdf(xs, w, xq)
% Weighted empirical CDF mapping
% y(q) = sum_i w_i I(x_i <= q) / sum_i w_i
xs = xs(:);
w = w(:);
xq = xq(:);
valid = w > 0 & isfinite(xs) & isfinite(w);
xs = xs(valid);
w = w(valid);

[xs, idx] = sort(xs);
ws = w(idx);

cw = cumsum(ws) / sum(ws);

[xu, ia] = unique(xs, 'last');
cwu = cw(ia);

edges = [-inf; xu; inf];
bin = discretize(xq, edges);

ind = bin - 1;
ys = zeros(size(xq));

ok = ind > 0;
ind(ok) = min(ind(ok), length(cwu));
ys(ok) = cwu(ind(ok));

ys = min(max(ys, 0), 1);
end
