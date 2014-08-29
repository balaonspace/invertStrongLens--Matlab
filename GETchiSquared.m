function [chisq,sse,indexn,Reffn,centroid,sc,r,obsFit] = GETchiSquared(obsImage,maskImage,sourcedata,srcflux,magnification,Y,psf,sN)
    
% % % % find the max flux and its position in the source plane
[mflux, ind] = max(srcflux);
% % % % normalise the flux to unit intensity
srcfluxn = srcflux/mflux;

% % % % distance from the max flux position to other points
r = abs(sourcedata-sourcedata(ind));

% % % % fit the sersic profile for the points in source plane
fo = fitoptions('Method','NonlinearLeastSquares',...
               'Lower',0.1,...
               'Upper',8,...
               'StartPoint',4);

ft = fittype('exp((-2*n+0.327)*((x/re).^(1/n)))','problem','re','options',fo);

% % % % optimise the effective radius of the source
Reff = linspace(0.5,1,5)*max(r);

sse = zeros(5,1);
for ii = 1:5
    [~,gof] = fit(r,srcfluxn,ft,'problem',Reff(ii));
    sse(ii) = gof.sse;
end

[~, minind] = min(sse);
Reffn = Reff(minind);
    
[fitp,gof] = fit(r,srcfluxn,ft,'problem',Reffn);
% % % % source parameters
% % % % sersic index (n) and intensity(Sc)
indexn = fitp.n;
kappan = 2*fitp.n - 0.327; 
sc = mflux/exp(kappan);

% % % % goodness of fit, the summed square errors between the reconstructed
% source and the Sersic fit
sse = gof.sse;

% % % % centroid of the reconstructed source
centroid = sourcedata(ind);

% % % % % Fit the arc for the given lens and reconstructed source parameters
% sourceParam = [real(centroid) imag(centroid) max(r) Reffn 1 0 fitp.n sc];
obsFit = GETlensedImages(centroid,Reffn,sc,indexn,kappan,max(r),0,0,Y,magnification);

% % % % convolve the image with the psf of the telescope (only optional)
obsFit = conv2(obsFit,psf,'same');

% % % % reduced chi squared for the fitted image
% % % % the factor sN in denominator is the standard deviation in noise
chisq = sum( sum( (obsImage(maskImage==0)-obsFit(maskImage==0)).^2/ sN^2 ) );

% % % % centroid of the source in source plane
centroid = [real(centroid) imag(centroid)];


