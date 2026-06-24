function len=Biscale_pCrossLength(poly, q, modeName)
% Computes vertical or horizontal cross-section length of a polygon
% modeName = 'vertical'   : line x = q, return length in y direction
% modeName = 'horizontal' : line y = q, return length in x direction
q = q(:);
len = zeros(size(q));

x = poly(:,1);
y = poly(:,2);

if x(1) ~= x(end) || y(1) ~= y(end)
    x = [x; x(1)];
    y = [y; y(1)];
end

for ii = 1:length(q)
    a = q(ii);
    vals = [];

    for j = 1:length(x)-1
        x1 = x(j);
        x2 = x(j+1);
        y1 = y(j);
        y2 = y(j+1);

        if strcmp(modeName, 'vertical')
            if (x1 <= a && a < x2) || (x2 <= a && a < x1)
                if x2 ~= x1
                    yy = y1 + (a - x1) * (y2 - y1) / (x2 - x1);
                    vals = [vals; yy];
                end
            end
        else
            if (y1 <= a && a < y2) || (y2 <= a && a < y1)
                if y2 ~= y1
                    xx = x1 + (a - y1) * (x2 - x1) / (y2 - y1);
                    vals = [vals; xx];
                end
            end
        end
    end

    vals = sort(vals);

    if mod(length(vals), 2) == 1
        vals = vals(1:end-1);
    end

    s = 0;
    for k = 1:2:length(vals)
        s = s + vals(k+1) - vals(k);
    end

    len(ii) = max(s, 0);
end
end
