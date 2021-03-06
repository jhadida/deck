function y = struct( x, fields, num )
%
% y = dk.is.struct( x, fields={}, num=1 )
% 
% Checks whether input is a structure with specified fields.
% Set num to an integer > 0 to accept struct-arrays of specified size only.
% Set num to 0 in order to accept struct-arrays of any size (incl. empty).
% 
% fields can be a string or a cell of strings.
% If fields is empty, then fields are not checked.
%
% LEGACY:
%   It is also possible, but discouraged, to call:
%       dk.is.struct( x, fields, true )     scalar-struct
%       dk.is.struct( x, fields, false )    struct-array
%
% JH

    if nargin < 2, fields = {}; end
    if nargin < 3, num = 1; end

    y = isstruct(x);
    
    if ~isempty(fields)
        y = y && all(isfield(x,fields));
    end
    
    if num > 0
        y = y && numel(x)==num;
    end
    
end