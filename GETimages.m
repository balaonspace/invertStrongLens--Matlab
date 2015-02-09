function observation = GETimages(sourceParam,Y)
% observation = GETimages(srcPos,Reff,Sc,sersicInd,kappaN,srcRad,srcPA,srcEllp,Y)
% % % To get the lensed images
% % % (srcPos,Reff,Sc,sersicInd,kappaN,srcRad,srcPA,srcEllp,Y,magnification,lensPA)

Sc = sourceParam(1);
sersicInd = sourceParam(2);
kappaN = 2*sersicInd - 0.327;
Reff = sourceParam(3);
srcRad = sourceParam(4);
srcPos = sourceParam(5)+1i*sourceParam(6);
srcEllp = sourceParam(7);
srcPA = sourceParam(8);

Yn = reshape(Y,length(Y)*length(Y),1);
[~, mi] = min(abs(Yn-srcPos));
% disp([mv mi])
errc = Yn(mi) - srcPos;

% % % % source plane translated and rotated
% YPr = exp(-1i*srcPA)*(Y - srcPos);
YPr = exp(-1i*srcPA)*(Y - srcPos - errc);

% % % % hit parameter constraints the points inside the source 
% % % % the source is constarained to be circular
hit = real(YPr).^2+imag(YPr).^2/(1-srcEllp)^2;

hit(hit > srcRad^2) = 1e5;

% % % % eliminate the core image
npix = length(Y);
hitc = round(npix/2)-5:round(npix/2)+5;
hit(hitc,hitc) = 1e5;

% % csvwrite('hit1.csv',hit)

% % % % flux for the source follows sersic profile
% % % % magnitude not set
observation = Sc*exp(-kappaN*((sqrt(hit)/Reff).^(1/sersicInd) - 1));

 % % % Remove flux less than threshold
observation(observation<1e-3) = 0;
