load phys; % load physical constants from .mat file
NumElectron = str2num(get(NumElectronIn, 'string')); % number of electron in simulation
Dim = get(DimIn, 'value'); % Number of spatial dimentions used - to work in fewer dimentions, Box symeteric about zero
Steps = str2num(get(StepsIn, 'string')); % number of steps to propogate simulation for
dt = str2num(get(dtIn, 'string')); % time step used in finite element method
shape = get(ShapeIn, 'value'); % which shape is to be simulated
Beta = str2num(get(BetaIn, 'string')); % include a damping term to take energy out of the system to converge to a steady state system first. 
set(MessagaIn, 'string', 'Working'); % let the user know the program is running
if shape == 1 % Means the shape is a cube
    shape = 'C'; % Set shape to string to be used later 
    w = str2num(get(wIn, 'string')); % set width
    h = str2num(get(hIn, 'string')); % set height
    l = str2num(get(lIn, 'string')); % set length
    Box = [-l/2,l/2,-w/2,w/2,-h/2,h/2]*1e-0; % dimentions of the box bounding the particles, same set up as 'axis'
elseif shape == 2
    shape = 'S';
    R = str2num(get(lIn, 'string')); % set radius
elseif shape == 3
    shape = 'W';
    R = str2num(get(wIn, 'string')); % set radius
    L = str2num(get(lIn, 'string')); % set length
end


% use this paramartisation for plotting
xP = [Box(1), Box(1), Box(2), Box(2), Box(1), Box(1), Box(1), Box(2), Box(2), Box(1), Box(2), Box(2), Box(2), Box(2), Box(1), Box(1)];
yP = [Box(3), Box(4), Box(4), Box(3), Box(3), Box(3), Box(4), Box(4), Box(3), Box(3), Box(3), Box(3), Box(4), Box(4), Box(4), Box(4)];
zP = [Box(5), Box(5), Box(5), Box(5), Box(5), Box(6), Box(6), Box(6), Box(6), Box(6), Box(6), Box(5), Box(5), Box(6), Box(6), Box(5)];

if get(ContinueIn, 'value') == 0
    if shape == 'C' % if this is a cube, 
        if Dim == 3 % in 3D
            rMat = [rand(NumElectron,1)*(Box(2)-Box(1)) + Box(1),...% Define initial positions
                    rand(NumElectron,1)*(Box(4)-Box(3)) + Box(3),...
                    rand(NumElectron,1)*(Box(6)-Box(5)) + Box(5)];
        elseif Dim == 2 % in 2D
            rMat = [rand(NumElectron,1)*(Box(2)-Box(1)) + Box(1),...% Define initial positions
                    rand(NumElectron,1)*(Box(4)-Box(3)) + Box(3),...
                    zeros(NumElectron,1)];
        elseif Dim == 1 % in 1D
            rMat = [rand(NumElectron,1)*(Box(2)-Box(1)) + Box(1), zeros(NumElectron,2)];% Define initial positions
        end
    elseif shape == 'S' % if this is a sphere, 
        if Dim == 3 % in 3D
            rMat = 2*R*(rand(NumElectron,Dim)-.5); % define an initial condition
            for jj = 1:NumElectron % check to see if the electron is outside the bound
                if sum(rMat(jj,:).^2) > R^2 % if it is outside the sphere
                    while sum(rMat(jj,:).^2) > R^2 % keep itterating untill the electron goes within the bound
                        rMat(jj,:) = 2*R*(rand(1,3)-.5); % 
                    end
                end
            end
        elseif Dim == 2 % in 2D
            rMat = [2*R*(rand(NumElectron,Dim)-.5),zeros(NumElectron,1)];% define an initial condition
            for jj = 1:NumElectron % itterate as before
                if sum(rMat(jj,:).^2) > R^2
                    while sum(rMat(jj,:).^2) > R^2
                        rMat(jj,:) = [2*R*(rand(1,2)-.5),0];
                    end
                end
            end
        end
    elseif shape == 'W' % if we want cylinder
        rMat = [2*R*(rand(NumElectron,2)-.5), rand(NumElectron,1)*L-L/2]; % define ic's
        for jj = 1:NumElectron % itterate as before (accept only in x-yD)
                if sum(rMat(jj,1:2).^2) > R^2
                    while sum(rMat(jj,1:2).^2) > R^2
                        rMat(jj,1:2) = 2*R*(rand(1,2)-.5);
                    end
                end
        end
    end
end

vMat = zeros(NumElectron,3); % wlog may take initial velocity to be zero;
figure(123);shg
tic % keep track of time (asthetic purposes)
KE = zeros(1,Steps);
for jj = 1:Steps % for each step
    if STOP == 0 % check to see if the user wants process terminated
    x = rMat(:,1);    y = rMat(:,2);    z = rMat(:,3); % get x,y,z positions
    x = meshgrid(x);    y = meshgrid(y);    z = meshgrid(z); % meshgrid these into matrices
    dx = (x-x'); dy = (y-y'); dz = (z-z'); % find signed distances between each electron in each dimention
    % find euclidian distance between each electron, Set the diagonals to
    % one so we dont devide be zero in the next step. (it will cancal out later)
    rNM = sqrt(dx.^2 + dy.^2 + dz.^2)+ eye(length(dx(:,1))); 
    fMat = qe^2./rNM/4/pi/epsilon0; % find force between each electron
    rNew = zeros(NumElectron, 3); % initilze the new position matrix
    vNew = zeros(NumElectron, 3); % initilze the new velocity matrix
    for pp = 1:NumElectron % for each electron
        Comp = [dx(:,pp)./rNM(:,pp),...
            dy(:,pp)./rNM(:,pp),...
            dz(:,pp)./rNM(:,pp)]; % find unit vecrots from this electron from every other electron
        ForceJJ = sum((fMat(:,pp)*ones(1,3)).*Comp); % vector sum the force in each component
        rNew(pp,:) = (ForceJJ/me/Beta-vMat(pp,:))/Beta*exp(-Beta*dt) + ...
            ForceJJ/me/Beta*dt + rMat(pp,:) - (ForceJJ/me/Beta-vMat(pp,:))/Beta; % update new position
        vNew(pp,:) = -(ForceJJ/me/Beta-vMat(pp,:))*exp(-Beta*dt) + ForceJJ/me/Beta; % update velocity
    end
    if shape == 'C'; % conditionaly apply BC's (as discussed in the report)
        rMat = rMat +  [(rNew(:,1)-rMat(:,1)).*sign(rNew(:,1)-Box(1)).*sign(Box(2)-rNew(:,1)),...
                        (rNew(:,2)-rMat(:,2)).*sign(rNew(:,2)-Box(3)).*sign(Box(4)-rNew(:,2)),...
                        (rNew(:,3)-rMat(:,3)).*sign(rNew(:,3)-Box(5)).*sign(Box(6)-rNew(:,3))]; 
        vMat = [(vNew(:,1)-0).*(sign(rNew(:,1)-Box(1)).*sign(Box(2)-rNew(:,1))+1)/2,...
                (vNew(:,2)-0).*(sign(rNew(:,2)-Box(3)).*sign(Box(4)-rNew(:,2))+1)/2,...
                (vNew(:,3)-0).*(sign(rNew(:,3)-Box(5)).*sign(Box(6)-rNew(:,3))+1)/2]; 
    elseif shape == 'S'
            rMat = rMat +  (rNew-rMat).*(sign(R^2-(sum(rNew'.*rNew')'))*ones(1,3));
            vMat = vNew.*((sign(R^2-(sum(rNew'.*rNew')'))*ones(1,3))+1)/2;% (sign(R^2-(sum(rNew'.*rNew')'))*ones(1,3))
            %vNew.*((sign(R^2-(sum(rNew'.*rNew')'))*ones(1,3))+1)/2
    elseif shape == 'W'
            rMat = rMat +  [(rNew(:,1:2)-rMat(:,1:2)).*(sign(R^2-(sum(rNew(:,1:2)'.*rNew(:,1:2)')'))  *ones(1,2)),...
                    (rNew(:,3)-rMat(:,3)).*sign(rNew(:,3)+L/2).*sign(L/2-rNew(:,3))]; 
            vMat = [vNew(:,1:2).*((sign(R^2-(sum(rNew(:,1:2)'.*rNew(:,1:2)')'))*ones(1,2))+1)/2,...
                    (vNew(:,3)-0).*(sign(rNew(:,3)-L/2).*sign(L/2-rNew(:,3)) + 1)/2]; 
    end 
            

    KE(jj) = sum(sum((vMat').^2))*me/2; % calculate KE at each step
    if get(PlotIn, 'value') == 1 % plot the solution as it goes if Plot is true. 
        figure(123);cla
        %subplot(2,1,1); % uncomment these if you want to see K2 in time
        plot3(rMat(:,1), rMat(:,2), rMat(:,3), 'd'); axis equal; %box off; axis off; hold on; axis tight
        title([num2str(jj/Steps*100), '%']);
        %subplot(2,1,2);plot(KE);
        pause(0.1)
    end
    else 
        break
    end
end
toc


set(MessagaIn, 'string', 'Finished'); % let user know program is finished