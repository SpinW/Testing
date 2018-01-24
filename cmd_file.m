p = pwd;
cd('/home/spinw')
install_spinw('silent',true)
cd(p)
d = version; d = d(end-1:-1:end-6); d = d(end:-1:1);
log_dir = fullfile(filesep,'tmp','Report',d);
if strcmpi(d(1:end-1),'r2017')
    tests.run('print',log_dir)
else
    tests.run()
end
exit
