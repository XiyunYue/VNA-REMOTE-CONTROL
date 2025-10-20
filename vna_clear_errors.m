function vna_clear_errors(vna)
    % 可选：同时清事件寄存器
    writeline(vna,'*CLS');  

    % 把系统错误队列读到 0,"No error" 为止
    for k = 1:50
        writeline(vna,'SYST:ERR?');
        s = strtrim(readline(vna));
        if startsWith(s,'0,')
            break
        end
    end
end
