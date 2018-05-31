% Controller
figure(123);clf
ShapeIn = uicontrol('style', 'popupmenu', 'string', 'Rectangle|Sphere|Cylinder', 'position', [0,0,70,20], 'callback', 'Controler_Helper');% edit box% dropdown
        ShapeInLabel =  uicontrol('style', 'text', 'string', 'Object', 'position', [0,20,70,20]);
        DimInLabel = uicontrol('style', 'text', 'string', 'Dim', 'position', [70,20,40,20]);
        
lIn = uicontrol('style', 'edit', 'string', '1', 'position', [110,0,30,20]);% edit box
wIn = uicontrol('style', 'edit', 'string', '1', 'position', [140,0,30,20]);% edit box
hIn = uicontrol('style', 'edit', 'string', '1', 'position', [170,0,30,20]);% edit box
        InLabel = uicontrol('style', 'text', 'string', 'L     W      H', 'position', [110,20,90,20]);
        
NumElectronIn = uicontrol('style', 'edit', 'string', '200', 'position', [200,0,40,20]);% edit box
        NumElectronInLabel = uicontrol('style', 'text', 'string', '#e', 'position', [200,20,40,20]);
        
StepsIn = uicontrol('style', 'edit', 'string', '200', 'position', [240,0,40,20]);% edit box
        StepsInLabel = uicontrol('style', 'text', 'string', 'Steps', 'position', [240,20,40,20]);
        
BetaIn = uicontrol('style', 'edit', 'string', '2e3', 'position', [280,0,50,20]);% edit box
        BetaInLabel = uicontrol('style', 'text', 'string', '\beta', 'position', [280,20,50,20]);
        
dtIn = uicontrol('style', 'edit', 'string', '1e-4', 'position', [330,0,50,20]);% edit box
        dtInLabel = uicontrol('style', 'text', 'string', 'dt', 'position', [330,20,50,20]);

Start =  uicontrol('style', 'pushbutton', 'string', 'Start', 'position', [0,200,30,20], 'callback', 'STOP = 0; Controler_Worker');% edit box
Stop =  uicontrol('style', 'pushbutton', 'string', 'Stop', 'position', [0,220,30,20], 'callback', 'STOP = 1;');% edit box
PlotIn = uicontrol('style', 'checkbox', 'string', 'Plot?', 'position', [0,240,50,20], 'value', 1);% edit box
ContinueIn = uicontrol('style', 'checkbox', 'string', 'Continue?', 'position', [0,260,90,20], 'value', 0);% edit box
MessagaIn = uicontrol('style', 'text', 'position', [0,400,90,20]);



Controler_Helper;
% Plot % drop down 

% damping % edit