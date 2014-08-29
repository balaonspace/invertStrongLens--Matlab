function mu = GETmagnification(Y,pixsz)
    % Calculate the magnification map for the given source plane
    % coordinates

n = length(Y)-1;
area = ones(n,n);
% % % square pixels on the lens plane are mapped into quadrilateral pixels
% in the source plane. The area eclosed by the quadrilateral can be written
% as the sum of two triangles

for ii = 1:n
   for jj = 1:n
% % %        Area of first triangle
      matT =  [1 1 1; real(Y(ii,jj)) real(Y(ii,jj+1)) real(Y(ii+1,jj)); imag(Y(ii,jj)) imag(Y(ii,jj+1)) imag(Y(ii+1,jj))];
      areaT1 = abs(det(matT));
%       area1(ii,jj) = abs(det(matT));

% % %         Area of second triangle
      matT =  [1 1 1; real(Y(ii+1,jj+1)) real(Y(ii,jj+1)) real(Y(ii+1,jj)); imag(Y(ii+1,jj+1)) imag(Y(ii,jj+1)) imag(Y(ii+1,jj))];
      areaT2 = abs(det(matT));
%       area2(ii,jj) = abs(det(matT));

% % %         Area of the quadrialteral
      area(ii,jj) = areaT1+areaT2;
   end
end

% % % magnification map
mu = pixsz^2./area;

% % % % The upper threshold for the magnification factor
mu = min(100,mu);
