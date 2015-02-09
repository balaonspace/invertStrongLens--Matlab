function [lensP, sourceP] = GETmcmcLens(obsImage,arcImage,maskImage,X,lensParam,sourceParam,sN,psf,jumpParamL,jumpParamS,Lub,Llb,Sub,Slb,NM,nsamples,M,Imax)

Llb1 = Llb([1 2 4]); Lub1 = Lub([1 2 4]);
% % % % get the source parameters with the lowest chi-squared for the given
% lens and initial source parameters
Src = GETmcmcSrc(obsImage,maskImage,lensParam,sourceParam,psf,X,sN,jumpParamS,Sub,Slb,NM,Imax,100,10);
[~, mi] = max(Src(:,7));
sourceParam = Src(mi,:);
% % % % likelihood of the chosen source
llo = sourceParam(7);

% % % % initialise the mcmc
lensP = zeros(M,6);
sourceP = zeros(M,7);
lensP(1,:) = lensParam;
sourceP(1,:) = sourceParam;

for k=1:nsamples
    
% % %     generate random lens parameters
    p=lensParam+jumpParamL.*(2*rand(1,6)-1);
    
    [centroid, Imax, R] = GETcentroid(p,arcImage,X);
    srcParam = [0 4 0 R centroid 0 0];
    
    pp = p([1 2 4]); 
    
    if (sum(pp>Llb1) == 3 && sum(pp<Lub1) == 3 && R<0.5*p(1))
          
        Src = GETmcmcSrc(obsImage,maskImage,p,srcParam,psf,X,sN,jumpParamS,Sub,Slb,NM,Imax,100,10);
        [~, mi] = max(Src(:,7));
        srcParam = Src(mi,:);
        llp = srcParam(7);

        alpha=min(1,exp(llp-llo));
        if rand<alpha
            lensParam = p; llo=llp; sourceParam = srcParam;
        end
    end
    
    if ~mod(k,M)
        lensP(k/M+1,:) = lensParam;
        sourceP(k/M+1,:) = sourceParam;
    end
end




