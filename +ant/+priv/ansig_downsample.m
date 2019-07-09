function varargout = ansig_downsample( varargin )
%
% [time,mag,phi] = ant.priv.ansig_downsample( time, mag, phi, fs )
% [time,vals] = ant.priv.ansig_downsample( time, vals, fs )
%
% Downsample the magnitude and phase of any time-resolved spectral signal.
% We tested multiple methods for precision and found that (see jh.test.analytic_resample) using
% sliding-averages with hamming window offered the best compromise between accuracy and speed.
%
% JH

    fun = @ant.ts.downsample;
    switch nargin
        case 3 % complex input
            time = varargin{1};
            fs   = varargin{3};
            assert( ~isreal(varargin{2}), 'Expected a complex-valued time-series.' );
            
            [mag,outT] = fun( abs(varargin{2}), time, fs );
            phi = angle(varargin{3});
            cp = fun( cos(phi), time, fs );
            sp = fun( sin(phi), time, fs );
            
            varargout = {outT,mag.*(cp + 1i*sp)};
            
        case 4
            time = varargin{1};
            fs   = varargin{4};
            
            [mag,outT] = fun( varargin{2}, time, fs );
            cp = fun( cos(varargin{3}), time, fs );
            sp = fun( sin(varargin{3}), time, fs );
            
            varargout = {outT,mag,atan2(sp,cp)};
    end
    
end
