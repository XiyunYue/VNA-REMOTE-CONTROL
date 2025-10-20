function T = ReadandSaveTable(vna, traceNames, freq)
    T = table(freq, 'VariableNames', {'Frequency_Hz'});
    want = {'S11', 'S12', 'S21', 'S22'};
    for k = 1: 4
        writeline(vna, sprintf("CALC1:PAR:SEL '%s'", traceNames{k}));
        writeline(vna, "CALC1:DATA? SDATA");
        pause(2);
        d = readbinblock(vna, "double");
        z = d(1:2:end) + 1i*d(2:2:end);
        mag_dB = 20*log10(abs(z));
        T{:, want(k)}  = mag_dB(:);
    end
end