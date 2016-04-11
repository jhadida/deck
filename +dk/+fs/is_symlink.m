function [yes,target] = is_symlink( name )
%
% Check whether the input name is an existing symbolic link (UNIX only).
%
% Contact: jhadida [at] fmrib.ox.ac.uk
    
    % Remove trailing separators for directories
    name = dk.string.rstrip( name, filesep );
    
    % Check for link
    s = unix(sprintf('test -L "%s"',name));
    yes = (s == 0);
    
    % Find target
    if yes
        target = strtrim(dk.fs.realpath(name));
    else
        target = name;
    end
    
end
