function Biscale_MapMT(t,m,tMiss,mMiss)
figure;
tiledlayout(2,3,"TileSpacing",'compact','Padding','compact');
nexttile([1,2]);
scatter(t, m, 20, 'k', 'filled','square');
Fun_defaultAxes;
ylim([floor(min(m)) ceil(max(m))+1])
ylabel('Mag');

nexttile([2,1]);
hold on;
plot(t,1:length(t),'LineStyle','-','Color','k','LineWidth',0.8);
plot(sort([t;tMiss]),1:(length(t)+length(tMiss)),'LineStyle','-', ...
    'Color',[0.2784    0.7882    0.6863],'LineWidth',2.8);
ax=gca;
ax.YAxisLocation='right';
xlabel('Time');
ylabel('Count');
Fun_defaultAxes;



nexttile([1,2]);hold on;
scatter(t, m, 20, 'k', 'filled','square');
scatter(tMiss, mMiss, 20, [0.2784    0.7882    0.6863], 'filled','d');
ylim([floor(min(m)) ceil(max(m))+1])
Fun_defaultAxes;
set(gcf, 'Position', [300, 100, 1000, 690]);
xlabel('Time');
ylabel('Mag');

% figure;
% cal_Mc_MAXC([mMiss;m],0.1,1);
end