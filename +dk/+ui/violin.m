function dist = violin( data, varargin )
%
% dist = dk.ui.violin( data, Name, Value )
%
% Violin plot (similar to boxplot, but using ksdensity to plot distributions vertically).
%
% INPUT
%
%     data  Either a nxp matrix or a 1xp cell.
%             If a matrix, each column is a sample (ie rows are observations).
%             If a cell, each element is vectorised and considered as a 1-d sample.
%
%
%    Width  Width of each distribution in the final plot, typically <1 (default: 0.7).
%    Label  Cell-string array of label for each column (default: column numbers).
%             Numeric inputs are converted to string.
%    Range  Interval where distribution should be estimated (1x2 vector, default []).
%             By default, the interval is determined automatically by ksdensity.
%             Set the number of points with option NumPts
%  Support  Support of the distribution as a 1x2 interval or string (default: []).
%             See ksdensity for more information (warning: can have important effects).
%   Kernel  One of: 'normal', 'box', 'triangle', 'epanechnikov' (default: normal).
%   NumPts  Number of points to use for density estimation (default: 51).
%  Weights  nxp matrix or 1xp cell with weights for each point.
%    Theme  For now only the theme 'orange' is available.
%
% OUTPUT
%
%     dist  Structure with fields:
%             .x  Support of the density estimate
%             .y  Density estimate
%             .m  Median of the sample
%             .a  Mean of the sample
%
% See also: ksdensity
%
% JH

    opt = dk.obj.kwArgs(varargin{:});
    
    % number of columns
    if iscell(data)
        nd = numel(data);
    else
        nd = size(data,2);
    end
    assert( nd > 0, 'Empty dataset in input.' );

    % parse options
    opt_width = opt.get('width',0.7);
    opt_label = opt.get('label',1:nd);
    opt_theme = opt.get('theme','jh');
    opt_range = opt.get('range',[]);
    opt_kern  = opt.get('kernel','normal');
    opt_supp  = opt.get('support',[]);
    opt_npts  = opt.get('numpts',51);
    opt_wght  = opt.get('weights',[]);

    % convert label to string
    if isnumeric(opt_label)
        opt_label = dk.mapfun( @num2str, opt_label, false );
    end
    assert( iscellstr(opt_label), 'Labels should either be numeric or a cellstring.' );
    assert( numel(opt_label) == nd, 'There should be one label per column.' );
    
    % colors used for drawing
    colors = dk.clr.jh();
    switch lower(opt_theme)
        case 'orange'
            theme.box = hsv2rgb([30/360 1 0.9]); % orange
            theme.med = hsv2rgb([30/360 1 0.1]); % black
            theme.avg = hsv2rgb([200/360 1 0.9]/100); % blue
        case 'jh'
            theme.box = colors.tang; % orange
            theme.med = colors.dark; % black
            theme.avg = colors.sky; % blue
    end

    % process ksdensity options
    if isempty(opt_range)
        ksarg = { [], 'NumPoints', opt_npts, 'Kernel',opt_kern };
    else
        ksarg = { linspace( opt_range(1), opt_range(2), opt_npts ), 'Kernel', opt_kern };
    end
    if ~isempty(opt_supp)
        ksarg = [ ksarg, {'Support', opt_supp} ];
    end

    % compute and draw distributions
    dist = cell(1,nd);
    xtic = ceil(opt_width) * (0.5 + (0:nd-1));

    q99 = -Inf;
    q01 =  Inf;

    for i = 1:nd
        
        if ~isempty(opt_wght)
            w = getcol(opt_wght,i);
            %w = w / min(nonzeros(w));
            [dist{i},v] = density_estimation( getcol(data,i), [ ksarg, {'Weights', w} ] );
        else
            [dist{i},v] = density_estimation( getcol(data,i), ksarg );
        end
        plot_distribution( dist{i}, xtic(i), opt_width, theme );

        q99 = max( q99, prctile(v,99) );
        q01 = min( q01, prctile(v,1) );
    end

    % adjust y-axis limits
    q99 = 1.2*q99;
    q01 = 0.8*q01;

    % prevent drawing over, and set tick labels
    hold off; ylim([q01 q99]);
    set(gca,'xtick',xtic,'xticklabel',opt_label);
    if mean(cellfun( @length, opt_label )) > 5
        set(gca,'xticklabelrotation',55);
    end

    % concatenate distributions as a struct array
    dist = [dist{:}];

end

function c=getcol(x,k)
    if iscell(x)
        c = x{k}(:);
    else
        c = x(:,k);
    end
end

function [dist,v] = density_estimation( v, arg )

    [dist.y,dist.x] = ksdensity(v,arg{:});
    dist.m = median(v);
    dist.a = mean(v);

end

function h = plot_distribution( dist, loc, wid, col )

    x = (wid/2) * dist.y / max(dist.y);
    x = [ loc + x, loc - fliplr(x) ];
    y = [ dist.x, fliplr(dist.x) ];
    h.d = fill( x, y, col.box, 'EdgeColor', 'none' );
    hold on;

    mw = interp1( dist.x, dist.y, dist.m );
    mw = (wid/2) * mw / max(dist.y);
    
    % show the median
    h.m = plot( loc+mw*[-1,1], dist.m*[1,1], '-', 'Color', col.med, 'LineWidth', 2 );

    % show the average
    %h.a = plot( loc, dist.a, '+', 'Color', col.avg, 'MarkerSize', 7 );

end
