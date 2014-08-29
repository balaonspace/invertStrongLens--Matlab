function [Y, magnification] = GETsourcePlane(lensParam,kparam,X,Xm)
% % % % Compute the transformation map and magnification map

pixsz = kparam(1);
% % % % magnification threshold - the threshold value above which the
% pixels in the image plane are resampled and the magnification is computed
% again
thresh = 30;

% % % % % compute the deflection angle
[~,alpha] = GETalphaNIEXS(lensParam,Xm);

% % % % compute the transformation map for the pixel edges
Y = Xm - alpha;

% % % % compute the Magnification map
mu = GETmagnification(Y,pixsz); 

% % % % find the pixels near the critical curve
m = mu; m = m(m>thresh);
x1 = real(X); x2 = imag(X);

x1 = x1(mu>thresh); x2 = x2(mu>thresh);

% % % % recompute magnification for points near critical curve
hpixsz = pixsz/2;
mu1 = zeros(length(m),1);
for ii = 1:length(m)
    kkparam = [hpixsz,3,x1(ii),x2(ii)];
    
    [XX1,XX2] = GETlensGrid(kkparam);
    XX = complex(XX1,XX2);
    
    [~,alpha1] = GETalphaNIEXS(lensParam,XX);
    Y1 = XX - alpha1;
    mu1(ii) = sum(sum(GETmagnification(Y1,hpixsz)))/4;
end

mu(mu>thresh) = mu1;

magnification = mu;

% % % compute the deflection angle for pixel center
[~,alpha] = GETalphaNIEXS(lensParam,X);

% % % % Transformation map for the pixel center
Y = X - alpha;
