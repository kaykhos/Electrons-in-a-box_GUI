clear all; load phys; 
NumElectron =200; % number of electron in simulation ON EACH OBJECT
Dim = 3; % Number of spatial dimentions used - to work in fewer dimentions, Box symeteric about zero
Steps = 10000; % number of steps to propogate simulation for
dt = 1e-4; % time step used in finite element method
R = 1*1e-0; % Radius of sphere
Box2 = [-1,1,-1,1,-1,1]*1e-0;% dimentions of the box two bounding the particles, same set up as 'axis'
Beta = 1e2; % include a damping term to take energy out of the system to converge to a steady state system first. 
Distance = [3,0,0]*1e-0; % distance the vector (center to center) cubes are appart (in x,y,z)
Box2 = Box2 + [Distance(1), Distance(1), Distance(2), Distance(2), Distance(3), Distance(3)];

Temp1 = linspace(0,2*pi,15);
Temp2 = linspace(0,pi,15);
[Temp1,Temp2] = meshgrid(Temp1, Temp2);
xP1 = R*cos(Temp1).*sin(Temp2);
yP1 = R*sin(Temp1).*sin(Temp2);
zP1 = R*cos(Temp2);


xP2 = [Box2(1), Box2(1), Box2(2), Box2(2), Box2(1), Box2(1), Box2(1), Box2(2), Box2(2), Box2(1), Box2(2), Box2(2), Box2(2), Box2(2), Box2(1), Box2(1)];
yP2 = [Box2(3), Box2(4), Box2(4), Box2(3), Box2(3), Box2(3), Box2(4), Box2(4), Box2(3), Box2(3), Box2(3), Box2(3), Box2(4), Box2(4), Box2(4), Box2(4)];
zP2 = [Box2(5), Box2(5), Box2(5), Box2(5), Box2(5), Box2(6), Box2(6), Box2(6), Box2(6), Box2(6), Box2(6), Box2(5), Box2(5), Box2(6), Box2(6), Box2(5)];



if Dim == 3
    rMat1 = 2*R*(rand(NumElectron,Dim)-.5);
    for jj = 1:NumElectron
        if sum(rMat1(jj,:).^2) > R^2
            while sum(rMat1(jj,:).^2) > R^2
                rMat1(jj,:) = 2*R*(rand(1,3)-.5);
            end
        end
    end
    rMat2 = [rand(NumElectron,1)*(Box2(2)-Box2(1)) + Box2(1),...% Define initial positions of cube
            rand(NumElectron,1)*(Box2(4)-Box2(3)) + Box2(3),...
            rand(NumElectron,1)*(Box2(6)-Box2(5)) + Box2(5)];
elseif Dim == 2 
    rMat1 = [rand(NumElectron,1)*(Box1(2)-Box1(1)) + Box1(1),...% Define initial positions
            rand(NumElectron,1)*(Box1(4)-Box1(3)) + Box1(3),...
            zeros(NumElectron,1)];
    rMat2 = [rand(NumElectron,1)*(Box1(2)-Box1(1)) + Box1(1),...% Define initial positions
            rand(NumElectron,1)*(Box1(4)-Box1(3)) + Box1(3),...
            zeros(NumElectron,1)];
    disp('Warning: 2D is not really meant to be used with with code, it might be buggy')
elseif Dim == 1
    rMat = [rand(NumElectron,1)*(Box1(2)-Box1(1)) + Box1(1), zeros(NumElectron,2)];
    disp('Warning: 1D is not really meant to be used with with code, it might be buggy')
end
vMat1 = zeros(NumElectron,3); % wlog may take initial velocity to be zero;
vMat2 = zeros(NumElectron,3); % wlog may take initial velocity to be zero;



figure(123)
set(gcf, 'Renderer', 'OpenGL');shg
tic
KE = zeros(1,Steps);
for jj = 1:Steps
    rMat = [rMat1; rMat2];% Append rMat1-2 together to calculate forces, but calculate forces seperatly. 
    x = rMat(:,1);    y = rMat(:,2);    z = rMat(:,3);
    x = meshgrid(x);    y = meshgrid(y);    z = meshgrid(z);
    dx = (x-x'); dy = (y-y'); dz = (z-z');
    rNM = sqrt(dx.^2 + dy.^2 + dz.^2) + eye(length(x(:,1)));
    fMat = qe^2./rNM/4/pi/epsilon0;
    rNew = zeros(NumElectron, 3);
    vNew = zeros(NumElectron, 3);
    for pp = 1:NumElectron
       
        Comp1 = [dx(:,pp)./rNM(:,pp),...
            dy(:,pp)./rNM(:,pp),...
            dz(:,pp)./rNM(:,pp)];
        Comp2 = [dx(:,NumElectron+pp)./rNM(:,NumElectron+pp),...
            dy(:,NumElectron+pp)./rNM(:,NumElectron+pp),...
            dz(:,NumElectron+pp)./rNM(:,NumElectron+pp)];
        
        ForceJJ1 = sum((fMat(:,pp)*ones(1,3)).*Comp1);
        ForceJJ2 = sum((fMat(:,NumElectron+pp)*ones(1,3)).*Comp2);
        
        rNew1(pp,:) = [(ForceJJ1(1)/me/Beta-vMat1(pp,1))/Beta*exp(-Beta*dt) + ForceJJ1(1)/me/Beta*dt  + rMat(pp,1) - (ForceJJ1(1)/me/Beta-vMat1(pp,1))/Beta,...
                      (ForceJJ1(2)/me/Beta-vMat1(pp,2))/Beta*exp(-Beta*dt) + ForceJJ1(2)/me/Beta*dt  + rMat(pp,2) - (ForceJJ1(2)/me/Beta-vMat1(pp,2))/Beta,... % For actual new vector we should add an + rMat(pp,1-2-3) to each line 
                      (ForceJJ1(3)/me/Beta-vMat1(pp,3))/Beta*exp(-Beta*dt) + ForceJJ1(3)/me/Beta*dt  + rMat(pp,3) - (ForceJJ1(3)/me/Beta-vMat1(pp,3))/Beta];
        vNew1(pp,:) = [-(ForceJJ1(1)/me/Beta-vMat1(pp,1))*exp(-Beta*dt) + ForceJJ1(1)/me/Beta,...
                      -(ForceJJ1(2)/me/Beta-vMat1(pp,2))*exp(-Beta*dt) + ForceJJ1(2)/me/Beta,...
                      -(ForceJJ1(3)/me/Beta-vMat1(pp,3))*exp(-Beta*dt) + ForceJJ1(3)/me/Beta];
                  
        rNew2(pp,:) = [(ForceJJ2(1)/me/Beta-vMat2(pp,1))/Beta*exp(-Beta*dt) + ForceJJ2(1)/me/Beta*dt  + rMat(pp+NumElectron,1) - (ForceJJ2(1)/me/Beta-vMat2(pp,1))/Beta,...
                      (ForceJJ2(2)/me/Beta-vMat2(pp,2))/Beta*exp(-Beta*dt) + ForceJJ2(2)/me/Beta*dt  + rMat(pp+NumElectron,2) - (ForceJJ2(2)/me/Beta-vMat2(pp,2))/Beta,... % For actual new vector we should add an + rMat(pp,1-2-3) to each line 
                      (ForceJJ2(3)/me/Beta-vMat2(pp,3))/Beta*exp(-Beta*dt) + ForceJJ2(3)/me/Beta*dt  + rMat(pp+NumElectron,3) - (ForceJJ2(3)/me/Beta-vMat2(pp,3))/Beta];
        vNew2(pp,:) = [-(ForceJJ2(1)/me/Beta-vMat2(pp,1))*exp(-Beta*dt) + ForceJJ2(1)/me/Beta,...
                      -(ForceJJ2(2)/me/Beta-vMat2(pp,2))*exp(-Beta*dt) + ForceJJ2(2)/me/Beta,...
                      -(ForceJJ2(3)/me/Beta-vMat2(pp,3))*exp(-Beta*dt) + ForceJJ2(3)/me/Beta];
    end

    rMat2 = rMat2 +  [(rNew2(:,1)-rMat2(:,1)).*sign(rNew2(:,1)-Box2(1)).*sign(Box2(2)-rNew2(:,1)),...
                    (rNew2(:,2)-rMat2(:,2)).*sign(rNew2(:,2)-Box2(3)).*sign(Box2(4)-rNew2(:,2)),...
                    (rNew2(:,3)-rMat2(:,3)).*sign(rNew2(:,3)-Box2(5)).*sign(Box2(6)-rNew2(:,3))]; 

    vMat2 = [(vNew2(:,1)-0).*sign(rNew2(:,1)-Box2(1)).*sign(Box2(2)-rNew2(:,1)),...
            (vNew2(:,2)-0).*sign(rNew2(:,2)-Box2(3)).*sign(Box2(4)-rNew2(:,2)),...
            (vNew2(:,3)-0).*sign(rNew2(:,3)-Box2(5)).*sign(Box2(6)-rNew2(:,3))]; 
    
    rMat1 = rMat1 +  (rNew1-rMat1).*(sign(R^2-(sum(rNew1'.*rNew1')'))*ones(1,3));

    vMat1 = vNew1.*(sign(R^2-(sum(rNew1'.*rNew1')'))*ones(1,3));         
        
        
        
    KE(jj) = sum(sum(([vMat1; vMat2]').^2))*me/2;

    cla
    %subplot(2,1,1);
    hold on; plot3(xP2, yP2, zP2, 'k'); mesh(xP1,yP1,zP1, 'facecolor', 'none'); colormap([0,0,0]); 
    plot3(rMat(:,1), rMat(:,2), rMat(:,3), 'd'); axis equal; box off; axis off; hold on
    
    xlabel([num2str(jj/Steps), '%']);
    %subplot(2,1,2);plot(KE);
    pause(0.01)
    
end
toc


