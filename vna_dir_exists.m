function tf = vna_dir_exists(vna, vnaPath)
    vnaPath = string(vnaPath);
    if vnaPath(end) ~= '\', vnaPath = vnaPath + "\"; end
    try
        writeline(vna, "MMEM:CAT? """ + vnaPath + "*""");  % ← 带 * 很关键
        txt = readline(vna);
        tf = ~isempty(txt);
    catch
        tf = false;
    end
end
