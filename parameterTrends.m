figure

%Default parameters:
R_df=25%10/sind(CA) %Microns
n1_df= 1.37
n2_df=1.27
CA_df=71%acosd(1-h/R)
inputAngle_df=21.41
phiOut=pi;
N=200%0%number of each values for each sweep

%Sweep values:
ilVals=linspace(0, 60, N);
n2Vals=linspace(1, 1.3, N);
Rvals=linspace(10,40, N);
CAvals=linspace(50, 110, N);


thetaOut=linspace(0, pi/2, N);

 wavelengths=linspace(0.3, 0.800, 200);

for qq=1:4 %Each parameter
    fullDist=zeros(length(wavelengths), N, N);
for ll=1:N
        R=R_df;
        n1=n1_df;
        n2=n2_df;
        CA=CA_df;
        inputAngle=inputAngle_df;
    if qq==1
        R=Rvals(ll);
    end
    if qq==2
        CA=CAvals(ll);
    end
    if qq==3
        n2=n2Vals(ll);
    end
    if qq==4
        inputAngle=ilVals(ll);
    end
  
 d=-R*cosd(CA);
 eta=CA*pi/180;



 outMap=Intensity_3D( wavelengths, thetaOut, phiOut, R, CA, inputAngle, n1, n2, false);
 fullDist(:, :, ll)=outMap;
end

C=IntensityToColor(wavelengths, fullDist);
colorImage=permute(C, [2, 1, 3]);

subplot(2, 2, qq)
    if qq==1
        ydat=Rvals
        ylab='Radius (\mu m)'
        
    end
    if qq==2
        ydat=CAvals
        ylab='\eta (^o))'
    end
    if qq==3
        ydat=n2Vals
        ylab='n_{2}'
    end
    if qq==4
        ydat=ilVals
        ylab='\theta_{in}'
    end
 
image(thetaOut*180/pi, ydat, colorImage)

ylabel(ylab)
xlabel('\theta_{out}')
set(gca,'YDir','normal')
xlim([0, 90])

end
set(gcf, 'color', 'white')