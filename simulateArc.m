clear all

% % % Simulate gravitational arcs for a NIE lens with given parameters

% % % % Image characteristics
% % % kparam = [pixsize npixels]
kparam = [0.049 151];
kkparam = [0.049 kparam(2)+1];

% % % % Lens Parameters
% % % lensParam = [einsteinRad axisRatio coreRadius shear1 shear2]
lensParam = [1.6 0.8 0.2 pi/4.5 0.05 0.00];

% % % % Source Parameters
% % % sourceparam = [y1Src y2Src radiusSrc effectiveRadius ellpticitySrc positionAngleSrc]
sourceParam = [-0.14 0.14 0.4 0.2 0.3 0];


srcPos = sourceParam(1)+1i*sourceParam(2);
Sc = 1;
sersicInd = 4;
kappaN = 2*sersicInd - 0.327;
srcRad = sourceParam(3);
Reff = sourceParam(4);
srcEllp = sourceParam(5);
srcPA = sourceParam(6);
lensPA = lensParam(4);

% % % % Obtain the lens grid for pixel centres
[x1,x2,x1range,x2range] = GETlensGrid(kparam);
X = complex(x1,x2);

% % % % Obtain the lens grid for pixel edges
[x1,x2] = GETlensGrid(kkparam);
Xm = complex(x1,x2);

% % % % Compute transformation map and magnification map
[Y, magnification] = GETsourcePlane(lensParam,kparam,X,Xm);

% % % % Obtain the lensed images of the source
observation = GETlensedImages(srcPos,Reff,Sc,sersicInd,kappaN,srcRad,srcPA,srcEllp,Y,magnification);

% % % % standard deviation of the gaussian noise added to the image
nn = [0 8 32];

noise1 = normrnd(4,nn(1),size(observation));
obsn1 = observation+noise1-4;
noise2 = normrnd(4,nn(2),size(observation));
obsn2 = observation+noise2-4;
noise3 = normrnd(4,nn(3),size(observation));
obsn3 = observation+noise3-4;

% % % % save the images with noise
csvwrite('obsImage1.csv',obsn1)
csvwrite('obsImage2.csv',obsn2)
csvwrite('obsImage3.csv',obsn3)


% % % % Display the images
figure(1)
subplot(131)
image(x1range,x2range,obsn1)
colormap(flipud(gray))
hold on
plot([min(x1range), max(x1range)],[0 0],'k')
plot([0 0],[min(x2range), max(x2range)],'k')
axis xy
axis equal
xlim([min(x1range) max(x1range)])
xlabel('arcsec','fontsize',12,'FontName','Times New Roman','fontWeight','bold')
ylabel('arcsec','fontsize',12,'FontName','Times New Roman','fontWeight','bold')
title('Observed Image','fontsize',12,'FontName','Times New Roman','fontWeight','bold')
set(gca,'fontsize',12,'FontName','Times New Roman','fontWeight','bold')
hold off

subplot(132)
image(x1range,x2range,obsn2)
colormap(flipud(gray))
hold on
plot([min(x1range), max(x1range)],[0 0],'k')
plot([0 0],[min(x2range), max(x2range)],'k')
axis xy
axis equal
xlim([min(x1range) max(x1range)])
xlabel('arcsec','fontsize',12,'FontName','Times New Roman','fontWeight','bold')
ylabel('arcsec','fontsize',12,'FontName','Times New Roman','fontWeight','bold')
title('Observed Image','fontsize',12,'FontName','Times New Roman','fontWeight','bold')
set(gca,'fontsize',12,'FontName','Times New Roman','fontWeight','bold')
hold off

subplot(133)
image(x1range,x2range,obsn3)
colormap(flipud(gray))
hold on
plot([min(x1range), max(x1range)],[0 0],'k')
plot([0 0],[min(x2range), max(x2range)],'k')
axis xy
axis equal
xlim([min(x1range) max(x1range)])
xlabel('arcsec','fontsize',12,'FontName','Times New Roman','fontWeight','bold')
ylabel('arcsec','fontsize',12,'FontName','Times New Roman','fontWeight','bold')
title('Observed Image','fontsize',12,'FontName','Times New Roman','fontWeight','bold')
set(gca,'fontsize',12,'FontName','Times New Roman','fontWeight','bold')
hold off

% % % % % Save the figure in eps or png format
% print(gcf,'-depsc2','-cmyk','simImage.eps')
% print(gcf,'-dpng','simImage.png')
