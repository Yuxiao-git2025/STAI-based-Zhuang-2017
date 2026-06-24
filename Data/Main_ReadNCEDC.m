% data=readmatrix("NCEDC_Test.txt");
fn = 'NCEDC_Test.txt';
opts = detectImportOptions(fn, ...
    'FileType','text', ...
    'Delimiter', {' ', '\t'}, ...
    'ConsecutiveDelimitersRule','join');
opts.DataLines = [3 Inf];
opts.VariableNames = {'Date','Time','Lat','Lon','Depth','Mag','Magt', ...
                      'Nst','Gap','Clo','RMS','SRC','EventID'};
opts = setvartype(opts, {'Lat','Lon','Depth','Mag','Nst','Gap','Clo','RMS'}, 'double');
opts = setvartype(opts, {'Date','Time','Magt','SRC','EventID'}, 'string');
T = readtable(fn, opts);
T.DateTime = datetime(T.Date + " " + T.Time, ...
    'InputFormat','yyyy/MM/dd HH:mm:ss.SS');
T(:,{'Date','Time'}) = [];
t=days(T.DateTime-T.DateTime(1));
m=T.Mag;
lon=T.Lon;
lat=T.Lat;
dep=T.Depth;
tdate=T.DateTime;
% Mmin=1.0;id=m>=Mmin;
% t=t(id);
% m=m(id);
% lon=lon(id);
% lat=lat(id);
% dep=dep(id);
% tdate=tdate(id);
%%
scatter(t,m,4,'k','filled')
