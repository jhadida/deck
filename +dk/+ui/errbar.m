function h = errbar( x, y, L, t, varargin )
%
% h = dk.ui.errbar( x, y, Ylength, Xwidth=[], varargin )
%
% Add error bars to the current 2d axes, centered at specified coord (x,y), 
%  and with specified length and tick-width.
%
%   -------    ^
%      |       |
%      * (x,y) | Ylength
%      |       |
%   -------    v
%   <----->
%      Xwidth
%
% o If x, y and Ylength are vectors, then multiple bars are plotted.
% o If Ylength is 2xN, then row1=LOWER bnd and row2=UPPER bound.
% o Xwidth should be SCALAR and is replicated for each bar.
% o If omitted or empty, Xwidth defaults to mean(diff(sort(x)))/4.
% o Additional inputs are forwarded to plot.
%
% JH
    
    n = numel(x);
    assert( numel(y)==n, 'x and y size mismatch.' );
    assert( any( numel(L) == n*[1,2] ), 'x and Ylength size mismatch.' );
    
    if numel(L) == 2*n
        assert( ismatrix(L) && any(size(L)==2), 'Ylength should be 2xN.' );
        if size(L,1) ~= 2, L = transpose(L); end 
    else
        L = dk.torow(L);
        L = [L; L];
    end
    
    if nargin < 4 || isempty(t)
        t = mean(diff(sort(x))) / 4;
    end
    assert( isscalar(t), 'Xwidth should be scalar.' );
    
    % make all vectors rows
    x = dk.torow(x);
    y = dk.torow(y);
    l = L(1,:);
    u = L(2,:);
    
    % make bars with ticks
    %
    %   1--3--2  ^
    %      |     |
    %      |     | L
    %      |     |
    %   6--4--5  v
    %   <----->
    %      t
    %
    x = [ x-t; x+t; x; x; x+t; x-t ];
    y = [ y+u; y+u; y+u; y-l; y-l; y-l ];
    h = gobjects(1,n);
    
    % draw bars
    hold on;
    for i = 1:n
        h(i) = plot( x(:,i), y(:,i), varargin{:} );
    end
    hold off;
    
end