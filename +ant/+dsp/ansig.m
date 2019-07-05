function [env,phi,frq] = ansig( ts )
%
% [env,phi,frq] = ansig( ts )
% 
% Compute analytic signal from input TimeSeries instance.
% The input ts should be arithmetically sampled.
% Outputs are three time-series.
%
% JH

    [env,phi,frq] = ant.ts.ansig( ts.vals, ts.fs(true) );
    env = ant.dsp.TimeSeries( ts.time, dk.bsx.add(env,ts.mean) );
    phi = ant.dsp.TimeSeries( ts.time, phi );
    frq = ant.dsp.TimeSeries( ts.time, frq );

end
