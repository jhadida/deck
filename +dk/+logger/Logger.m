classdef Logger < handle
%
% Simple logging implementation, heavily inspired by:
%   https://github.com/optimizers/logging4matlab
%

    properties (Constant)
        
        LEVEL = struct( ...
            'all',      1, ...
            'trace',    2, ...
            'debug',    3, ...
            'info',     4, ...
            'warning',  5, ...
            'error',    6, ...
            'critical', 7, ...
            'off',      8 ...
        );
        
    end
    
    properties 
        fileLevel
        consoleLevel
        nodate
    end
    
    properties (SetAccess = private)
        name
        file
        datefmt
    end
    
    methods (Hidden, Static)
        function str = callerInfo()
            [ST,~] = dbstack();
            if length(ST) > 2
                name = ST(3).name;
                line = ST(3).line;
                str = sprintf( '%s:%d', name, line );
            else
                str = 'Console';
            end
        end
    end
    
    % -----------------------------------------------------------------------------------------
    % management method
    % -----------------------------------------------------------------------------------------
    methods
        
        function self = Logger(varargin)
            self.reset(varargin{:});
        end
        
        function reset(self,name,varargin)
            assert( ischar(name) && ~isempty(name), 'Name should be a string.' );
            arg = dk.obj.kwArgs(varargin{:});
            
            self.name = name;
            self.file = struct('path', arg.get('file',[]), 'id', -1);
            self.datefmt = arg.get('datefmt','yyyy-mm-dd HH:MM:SS.FFF');
            self.nodate = arg.get('nodate',false);
            
            % set log levels
            self.fileLevel = arg.get('flevel','info');
            self.consoleLevel = arg.get('clevel','info');
            
            % open file if any
            self.open();
        end
        
        function set.fileLevel(self,val)
            val = lower(val);
            assert( isfield(self.LEVEL,val), 'Invalid level.' );
            self.fileLevel = val;
        end
        
        function set.consoleLevel(self,val)
            val = lower(val);
            assert( isfield(self.LEVEL,val), 'Invalid level.' );
            self.consoleLevel = val;
        end
        
        function y = hasFile(self)
            y = ~isempty(self.file.path);
        end
        
        function y = isFileOpen(self)
            y = self.hasFile() && (self.file.id > -1);
        end
        
        function y = ignoreLogging(self)
            y = strcmp(self.fileLevel,'off') && strcmp(self.consoleLevel,'off');
        end
        
        function self = open(self,fpath)
            if nargin < 2
                fpath=self.file.path; 
            end
            self.close();
            if isempty(fpath)
                self.file.path = [];
                self.file.id = -1;
            else
                self.file.path = fpath;
                self.file.id = fopen(fpath,'a');
            end
        end
        
        function self = close(self)
            if self.isFileOpen()
                fclose(self.file.id);
                self.file.id = -1;
            end
        end
        
    end
    
    % -----------------------------------------------------------------------------------------
    % logging methods
    % -----------------------------------------------------------------------------------------
    methods
        
        function trace(self, varargin)
            if ~self.ignoreLogging()
                caller = self.callerInfo();
                self.write('t', caller, varargin{:});
            end
        end

        function debug(self, varargin)
            if ~self.ignoreLogging()
                caller = self.callerInfo();
                self.write('d', caller, varargin{:});
            end
        end

        function info(self, varargin)
            if ~self.ignoreLogging()
                caller = self.callerInfo();
                self.write('i', caller, varargin{:});
            end
        end

        function warn(self, varargin)
            if ~self.ignoreLogging()
                caller = self.callerInfo();
                self.write('w', caller, varargin{:});
            end
        end

        function error(self, varargin)
            if ~self.ignoreLogging()
                caller = self.callerInfo();
                self.write('e', caller, varargin{:});
            end
        end

        function critical(self, varargin)
            if ~self.ignoreLogging()
                caller = self.callerInfo();
                self.write('c', caller, varargin{:});
            end
        end
       
        function logline = write(self,level,caller,message,varargin)
            
            % determine level
            switch lower(level)
                case {'a','all'}
                    level = 'all';
                case {'t','trace'}
                    level = 'trace';
                case {'d','dbg','debug'}
                    level = 'debug';
                case {'i','info'}
                    level = 'info';
                case {'w','warn','warning'}
                    level = 'warning';
                case {'e','err','error'}
                    level = 'error';
                case {'c','critical'}
                    level = 'critical';
                otherwise
                    error( 'Unknown level: %s', level );
            end
            levelnum = self.LEVEL.(level);
            
            % build log line
            dstr = datestr( now(), self.datefmt );
            lstr = upper(level); 
            mstr = sprintf( message, varargin{:} );
            if self.nodate
                logline = sprintf( '%-8s [%s] %s\n', lstr, caller, mstr );
            else
                logline = sprintf( '%-25s %-8s [%s] %s\n', dstr, lstr, caller, mstr );
            end
            
            % write to console
            if self.LEVEL.(self.consoleLevel) <= levelnum
                if levelnum >= self.LEVEL.error
                    fprintf( 2, '%s', logline );
                else
                    fprintf( '%s', logline );
                end
            end
            
            % write to file
            if self.isFileOpen() && self.LEVEL.(self.fileLevel) <= levelnum
                fprintf( self.file.id, '%s', logline );
            end
            
        end
        
    end
    
end