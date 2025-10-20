clear
close all
%% 连接
ip_address = '169.254.28.225';
address = "TCPIP0::169.254.28.225::5025::SOCKET";
try
    vna = visadev(address);
    disp("✅ VNA connect successfully");
catch ME
    warning("connect fail: %s", ME.message);
    clearvars -except address ip_address
    disp("clear all connection");
    vna = visadev(address);
    disp("✅ VNA connect successfully");
end

%% 设定
vna_clear_errors(vna);
foldername = datestr(now,'yyyymmdd');
folderfullname = fullfile("F:\research\matlab\Experiment\tltest\data", foldername);
if ~exist(folderfullname, 'dir')  
    mkdir(folderfullname);        
end


%%
configureTerminator(vna,"LF");
idn = writeread(vna,"*IDN?");
disp(idn) 
showFourWindows(vna);
test_time = set_sweep_ft(vna);
[traceNames, freq] = GetTestPara(vna);

%% 调试
% [filefullname, baseName] = getExperimentInfo(folderfullname);
% writeline(vna, "INIT;*WAI");
% pause(5); 
% SaveLocal(baseName, vna, foldername)
% T = ReadandSaveTable(vna, traceNames, freq);
% errs = vna_read_errors(vna);
% fprintf(2,"[VNA ERR this run]\n%s\n", strjoin(errs,newline));
% writetable(T, filefullname + ".xlsx"); 
% while true
%     [filefullname, baseName] = getExperimentInfo(folderfullname);
%     writeline(vna, "INIT;*WAI");
%     pause(5); 
%     SaveLocal(baseName, vna, foldername)
%     T = ReadandSaveTable(vna, traceNames, freq);
%     writetable(T, filefullname + ".xlsx");  
% end
while true
    [filefullname, baseName] = getExperimentInfo(folderfullname);
    
    % --- 如果用户点了取消 ---
    if isempty(filefullname) || isempty(baseName)
        disp("用户取消，退出循环。");
        break;
    end
    
    % --- 正常流程 ---
    writeline(vna, "INIT;*WAI");
    pause(5); 
    SaveLocal(baseName, vna, foldername)
    T = ReadandSaveTable(vna, traceNames, freq);
    writetable(T, filefullname + ".xlsx");  
end
disp('end');
clear vna
%% 清缓冲和错误
% flush(vna);
% writeline(vna,'*CLS');
