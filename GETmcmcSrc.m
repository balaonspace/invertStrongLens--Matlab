function Src = GETmcmcSrc(obsImage,maskImage,lensParam,sourceParam,psf,X,sN,jumpParamS,Sub,Slb,NM,Imax,nsamples,M)

%	intensity at effective radii
Ie = Imax/exp(2*sourceParam(2)-0.327);
sourceParam(1) = 3*Ie*rand + Ie;
%	effective radii
sourceParam(3) = rand*sourceParam(4);
chisq = GETchisquaredN(X,obsImage,maskImage,lensParam,sourceParam,sN,psf);

%	bounds on the source parameter
Sub = Sub(2);  Slb = Slb(2);
llo = -abs(chisq/NM);

Src = zeros(nsamples/M+1,7);
Src(1,:) = [sourceParam(1:6) llo];

for k=1:nsamples
    p=lensParam;
    s=sourceParam+jumpParamS.*(2.*rand(1,8)-1);
    Ie = Imax/exp(2*s(2)-0.327);
    s(1) = 3*Ie*rand + Ie;
    s(3) = rand*s(4);

    if (s(2)>Slb && s(2)<Sub)
        chisq = GETchisquaredN(X,obsImage,maskImage,p,s,sN,psf);
        
        llp = -abs(chisq/NM);

        alpha=min(1,exp(llp-llo));

        if rand<alpha
            llo=llp; sourceParam = s;
        end
    end
    

    if ~mod(k,M)
        Src(k/M+1,:)=[sourceParam(1:6) llo];
    end
end
