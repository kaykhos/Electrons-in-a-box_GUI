% Sphere
R = sqrt(rMat(:,1).^2 + rMat(:,2).^2 + rMat(:,3).^2)
THETA = atan(rMat(:,2)./rMat(:,1));
PHI = atan(sqrt(rMat(:,2).^2+rMat(:,1).^2)./rMat(:,3))
figure(1)
subplot(1, 3, 1); hist(R/.5); title('Radius distribution'); ylabel('Count'); xlabel('Radius of electrons/Radius of Sphere')
subplot(1, 3, 2); hist(THETA); title('Equatorial angle distribution'); xlabel('radians')
subplot(1, 3, 3); hist(PHI); title('Azimuth angle distribution'); xlabel('radians')
 
 figure(2)
 




%%
figure(3);
Temp = [rand(200,1)*(Box(2)-Box(1)) + Box(1),...% Define initial positions
                rand(200,1)*(Box(4)-Box(3)) + Box(3),...
                rand(200,1)*(Box(6)-Box(5)) + Box(5)];
subplot(1,3,1); plot3(Temp(:,1), Temp(:,2), Temp(:,3), 'd'); title('Initial'); axis tight; axis equal
subplot(1,3,2); plot3(rMat(:,1), rMat(:,2), rMat(:,3), 'd'); title('Middle'); axis tight; axis equal
subplot(1,3,3); plot3(rMat(:,1), rMat(:,2), rMat(:,3), 'd'); title('Final'); axis tight; axis equal

 
%%


Str = 'Square';
cd Data 
    load([Str, '.mat'])
cd ..
rMat = Square;

Rad = 2;



theta = linspace(0, 2*pi, 40);
phi = linspace(0, pi, 100);
[Theta,Phi] = meshgrid(theta,phi);
NumElectron = length(rMat(:,1));
V = zeros(length(phi), length(theta));
for jj = 1:length(theta);
    for pp =1:length(phi);
        Pos = ones(NumElectron,1)*[Rad*cos(theta(jj))*sin(phi(pp)), Rad*sin(theta(jj))*sin(phi(pp)), Rad*cos(phi(pp))];
        V(pp,jj) = sum(qe/4/pi/epsilon0  ./sqrt(sum((Pos'-rMat').^2)));
    end
end
figure(1); cla
subplot(1,2,1); surf(Phi, Theta, V); shading interp; hold on; axis([0,pi,0,2*pi,])
xlabel('\phi');ylabel('\theta'); title('Near Field Potential')


