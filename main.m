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
folderPath = input('Please enter the folder path to save data: ', 's');
folderfullname = fullfile(folderPath, foldername);
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
while true
    [filefullname, baseName] = getExperimentInfo(folderfullname);
    if isempty(filefullname) || isempty(baseName)
        disp("Cancel");
        break;
    end
    writeline(vna, "INIT;*WAI");
    pause(5); 
    T = ReadandSaveTable(vna, traceNames, freq);
    writetable(T, filefullname + ".xlsx");  
end
disp('end');
clear vna

