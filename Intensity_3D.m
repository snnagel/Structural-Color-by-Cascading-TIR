function outMap = Intensity_3D( wavelengths, thetaOut, phiOut, R, CA, inputAngle, n1, n2) 
%This function outputs intensity as a function of wavelength and outgoing
%direction for a given cavity size (radius R in microns), 
%shape (contact angle CA in degrees)
% input illumination direction (inputAngle in degrees)
% cavity refractive index: n1
% Outside index: n2

%measurements of input and output angles are assumed to be IN AIR
%refraction from air to medium of n1 through flat interface is included in
%this script!

% number to truncate the sum if mMax is very large:
MAX_num_bounces=300;

%this script includes refracion

%if refractive index outside of cavity is not included assume air
if nargin<8
    n2=1 %air
end
 

%%

%contact angle in radians:
eta=CA*pi/180;

%Illumination after refraction (in radians)
ti=asin(sind(inputAngle)/n1);

%this sets the minimum local angle of incidence to be that of TIR, could be
%decreased to capture some of the partially reflected light. 
minAngle=asin(n2/n1);


%initiate amplitude distribution maps for each polarization for each the 
%reverse bounce trajectories. 
 AmpFtm=zeros(length(wavelengths), length(thetaOut), length(phiOut));
 AmpRtm=zeros(length(wavelengths), length(thetaOut), length(phiOut));
 AmpFte=zeros(length(wavelengths), length(thetaOut), length(phiOut));
 AmpRte=zeros(length(wavelengths), length(thetaOut), length(phiOut));
  ErrorMap=zeros(length(wavelengths), length(thetaOut), length(phiOut));
 %Go through the sume for each wavelength
 for jj=1:length(wavelengths)
     lambda=wavelengths(jj);
    
     for ii=1:length(thetaOut)
         tO=thetaOut(ii);
         for kk=1:length(phiOut)
             phiO=phiOut(kk);
             psi=acos(sin(tO)*sin(ti)*cos(phiO)+cos(tO)*cos(ti));

              
             B=abs(sin(psi))/sqrt(sin(psi)^2-(sin(ti)*sin(tO)*sin(phiO))^2);
             etaE=acos(B*cos(eta));
             
             if not(isreal(etaE))
                 message='Something went wrong with eta'
             end
              
             betai=acos(B*cos(ti));
             betao=-acos(B*cos(tO));
             flag=0;
             
             %correct for when betao is positive
             if not((abs(betai-betao)-psi)<1e-12)
               betao=acos(B*cos(tO));
             end
             

         %forward direction:  
         minMaxA=min(pi/2-abs(pi/2-(etaE+betai)), pi/2-abs(pi/2-(etaE-betao)) );

         mMin=ceil(abs((-betai+betao+pi)./(pi-2*minAngle)));
         mMax=floor(abs((-betai+betao+pi)./(pi-2*minMaxA)));
         mMax=min(mMax, MAX_num_bounces);
        for M=mMin:1:mMax
        alpha=pi/2-(pi-betai+betao)/(2*M);
 
        cosi=cos(alpha);
        sint=n1/n2*sin(alpha);
        cost=sqrt(1-sint.^2);
        rs=(n1*cosi-n2*cost)./(n1*cosi+n2*cost);
        rp=(n2*cosi-n1*cost)./(n2*cosi+n1*cost); 
         
        cAmpTM=rp.^M;
        cAmpTE=rs.^M;
        l=2*M*R*cos(alpha);
        AmpFtm(jj, ii, kk)=AmpFtm(jj, ii, kk)+(cos(alpha)/M)*exp(1i*2*pi*n1*l/lambda)*cAmpTM;
        AmpFte(jj, ii, kk)=AmpFte(jj, ii, kk)+(cos(alpha)/M)*exp(1i*2*pi*n1*l/lambda)*cAmpTE;
         
        end
        
        %reverse direction:
         betai=-betai;
         betao=-betao;
         minMaxA=min(pi/2-abs(pi/2-(eta+betai)), pi/2-abs(pi/2-(eta-betao)) );
         mMin=ceil(abs((-betai+tO+pi)./(pi-2*minAngle)));
         mMax=floor(abs((-betai+betao+pi)./(pi-2*minMaxA)));
         mMax=min(mMax, MAX_num_bounces);
        for M=mMin:1:mMax
        alpha=pi/2-(pi-betai+betao)/(2*M);
        cosi=cos(alpha);
        sint=n1/n2*sin(alpha);
        cost=sqrt(1-sint.^2);
        rs=(n1*cosi-n2*cost)./(n1*cosi+n2*cost);
        rp=(n2*cosi-n1*cost)./(n2*cosi+n1*cost);
        %rp=(n2^2*cosi-n1*1i*sqrt(n1^2*sin(alpha)^2-n2^2))./(n2^2*cosi+n1*1i*sqrt(n1^2*sin(alpha)^2-n2^2));
         
         
        cAmpTM=rp.^M;
        cAmpTE=rs.^M;
        l=2*M*R*cos(alpha);
        AmpRtm(jj, ii, kk)=AmpRtm(jj, ii, kk)+(cos(alpha)/M)*exp(1i*2*pi*n1*l/lambda)*cAmpTM;
        AmpRte(jj, ii, kk)=AmpRte(jj, ii, kk)+(cos(alpha)/M)*exp(1i*2*pi*n1*l/lambda)*cAmpTE;
        end
        end 
     end
 end
 
 %Combine inocoherently:
 outMap=abs(AmpFtm).^2+abs(AmpRtm).^2+abs(AmpFte).^2+abs(AmpRte).^2;
  
  
%Account for refraction.  Above calculation is in medium
%This converts angles to those seen in air, according to snell's law
%and accounts for transimission coefficient through interface
thetaRef=thetaOut;
outRef=zeros(length(wavelengths), length(thetaOut), length(phiOut));
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
    end    
    end
    T=n2*cost/(n1*cosi)*abs(tp)^2;
    theta_i=asin(sin(thetaRef(jj))/n1);
    [~, kk]=min(abs(theta_i-thetaOut));
    outRef(:, jj, :)= T.*outMap(:, kk, :);
end
 
outMap=outRef;
 
end
