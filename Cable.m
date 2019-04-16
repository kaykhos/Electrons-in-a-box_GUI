load phys;
NumElectron =100; % number of electron in simulation
Dim = 3; % Number of spatial dimentions used = 3 for the cable 
Steps = 5000; % number of steps to propogate simulation for
dt = 1e-4; % time step used in finite element method
R = 1; % radius of 
L = 1; % length of sphere
rMat = [2*R*(rand(NumElectron,2)-.5), rand(NumElectron,1)*L-L/2];
for jj = 1:NumElectron
        if sum(rMat(jj,1:2).^2) > R^2
            while sum(rMat(jj,1:2).^2) > R^2
                rMat(jj,1:2) = 2*R*(rand(1,2)-.5);
            end
        end
end
vMat = zeros(NumElectron,3); % wlog may take initial velocity to be zero;
Beta = 2000; % include a damping term to take energy out of the system to converge to a steady state system first. 
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
        Comp = [dx(:,pp)./rNM(:,pp),...
            dy(:,pp)./rNM(:,pp),...
            dz(:,pp)./rNM(:,pp)];
        ForceJJ = sum((fMat(:,pp)*ones(1,3)).*Comp);
        rNew(pp,:) = (ForceJJ/me/Beta-vMat(pp,:))/Beta*exp(-Beta*dt) + ForceJJ/me/Beta*dt + rMat(pp,:) - (ForceJJ/me/Beta-vMat(pp,:))/Beta;
        vNew(pp,:) = -(ForceJJ/me/Beta-vMat(pp,:))*exp(-Beta*dt) + ForceJJ/me/Beta;
    end
    rMat = rMat +  [(rNew(:,1:2)-rMat(:,1:2)).*(sign(R^2-(sum(rNew(:,1:2)'.*rNew(:,1:2)')'))  *ones(1,2)),...
                    (rNew(:,3)-rMat(:,3)).*sign(rNew(:,3)-L/2).*sign(L/2-rNew(:,3))]; 
    vMat = [vNew(:,1:2).*(sign(R^2-(sum(rNew(:,1:2)'.*rNew(:,1:2)')'))*ones(1,2)),...
            (vNew(:,3)-0).*sign(rNew(:,3)-L/2).*sign(L/2-rNew(:,3))]; 
    KE(jj) = sum(sum((vMat').^2))*me/2;
    cla
    %subplot(2,1,1);
    plot3(rMat(:,1), rMat(:,2), rMat(:,3), 'd'); axis equal; campos([ -2.97110609368495  -0.07752562951146   0.00014188227906]);
    xlabel([num2str(jj/Steps), '%']);
    %subplot(2,1,2);plot(KE);
    pause(0.01)
end
toc


