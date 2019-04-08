function out = getopt( arg, varargin )
%
% out = dk.getopt( args, varargin )
%
% Simple script to extract named options with defaults.
%
% NOTE:
%   Option names are case-sensitive
%   Duplicate input options are fine (overwrite left)
%   Duplicate defaults cause an error
%
% EXAMPLE:
%
%   function [...] = foo( a, b, c, varargin )
%
%       opt = dk.getopt( varargin, 'alpha', 0.5 );
%       disp( opt.alpha );
%
%
% See also: dk.obj.kwArgs
% 
% JH

    out = dk.c2s( varargin );
    arg = dk.unwrap(arg);
    n = numel(arg);
    if n == 1
        assert( dk.is.struct(arg), 'Scalar input should be a struct.' );
        out = dk.struct.merge( out, arg );
    else
        assert( dk.is.even(n), 'Input args should be key/value pairs.' );
        for i = 1:2:n
            out.(arg{i}) = arg{i+1};
        end
    end

end