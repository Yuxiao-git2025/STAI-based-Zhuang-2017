function S0=Biscale_Mapecdf(t,m,S0,SearchNow)
n = length(t);
u0 = Biscale_ecdf(t(:), ones(n,1), t(:));
v0 = Biscale_ecdf(m(:), ones(n,1), m(:));
fprintf('# Time range from [%.2f  %.2f] \n',min(t),max(t));
figure;
tiledlayout(1,1,"TileSpacing","compact","Padding","compact");
nexttile;
ax=gca;
hold on;
msize=15;
scatter(u0, v0, msize, 'k', 'filled');
xlabel('Empirical time');
ylabel('Empirical magnitude');
axis([0 1 0 1]);
Fun_Decorat;
if SearchNow && isempty(S0)
    fprintf('# Plot points now \n');
    S0=Fun_GetUILocation(ax); % Plot points by yourself
%     S0=S0(1:(end-1),:);
else
    fprintf('# S0 is loaded \n');
    % S0 = [
    %     0.00 0.00
    %     0.35 0.00
    %     0.3 0.4
    %     0.00 0.4
    % ];
end
plot([S0(:,1);S0(1,1)],[S0(:,2);S0(1,2)],'LineWidth',2,'Color','r');

end