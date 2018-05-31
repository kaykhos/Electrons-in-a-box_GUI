if get(ShapeIn, 'value') == 1
    DimIn = uicontrol('style', 'popupmenu', 'string', '1D|2D|3D', 'position', [70,0,40,20], 'value', 3);% dropdown
    set(lIn, 'string', '1');
    set(wIn, 'string', '1');    set(wIn, 'style', 'edit');
    set(hIn, 'string', '1');    set(hIn, 'style', 'edit');
    set(InLabel, 'string', 'L     W      H');
elseif get(ShapeIn, 'value') == 2
    DimIn = uicontrol('style', 'popupmenu', 'string', '|2D|3D', 'position', [70,0,40,20], 'value', 3);% dropdown
    set(lIn, 'string', '1');
    set(wIn, 'style', 'text');
    set(hIn, 'style', 'text');
    set(InLabel, 'string', 'R     -      -');
elseif get(ShapeIn, 'value') == 3
        DimIn = uicontrol('style', 'popupmenu', 'string', '||3D', 'position', [70,0,40,20], 'value', 3);% dropdown
        set(lIn, 'string', '1');
        set(wIn, 'string', '.5'); set(wIn, 'style', 'edit');
        set(hIn, 'style', 'text');
        set(InLabel, 'string', 'L     R      -');
end