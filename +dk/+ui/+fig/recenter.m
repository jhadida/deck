function sc = recenter( f )
%
% Puts figure at the center of the screen and returns center coordinates.

    [~,hw,sn] = dk.ui.fig.position(f);
    sc = dk.ui.screen.centre(sn);
    wh = fliplr(hw);
    
    u = get(f,'units'); set(f,'units','pixels');
    set( f, 'position', [ sc-wh/2, wh ] );
    set(f,'units',u);
    
end