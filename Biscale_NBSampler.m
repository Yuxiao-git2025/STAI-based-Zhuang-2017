function x = Biscale_NBSampler(r, p)
% Returns number of failures before r successes.
% This is a fallback if nbinrnd is unavailable.

success = 0;
fail = 0;

while success < r
    if rand < p
        success = success + 1;
    else
        fail = fail + 1;
    end
end

x = fail;
end
