% function [filename, baseName] = getExperimentInfo(foldername)
%     if nargin < 1 || isempty(foldername)
%         foldername = pwd;
%     end
% 
%     if ~exist(foldername, 'dir')
%         mkdir(foldername);
%     end
% 
%     prompt = {'测试对象:', '组名:', '第几次实验:', '备注:'};
%     dlgtitle = '实验信息输入';
%     dims = [1 50];
%     definput = {'', '', '', ''}; % 默认空
%     answer = inputdlg(prompt, dlgtitle, dims, definput);
% 
%     if isempty(answer)
%         filename = '';
%         return;
%     end
% 
%     testObject = strtrim(answer{1});
%     groupName  = strtrim(answer{2});
%     expNum     = strtrim(answer{3});
%     note       = strtrim(answer{4});
% 
%     baseName = sprintf('%s-%s-%s', testObject, groupName, expNum);
%     filename = fullfile(foldername, baseName); 
% 
%     if ~isempty(note)
%         filepath = filename + ".txt";
%         disp(filepath);
%         fid = fopen(filepath, 'w', 'n', 'UTF-8');
%         if fid == -1
%             error('can not build the file %s', filepath);
%         end
%         fprintf(fid, '%s\n', note);
%         fclose(fid);
%         fprintf('Already saved: %s\n', filepath);
%     end
% end
function [filefullname, baseName] = getExperimentInfo(foldername)
% GETEXPERIMENTINFO
% 交互式收集实验信息，并返回：
%   filefullname : 不带扩展名的完整路径（用于后续 + ".xlsx" / ".txt"）
%   baseName     : 基础文件名（不含路径与扩展名）
%
% 安全性/Robustness:
% - 任何情况下都给两个输出赋值（取消=返回 ''）
% - 跳过空字段，自动清理非法文件名字符
% - 备注（note）非空则写入同名 .txt（UTF-8），失败则 warning 而非 error

    % ---- 默认输出 / default outputs ----
    filefullname = '';
    baseName     = '';

    % ---- 输入目录兜底 / folder fallback ----
    if nargin < 1 || isempty(foldername)
        foldername = pwd;
    end
    if ~exist(foldername, 'dir')
        % 尝试创建，但失败也不致命
        try, mkdir(foldername); catch, end
    end

    % ---- 收集信息 / input dialog ----
    prompt   = {'测试对象 / Test object:', ...
                '组名 / Group:', ...
                '第几次实验 / Trial No.:', ...
                '备注 / Note:'};
    dlgtitle = '实验信息输入 / Experiment Info';
    dims     = [1 50];
    definput = {'', '', '', ''};
    answer   = inputdlg(prompt, dlgtitle, dims, definput);

    % 用户取消（answer = []），直接返回空输出（已赋值）
    if isempty(answer), return; end

    % ---- 清洗字段 / trim ----
    testObject = strtrim(answer{1});
    groupName  = strtrim(answer{2});
    expNum     = strtrim(answer{3});
    note       = strtrim(answer{4});

    % ---- 组装基础名（忽略空字段）/ join non-empty with '-' ----
    parts = {testObject, groupName, expNum};
    parts = parts(~cellfun(@isempty, parts));
    if isempty(parts)
        % 若全空：给个时间戳兜底
        baseName = datestr(now, 'yyyymmdd_HHMMSS');
    else
        baseName = strjoin(parts, '-');
    end

    % ---- 清理非法文件名字符 / sanitize filename ----
    % Windows/跨平台常见非法字符: \ / : * ? " < > | 以及控制符
    baseName = regexprep(baseName, '[\\/:*?"<>|]', '_');
    baseName = regexprep(baseName, '\s+', ' ');     % 多空格压缩
    baseName = strtrim(baseName);
    baseName = regexprep(baseName, '-{2,}', '-');   % 多连字符压缩

    % 再保险：全空再兜底
    if isempty(baseName)
        baseName = datestr(now, 'yyyymmdd_HHMMSS');
    end

    % ---- 组合无扩展名的完整路径 / build full path without ext ----
    filefullname = fullfile(foldername, baseName);

    % ---- 如备注非空，写入 .txt（UTF-8）/ write note ----
    if ~isempty(note)
        txtPath = filefullname + ".txt";
        fid = fopen(txtPath, 'w', 'n', 'UTF-8');
        if fid == -1
            warning('无法创建备注文件（%s）。Skipping note.', txtPath);
        else
            fprintf(fid, '%s\n', note);
            fclose(fid);
            fprintf('备注已保存 / Note saved: %s\n', txtPath);
        end
    end
end
