load phys;
NumElectron =300; % number of electron in simulation
Dim = 3; % Number of spatial dimentions used - to work in fewer dimentions, Box symeteric about zero
Steps = 100; % number of steps to propogate simulation for
dt = 1e-5; % time step used in finite element method
Box = [-1,1,-1,1,-1,1]*1e-1; % dimentions of the box bounding the particles, same set up as 'axis'


xP = [Box(1), Box(1), Box(2), Box(2), Box(1), Box(1), Box(1), Box(2), Box(2), Box(1), Box(2), Box(2), Box(2), Box(2), Box(1), Box(1)];
yP = [Box(3), Box(4), Box(4), Box(3), Box(3), Box(3), Box(4), Box(4), Box(3), Box(3), Box(3), Box(3), Box(4), Box(4), Box(4), Box(4)];
zP = [Box(5), Box(5), Box(5), Box(5), Box(5), Box(6), Box(6), Box(6), Box(6), Box(6), Box(6), Box(5), Box(5), Box(6), Box(6), Box(5)];



if Dim == 3
    rMat = [rand(NumElectron,1)*(Box(2)-Box(1)) + Box(1),...% Define initial positions
            rand(NumElectron,1)*(Box(4)-Box(3)) + Box(3),...
            rand(NumElectron,1)*(Box(6)-Box(5)) + Box(5)];
elseif Dim == 2 
    rMat = [rand(NumElectron,1)*(Box(2)-Box(1)) + Box(1),...% Define initial positions
            rand(NumElectron,1)*(Box(4)-Box(3)) + Box(3),...
            zeros(NumElectron,1)];
elseif Dim == 1
    rMat = [rand(NumElectron,1)*(Box(2)-Box(1)) + Box(1), zeros(NumElectron,2)];
end
vMat = zeros(NumElectron,3); % wlog may take initial velocity to be zero;
Beta = 1e4; % include a damping term to take energy out of the system to converge to a steady state system first. 



figure(123);shg
tic
KE = zeros(1,Steps);
for jj = 1:Steps
    x = rMat(:,1);    y = rMat(:,2);    z = rMat(:,3);
    x = meshgrid(x);    y = meshgrid(y);    z = meshgrid(z);
    dx = (x-x'); dy = (y-y'); dz = (z-z');
    rNM = sqrt(dx.^2 + dy.^2 + dz.^2);
    rNM =rNM+eye(length(rNM(:,1)));
    fMat = qe^2./rNM/4/pi/epsilon0;
    rNew = zeros(NumElectron, 3);
    vNew = zeros(NumElectron, 3);
    for pp = 1:NumElectron
        %fMat(pp,pp) = 0;
        %rNM(pp,pp) = 1;
        Comp = [dx(:,pp)./rNM(:,pp),...
            dy(:,pp)./rNM(:,pp),...
            dz(:,pp)./rNM(:,pp)];
        ForceJJ = sum((fMat(:,pp)*ones(1,3)).*Comp);
        rNew(pp,:) = (ForceJJ/me/Beta-vMat(pp,:))/Beta*exp(-Beta*dt) + ForceJJ/me/Beta*dt + rMat(pp,:) - (ForceJJ/me/Beta-vMat(pp,:))/Beta;
        vNew(pp,:) = -(ForceJJ/me/Beta-vMat(pp,:))*exp(-Beta*dt) + ForceJJ/me/Beta;
    end
    rMat = rMat +  [(rNew(:,1)-rMat(:,1)).*sign(rNew(:,1)-Box(1)).*sign(Box(2)-rNew(:,1)),...
                    (rNew(:,2)-rMat(:,2)).*sign(rNew(:,2)-Box(3)).*sign(Box(4)-rNew(:,2)),...
                    (rNew(:,3)-rMat(:,3)).*sign(rNew(:,3)-Box(5)).*sign(Box(6)-rNew(:,3))]; 

    vMat = [(vNew(:,1)-0).*sign(rNew(:,1)-Box(1)).*sign(Box(2)-rNew(:,1)),...
            (vNew(:,2)-0).*sign(rNew(:,2)-Box(3)).*sign(Box(4)-rNew(:,2)),...
            (vNew(:,3)-0).*sign(rNew(:,3)-Box(5)).*sign(Box(6)-rNew(:,3))]; 
    KE(jj) = sum(sum((vMat').^2))*me/2;

    clf
    subplot(2,1,1);
    plot3(xP,yP,zP); hold on
    plot3(rMat(:,1), rMat(:,2), rMat(:,3), 'd'); axis equal; box off; axis off; hold on
    
    xlabel([num2str(jj/Steps), '%']);
    subplot(2,1,2);plot(KE);
    pause(0.01)
    
end
toc













%         rNew(pp,:) = [(ForceJJ(1)/me/Beta-vMat(pp,1))/Beta*exp(-Beta*dt) + ForceJJ(1)/me/Beta*dt  + rMat(pp,1) - (ForceJJ(1)/me/Beta-vMat(pp,1))/Beta,...
%                       (ForceJJ(2)/me/Beta-vMat(pp,2))/Beta*exp(-Beta*dt) + ForceJJ(2)/me/Beta*dt  + rMat(pp,2) - (ForceJJ(2)/me/Beta-vMat(pp,2))/Beta,... % For actual new vector we should add an + rMat(pp,1-2-3) to each line 
%                       (ForceJJ(3)/me/Beta-vMat(pp,3))/Beta*exp(-Beta*dt) + ForceJJ(3)/me/Beta*dt  + rMat(pp,3) - (ForceJJ(3)/me/Beta-vMat(pp,3))/Beta];



%         vNew(pp,:) = [-(ForceJJ(1)/me/Beta-vMat(pp,1))*exp(-Beta*dt) + ForceJJ(1)/me/Beta,...
%                       -(ForceJJ(2)/me/Beta-vMat(pp,2))*exp(-Beta*dt) + ForceJJ(2)/me/Beta,...
%                       -(ForceJJ(3)/me/Beta-vMat(pp,3))*exp(-Beta*dt) + ForceJJ(3)/me/Beta];

