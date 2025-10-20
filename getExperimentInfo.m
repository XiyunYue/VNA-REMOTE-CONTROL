function [filefullname, baseName] = getExperimentInfo(foldername)
% GETEXPERIMENTINFO
% Collects experiment information via dialog and returns:
%   filefullname : full path without extension (for later + ".xlsx" / ".txt")
%   baseName     : base filename (without path or extension)
%
% Robustness:
% - Always returns valid outputs ('' if cancelled)
% - Sanitizes illegal filename characters
% - Writes note (.txt) in UTF-8 if provided

    filefullname = '';
    baseName     = '';

    if nargin < 1 || isempty(foldername)
        foldername = pwd;
    end
    if ~exist(foldername, 'dir')
        try, mkdir(foldername); catch, end
    end

    prompt   = {'Test object:', 'Group name:', 'Trial number:', 'Note:'};
    dlgtitle = 'Experiment Information Input';
    dims     = [1 50];
    definput = {'', '', '', ''};
    answer   = inputdlg(prompt, dlgtitle, dims, definput);

    if isempty(answer), return; end

    testObject = strtrim(answer{1});
    groupName  = strtrim(answer{2});
    expNum     = strtrim(answer{3});
    note       = strtrim(answer{4});

    parts = {testObject, groupName, expNum};
    parts = parts(~cellfun(@isempty, parts));
    if isempty(parts)
        baseName = datestr(now, 'yyyymmdd_HHMMSS');
    else
        baseName = strjoin(parts, '-');
    end

    baseName = regexprep(baseName, '[\\/:*?"<>|]', '_');
    baseName = regexprep(baseName, '\s+', ' ');
    baseName = strtrim(baseName);
    baseName = regexprep(baseName, '-{2,}', '-');
    if isempty(baseName)
        baseName = datestr(now, 'yyyymmdd_HHMMSS');
    end

    filefullname = fullfile(foldername, baseName);

    if ~isempty(note)
        txtPath = filefullname + ".txt";
        fid = fopen(txtPath, 'w', 'n', 'UTF-8');
        if fid == -1
            warning('Unable to create note file: %s. Skipping note.', txtPath);
        else
            fprintf(fid, '%s\n', note);
            fclose(fid);
            fprintf('Note saved: %s\n', txtPath);
        end
    end
end

