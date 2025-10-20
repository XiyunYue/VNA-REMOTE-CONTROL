function errs = vna_read_errors(vna)
    % 返回 string 数组；若无错，返回空 []
    errs = strings(0,1);
    for k = 1:50
        writeline(vna,'SYST:ERR?');
        s = strtrim(readline(vna));
        if startsWith(s,'0,')
            break
        else
            errs(end+1) = s; %#ok<AGROW>
        end
    end
end
