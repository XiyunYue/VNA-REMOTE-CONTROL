function [traceNames, freq] = GetTestPara(vna)
    writeline(vna, ":FORM:DATA REAL,64");
    writeline(vna, "CALC1:FORM MLOG");  
    writeline(vna, ":FORM:BORD SWAP");
    writeline(vna, "INIT;*WAI");
    f_start = str2double(writeread(vna, ":SENSe1:FREQuency:STARt?"));
    f_stop  = str2double(writeread(vna, ":SENSe1:FREQuency:STOP?"));
    n_pts   = str2double(writeread(vna, ":SENSe1:SWEep:POINts?"));
    freq    = linspace(f_start, f_stop, n_pts).';  % column vectorreq_str,","));
    cat = writeread(vna, "CALC1:PAR:CAT?");
    tok = strrep(strsplit(strtrim(cat), ','), '''', '');  % 去掉引号
    traceNames = tok(1:2:end);
end