function val = assert( varargin )
%
% val = dk.assert( condition, fmt, varargin )
% val = dk.assert( channel, condition, fmt, varargin )
%
% Default channel is 'error'.
% Returns true if the assertion passes, false otherwise.
%
% JH

    validE = {'e', 'err', 'error'};
    validW = {'w', 'warn', 'warning'};
    validI = {'i', 'info'};
    validD = {'d', 'dbg','debug'};

    arg1 = varargin{1};
    if ischar(arg1) && ismember(lower(arg1),[validE validW validI validD])
        chan = lower(arg1);
        cond = varargin{2};
        args = varargin(3:end);
    else
        chan = 'err';
        cond = arg1;
        args = varargin(2:end);
    end

    val = all(logical(cond));
    if ~val
        switch chan
            case validE
                error( args{:} );
            case validW
                dk.warn( args{:} );
            case validI
                dk.info( args{:} );
            case validD
                dk.debug( args{:} );
            otherwise
                error('[dk.assert] That should never happen.');
        end
    end
    
end
