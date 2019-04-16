load phys;
NumElectron = 200; % number of electron in simulation
Dim = 3; % Number of spatial dimentions used
Steps = 10000; % number of steps to propogate simulation for
dt = 8e-5; % time step used in finite element method
R = 1; % radius of sphere




if Dim == 3
    rMat = 2*R*(rand(NumElectron,Dim)-.5);
    for jj = 1:NumElectron
        if sum(rMat(jj,:).^2) > R^2
            while sum(rMat(jj,:).^2) > R^2
                rMat(jj,:) = 2*R*(rand(1,3)-.5);
            end
        end
    end
elseif Dim == 2 
    rMat = [2*R*(rand(NumElectron,Dim)-.5),zeros(NumElectron,1)];
    for jj = 1:NumElectron
        if sum(rMat(jj,:).^2) > R^2
            while sum(rMat(jj,:).^2) > R^2
                rMat(jj,:) = [2*R*(rand(1,2)-.5),0];
            end
        end
    end
end
vMat = zeros(NumElectron,3); % wlog may take initial velocity to be zero;
Beta = 1000; % include a damping term to take energy out of the system to converge to a steady state system first. 



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
    rMat = rMat +  (rNew-rMat).*(sign(R^2-(sum(rNew'.*rNew')'))*ones(1,3));

    vMat = vNew.*(sign(R^2-(sum(rNew'.*rNew')'))*ones(1,3)); 
    KE(jj) = sum(sum((vMat').^2))*me/2;
%     if jj == 10000
%         break
%     end
    %vMat = vNew;rMat = rNew;
    clf
    %subplot(2,1,1);
    plot3(rMat(:,1), rMat(:,2), rMat(:,3), 'd'); axis equal;  hold on
    xlabel([num2str(jj/Steps), '%']);
    %subplot(2,1,2);plot(KE);
    pause(.001)
    %ans = input('Count?');
    
end
toc
