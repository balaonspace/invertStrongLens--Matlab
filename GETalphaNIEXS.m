function [Xr,alpha,x1,x2] = GETalphaNIEXS(lensParam,X)
% % % % calculate the deflection angle for the NIE + XS lens model

% % % lens parameters
einRad = lensParam(1);
f = lensParam(2);
fp = sqrt(1-f^2);
bc = lensParam(3);
t = lensParam(4);
xshear = complex(lensParam(5),lensParam(6));

% % % % rotate the co-ord according to lens orientation
Xr = X*exp(-1i*t);
x1 = real(Xr);
x2 = imag(Xr);

b = complex(x1,f*x2);
bsq = abs(b).^2;
bsqx = complex(x1,f^2*x2);

alpha = einRad*(sqrt(f)/fp)*( atanh( fp * sqrt(bsq+bc^2) ./ bsqx ) - atanh( fp*bc./(f*Xr)) );
alpha = conj(alpha);
alpha = alpha*exp(1i*lensParam(4)) - xshear*conj(X);
