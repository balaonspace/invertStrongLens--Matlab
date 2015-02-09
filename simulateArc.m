clear all

% % % % load the HST PSF
load psf.csv

% % % Simulate images for a SIE lens with given parameters

% % % kparam = [pixsize npixels]
% % % lensParam = [einsteinRad f bc t]
% % % sourceparam = [y1Src y2Src rSrc reff ellpSrc paSrc profileParam]
% % % profileParam = 1 for sersic profile, 0 for uniform profile

% % % %  load the noise file
noisef = fitsread('noiseI1.fits');
noise = noisef(1:151,1:151);
np = reshape(noise,151*151,1);

% % % % load the parameters for the background source
srcp = [22.047,3.2229,0.243,0.729,0.6441];

% % % % Lens plane grid
kparam = [0.049 151 0 0];
[x1,x2,x1range,x2range] = GETlensGrid(kparam);
X = complex(x1,x2);

% % % % lens parameters
lensParam = [1.6 0.8 0.0 pi/4.5 0.00 0.00];


% % % %     source parameters
sourceParam = [srcp(2) 4 srcp(3) 4*srcp(3) -0.766/8  0.642/8 0.3 0];
% % sourceParam = [srcp(2) 4 srcp(3) 4*srcp(3 -0.766/4  0.642/4 0.3 0];
% % sourceParam = [srcp(2) 4 srcp(3) 4*srcp(3 0.766/8  0.642/8 0.3 0];
% % sourceParam = [srcp(2) 4 srcp(3) 4*srcp(3 0.766/4  0.642/4 0.3 0];
% % sourceParam = [srcp(2) 4 srcp(3) 4*srcp(3 0.173/8  0.984/8 0.3 0];
% % sourceParam = [srcp(2) 4 srcp(3) 4*srcp(3 0.173/4  0.984/4 0.3 0];

% % % % lensing equation
[~,alpha] = GETalphaNIEXS(lensParam,X);
Y = X - alpha;

% % % %     simulated image
observation = GETimages(sourceParam,Y);
observation = conv2(observation,psf,'same');

obsn = observation+noise-mean(np);
subplot(121)
image(x1range,x2range,obsn)
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

subplot(122)
arc = obsn;
arc(observation<22) = 0;
image(x1range,x2range,arc)
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


% % % % print the image file
% print(gcf,'-dpng',sprintf('image%d.png',ii))

% % % % save the images in csv format
csvwrite(sprintf('obsImage%d.csv',1),obsn)
csvwrite(sprintf('arcImage%d.csv',1),arc)


