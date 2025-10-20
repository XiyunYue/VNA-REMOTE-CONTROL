function showFourWindows(vna)
    writeline(vna, "CALC:PAR:DEL:ALL");
    for w = 1:4
        writeline(vna, sprintf("DISP:WIND%d:STAT ON", w));
    end

    % 四个参数
    params = ["S11","S12","S21","S22"];
    for k = 1:4
        pname = sprintf("'%s_%d'", params(k), k);
        writeline(vna, "CALC1:PAR:DEF " + pname + "," + params(k));
        writeline(vna, sprintf("DISP:WIND%d:TRAC1:FEED %s", k, pname));
    end
end

