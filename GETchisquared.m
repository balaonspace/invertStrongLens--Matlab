function [chisq, obsFit] = GETchisquared(X,obsImage,maskImage,lensParam, sourceParam,sN,psf)
% % % % GETchisquared(sdata,srcflux,magnification,kparam,lensParam,wflux,mask,obsN,Y)
    % get the chisquared for the given fit


[~,alpha] = GETalphaNIEXS(lensParam,X);
Y = X - alpha;

obsFit = GETimages(sourceParam,Y);
% % % % convolve the image with the psf of the telescope
obsFit = conv2(obsFit,psf,'same');

% % % % reduced chi squared for the fitted image
% % % % the factor 8 in denominator is the standard deviation in noise
chisq = sum( sum( (obsImage(maskImage>0 | obsFit>sN)-obsFit(maskImage>0 | obsFit>sN)).^2 ) )/ sN^2;
