function usbRoot = vna_probe_usb(vna)
% 返回第一个可访问的 USB 盘符（"D:\" / "E:\" / "F:\"）；找不到返回 ""。
    vna.Timeout = max(vna.Timeout, 15);
    usbRoot = "";

    candidates = ["D:\","E:\","F:\"];
    for root = candidates
        try
            % 方式1：带 * 列目录（很多固件更喜欢这种）
            cmd = "MMEM:CAT? """ + root + "*""";   % -> MMEM:CAT? "D:\*"
            writeline(vna, cmd);
            txt = readline(vna);
            if ~isempty(txt)
                usbRoot = root;
                return
            end
        catch
            % 方式2（备选）：先切目录，再列当前目录
            try
                writeline(vna, "MMEM:CDIR """ + root + """");
                writeline(vna, "MMEM:CAT?");
                txt = readline(vna);
                if ~isempty(txt)
                    usbRoot = root;
                    return
                end
            catch
                % 该 root 不可用，继续下一个
            end
        end
    end
end

