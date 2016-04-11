function [x,y,ax,b] = ginput(n)
%
% Ginput that also returns the axes in which the selection was made.

    if nargin < 1, n=1; end

    x  = zeros(n,1);
    y  = zeros(n,1);
    b  = cell(n,1);
    ax = cell(n,1);
    
    for i = 1:n
        [x(i), y(i), b{i}] = ginput(1);
        ax{i} = gca;
    end 
    
    if n == 1
        b = b{1};
        ax = ax{1};
    end
    
end
