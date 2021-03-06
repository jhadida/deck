function s = rstrip( s, chars )
%
% s = dk.str.rstrip( s, chars='' )
%
% Remove specified trailing characters.
%
%  INPUTS
%   s        the string to process
%   chars    the list of characters to remove, defaults to ''
%
% JH

    if nargin < 2, chars = '\s'; end

    s = regexp( s, ['^(.*?)[' chars ']*$'], 'tokens', 'once' );
    s = s{1};

end
