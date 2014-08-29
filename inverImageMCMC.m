clear all

% % % The MCMC sampling for the given arc
% % % INPUT - observed image, arc image, psf

load obsImage.csv
load arcImage.csv
load psf.csv

% % % % To convolve the computed arcs with the telescope PSF
load psf.csv

% % % % standard deviation of the noise in the obserced image
sN = 8;

% % % % mask image to mask the center of the lens galaxy and obscure pixels
maskImage = zeros(size(obsImage));

% % % % Image characteristics
kparam = [0.049 length(obsImage) 0 0];
kkparam = [0.049 length(obsImage)+1 0 0];

% % % % Obtain the lens grid for pixel centres
[x1,x2,x1range,x2range] = GETlensGrid(kparam);
X = complex(x1,x2);

% % % % Obtain the lens grid for pixel edges
[x1,x2] = GETlensGrid(kkparam);
Xm = complex(x1,x2);

% % % % number of samples for the MCMC analysis
nsamples = 10;

% % %     The posterior for the einstein radius 
lensP1 = 1.0 + (2-1.0)*rand(nsamples,1);
% % %     The posterior for the axis ratio     
lensP2 = 0.5 + (0.9999-0.5)*rand(nsamples,1);
% % %     The posterior for the core radius is uniform distribution
lensP3 = 0.01 + (0.5-0.01)*rand(nsamples,1);
% % %     The posterior for position angle is wrapped normal 
lensP4 = -pi/2 + pi*rand(nsamples,1);
% % %     the posterior for external shear is gamma and wrapped normal
% distribution
lensP5 = -0.1 + (0.1+0.1)*rand(nsamples,1);
lensP6 = -0.1 + (0.1+0.1)*rand(nsamples,1);

lensP = [lensP1 lensP2 lensP3 lensP4 lensP5 lensP6];

lensChi = zeros(nsamples,7);

tic

for ii = 1:nsamples
    
    lensParam = lensP(ii,:);
    
    [sourcedata, srcflux, magnification,Y] = GETmisfitLensNIEXS(lensParam,arcImage,kparam,X,Xm);
    
    [chisq,sse,indexn,Reffn,centroid,sc] = GETchiSquared(obsImage,maskImage,sourcedata,srcflux,magnification,Y,psf,sN);
    
    lensChi(ii,:) = [chisq sse indexn Reffn centroid sc];
    
end

toc


csvwrite('lensPrior.csv',lensP)
csvwrite('lensChisquared.csv',lensChi)

