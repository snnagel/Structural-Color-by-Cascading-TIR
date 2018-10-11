function outMap = analyticalCalc(wavelengths, thetaOut, R, CA, inputAngle, n1, n2)

%this script includes refracion

if nargin<7
    n2=1 %air
end




 d=-R*cosd(CA);
 eta=CA*pi/180;


 
 %inSpectra=ones(size(inSpectra));


ti=asin(sind(inputAngle)/n1);
 
 A=zeros(length(wavelengths), length(thetaOut));




outMap=zeros(length(wavelengths), length(thetaOut));

 

ti=asin(sind(inputAngle)/n1);
 
 A=zeros(length(wavelengths), length(thetaOut));
 for jj=1:length(wavelengths)
     lambda=wavelengths(jj);
     for ii=1:length(thetaOut)
         tO=thetaOut(ii);
         minMaxA=min(pi/2-abs(pi/2-(eta+ti)), pi/2-abs(pi/2-(eta-tO)) );
         mMin=ceil(abs((-ti+tO+pi)./(pi-2*asin(n2/n1))));
         mMax=floor(abs((-ti+tO+pi)./(pi-2*minMaxA)));
        for M=mMin:1:mMax
        alpha=pi/2-(pi-ti+tO)/(2*M);

        cosi=cos(alpha);
        sint=asin(n1/n2*sin(alpha));
        cost=sqrt(1-sint.^2);
        rs=(n1*cosi-n2*cost)./(n1*cosi+n2*cost);
        rp=(n2*cosi-n1*cost)./(n2*cosi+n1*cost);
        %rp=(n2^2*cosi-n1*1i*sqrt(n1^2*sin(alpha)^2-n2^2))./(n2^2*cosi+n1*1i*sqrt(n1^2*sin(alpha)^2-n2^2));
        
        
        cAmpTM=rp.^M;
        cAmpTE=rs.^M;
        l=2*M*R*cos(alpha);
        A(jj, ii)=A(jj, ii)+cos(alpha)/M*exp(1i*2*pi*n1*l/lambda)*cAmpTE;

        end
     end
 end
 
 B=zeros(length(wavelengths), length(thetaOut));
 ti=-ti;
 for jj=1:length(wavelengths)
     lambda=wavelengths(jj);
     for ii=1:length(thetaOut)
         tO=-thetaOut(ii);
         minMaxA=min(pi/2-abs(pi/2-(eta+ti)), pi/2-abs(pi/2-(eta-tO)) );
         mMin=ceil(abs((-ti+tO+pi)./(pi-2*asin(n2/n1))));
         mMax=floor(abs((-ti+tO+pi)./(pi-2*minMaxA)));
        for M=mMin:1:mMax
        alpha=pi/2-(pi-ti+tO)/(2*M);

        cosi=cos(alpha);
        sint=asin(n1/n2*sin(alpha));
        cost=sqrt(1-sint.^2);
        rs=(n1*cosi-n2*cost)./(n1*cosi+n2*cost);
        rp=(n2*cosi-n1*cost)./(n2*cosi+n1*cost);
        %rp=(n2^2*cosi-n1*1i*sqrt(n1^2*sin(alpha)^2-n2^2))./(n2^2*cosi+n1*1i*sqrt(n1^2*sin(alpha)^2-n2^2));
        
        
        cAmpTM=rp.^M;
        cAmpTE=rs.^M;
        l=2*M*R*cos(alpha);
        B(jj, ii)=B(jj, ii)+cos(alpha)/M*exp(1i*2*pi*n1*l/lambda)*cAmpTE;

        end
     end
 end

 outMap=outMap+(abs(A).^2+abs((B)).^2); 
 
 

thetaRef=thetaOut;
outRef=zeros(length(wavelengths), length(thetaOut));
for jj=1:length(thetaRef)
cost=cos(thetaRef(jj));
cosi=cos(asin(sin(thetaRef(jj))/n1));
if cosi< 0 %it shouldn't
    tp=0;
else

if isreal(cost) %it should be
tp=2*n1*cosi/(n2*cosi+n1*cost);
else
    tp=0;
    acos(cosi)*180/pi;
end    
end
T=n2*cost/(n1*cosi)*abs(tp)^2;
theta_i=asin(sin(thetaRef(jj))/n1);
[~, kk]=min(abs(theta_i-thetaOut));
outRef(:, jj)= T.*outMap(:, kk);
end

outMap=outRef

end

