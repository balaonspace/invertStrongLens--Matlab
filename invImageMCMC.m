clear all

% % % % the observed image and the extracted arcs
obsImage = load('obsImage1.csv');
arcImage = load('arcImage1.csv');
maskImage = load('arcImage1.csv');

% % % % the PSF of the instrument
psf = load('psf.csv');

%	factor used in the division of chi-squared
NM = sum(sum(arcImage>0));
%	uncertainity in the flux data
sN = 11;

% % % % kparam = [pixsize npixels x10 x20]
% % % % lensParam = [einsteinRad f bc t xshear1 xshear2]

kparam = [0.049 length(obsImage) 0 0];

[x1,x2,x1range,x2range] = GETlensGrid(kparam);
X = complex(x1,x2);

%	number of samples in MCMC
nsamples = 20000;
M = 100;

%	initial lens parameters
% lensParam = [1.65 0.75 0 pi/4 0 0];
lensParam = [1.65 0.75 0 0 0 0];
% % % % jump parameters for the lens
jumpParamL = [0.03 0.05 0 pi/10 0 0];
% % % % upper and lower bound for the lens parameters
% Lub = [1.8 0.99 0 pi/2 0 0]; Llb = [1.5 0.5 0 0 0 0];
Lub = [1.8 0.99 0 pi/2 0 0]; Llb = [1.5 0.5 0 -pi/2 0 0];

% % %  find position of max intensity for source
[centroid, Imax, R] = GETcentroid(lensParam,arcImage,X);

p = lensParam;
tic
for ii = 1:10000
    if (R>0.5*p(1) && p(1)>Llb(1) && p(1)<Lub(1) && p(2)>Llb(2) && p(2)<Lub(2) && p(4)>Llb(4) && p(4)<Lub(4))
        p = lensParam+jumpParamL.*(2*rand(1,6)-1);
        [centroid, Imax, R] = GETcentroid(p,arcImage,X);
    else
        lensParam = p;
        break;
    end
end
toc

disp(lensParam)

% % % % initial source parameters
sourceParam = [0 2 0 R centroid 0 0];
% % % jump parameters for the source
jumpParamS = [0 0.65 0 0 0 0 0 0];
% % % % upper and lower bound for the source
Sub = [0 7 0 0.5*lensParam(1) 0 0.5 0.5 0 0]; Slb = [0 0.5 0 0 -0.5 -0.5 0 0];

tic
[lensP, sourceP] = GETmcmcLens2(obsImage,arcImage,maskImage,X,lensParam,sourceParam,sN,psf,jumpParamL,jumpParamS,Lub,Llb,Sub,Slb,NM,nsamples,M,Imax);
toc

[mv,mi]=max(sourceP(:,7));
disp(lensP(mi,:))
disp(sourceP(mi,:))


csvwrite('lens1a.csv',lensP)
csvwrite('src1a.csv',sourceP)


tt = length(lensP); ff = int32(0.15*tt)+1;
disp(mean(lensP(ff:tt,:)))
disp(std(lensP(ff:tt,:)))
disp(mean(sourceP(ff:tt,:)))
disp(std(sourceP(ff:tt,:)))


