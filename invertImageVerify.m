clear all

% % % verify the inverted lens visually

load obsImage.csv
load arcImage.csv

% % % % To convolve the computed arcs with the telescope PSF
load psf.csv

% % % % mask image to mask the center of the lens galaxy and obscure pixels
% % % % if there is no mask image input a zero matrix the size of the image
maskImage = zeros(size(obsImage));

% % % kparam = [pixsize npixels]
kparam = [0.049 length(obsImage) 0 0];
kkparam = [0.049 length(obsImage)+1 0 0];

% % % % Obtain the lens grid for pixel centres 
[x1,x2,x1range,x2range] = GETlensGrid(kparam);
X = complex(x1,x2);

% % % % Obtain the lens grid for pixel edges
[x1,x2] = GETlensGrid(kkparam);
Xm = complex(x1,x2);

% % % lensParam = [einsteinRad axisRatio coreRadius shear1 shear2]
% % % sourceparam = [y1Src y2Src radiusSrc effectiveRadius ellpticitySrc positionAngleSrc]
% % % lens parameters are input for inverting the arcs, the source
% parameters are just for comparing the reconstructed source with the real
% source
lensParam = [1.6 0.8 0.2 pi/4.5 0.05 0.00];
sourceParam = [-0.14 0.14 0.4 0.2 0.3 0];

% % % % source reconstruction
[sourcedata, srcflux, magnification ,Y] = GETmisfitLensNIEXS(lensParam,arcImage,kparam,X,Xm);
% % % % image reconstruction
[chisq,sse,indexn,Reff,centroid,sc,r,obsFit] = GETchiSquared(obsImage,maskImage,sourcedata,srcflux,magnification,Y,psf,8);

% % % % figure showing the reconstructed image and the residue between the
% reconstructed image observed image
figure(1)
subplot(121)
image(x1range,x2range,obsFit)
colormap(flipud(gray))
axis equal
axis xy
title('Reconstructed image','fontsize',12,'FontName','Times New Roman','fontWeight','bold')
set(gca,'fontsize',12,'FontName','Times New Roman','fontWeight','bold')

subplot(122)
image(x1range,x2range,abs(obsImage-obsFit))
colormap(flipud(gray))
axis equal
axis xy
title(sprintf('Residue image, chisq = %0.3f',chisq/151^2),'fontsize',12,'FontName','Times New Roman','fontWeight','bold')
set(gca,'fontsize',12,'FontName','Times New Roman','fontWeight','bold')
% 
% % print(gcf,'-depsc2','-cmyk','chisqImg.eps')


% % % % figure showing  the reconstructed source and the sersic fit
figure(2)
rn = sortrows(r);

subplot(121)
plot(sourcedata,'k*')
hold on
[mflux, mpos] = max(srcflux);
plot(sourcedata(mpos),'rs','MarkerFaceColor','r')
hold on

theta = linspace(0,2*pi,50);
% % % draw source ellipse
radiusSRC = sourceParam(3); ellpSRC = sourceParam(5); paSRC = sourceParam(6); y1SRC = sourceParam(1); y2SRC = sourceParam(2);
ellipseYP = radiusSRC*complex(cos(theta),(1-ellpSRC)*sin(theta));
ellipseY = ellipseYP*exp(1i*paSRC) + complex(y1SRC,y2SRC);
plot(ellipseY,'-.','linewidth',2)
hold on

radiusSRC = max(r); ellpSRC = 0; paSRC = 0; 
% radiusSRC = Reff; ellpSRC = 0; paSRC = 0;
ellipseYP = radiusSRC*complex(cos(theta),(1-ellpSRC)*sin(theta));
ellipseY = ellipseYP*exp(1i*paSRC) + sourcedata(mpos);
plot(ellipseY,'m','linewidth',2)

xlabel('arcsec','fontsize',12,'FontName','Times New Roman','fontWeight','bold')
ylabel('arcsec','fontsize',12,'FontName','Times New Roman','fontWeight','bold')
title(sprintf('Source Plane'),'fontsize',12,'FontName','Times New Roman','fontWeight','bold')
% grid on
set(gca,'fontsize',12,'FontName','Times New Roman','fontWeight','bold')
legend('Inverted Source','Max Intensity','Simulated Source','Fitted Source')
axis equal
hold off

subplot(122)
plot(r,srcflux/mflux,'k*')
hold on
kappa = 2*indexn-0.327;
srcfluxf = sc*exp(-kappa*((rn./Reff).^(1/indexn)-1));

plot(rn,srcfluxf/mflux,'m','linewidth',2)

Reff = 0.2; indexn = 4; kappa = 2*indexn -0.327;

xlabel('Radius [arcsec]','fontsize',12,'FontName','Times New Roman','fontWeight','bold')
ylabel('Intensity','fontsize',12,'FontName','Times New Roman','fontWeight','bold')
title(sprintf('Source sersic profile, SSE = %1.3f',sse),'fontsize',12,'FontName','Times New Roman','fontWeight','bold')
set(gca,'fontsize',12,'FontName','Times New Roman','fontWeight','bold')

hold off

% 
% print(gcf,'-depsc2','-cmyk','invertSRC.eps')
% % close all
