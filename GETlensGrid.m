function [x1,x2,x1range,x2range] = GETlensGrid(kparam)
% % % Get the lens plane grid using the instrument parameters
nargin = length(kparam);
if nargin == 2
    x10 = 0;
    x20 = 0;
else
    x10 = kparam(3); %
    x20 = kparam(4);
end

pixsz = kparam(1); % pixel size in arcseconds
npix = kparam(2); % number of pixels 


if mod(npix,2) % N is odd
  fov=pixsz*(-(npix-1)/2:(npix-1)/2);
else % N is even
  fov=(-npix+1:2:npix-1)*pixsz/2;
end
x1range=x10+fov;
x2range=x20+fov;

% % % lens grid
[x1,x2]=meshgrid(x1range,x2range);
