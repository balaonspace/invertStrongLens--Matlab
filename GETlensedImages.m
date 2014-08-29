function observation = GETlensedImages(srcPos,Reff,Sc,sersicInd,kappaN,srcRad,srcPA,srcEllp,Y,magnification)
% % % To get the lensed images
% % % (srcPos,Reff,Sc,sersicInd,kappaN,srcRad,srcPA,srcEllp,Y,magnification,lensPA)

npix = length(Y);

% % % % source plane translated and rotated
YPr = exp(-1i*srcPA)*(Y - srcPos);

% % % % hit parameter constraints the points inside the source 
hit = real(YPr).^2+imag(YPr).^2/(1-srcEllp)^2;

hit(hit > srcRad^2) = 1e5;

% % % eliminate the core image
% % % can be commented if needed
hitc = round(npix/2)-5:round(npix/2)+5;
hit(hitc,hitc) = 1e5;


% % % % flux for the source follows sersic light profile
fluxSrc = Sc*exp(-kappaN*((sqrt(hit)/Reff).^(1/sersicInd) - 1));

% % % % multiply the flux by the magnification factor
observation = fluxSrc.*magnification;

% % % % Remove flux less than threshold
% % % % To remove flux values less than 1 in the pixels
observation(observation<1) = 0;
    
    
    
