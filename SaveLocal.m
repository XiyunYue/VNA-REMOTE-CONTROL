function SaveLocal(baseName, vna, foldername)
    PathName = "D:\tltest\" + foldername;;
    destFile =  PathName + "\" + baseName + ".csv";
    vna.Timeout = 15; 
    pause(10); 
    % 存储 Channel 1 的所有 Trace
    writeline(vna, sprintf('MMEM:STOR:TRAC:CHAN 1, "%s"', destFile));
    pause(10); 
    % 等待完成
    opc = str2double(writeread(vna,'*OPC?'));
end