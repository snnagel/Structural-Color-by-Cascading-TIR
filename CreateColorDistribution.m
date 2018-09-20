%this script calculates the color distribution expected for a concave
%cavity where light is undergoing total internal reflection and interfering
%along different trajectories. 

%-----------------------------------------------------
%input parameters: 
R=32%Microns
n1=1.37
n2=1.27
CA=71 %degrees
inputAngle=30 %degrees
gridLinesOn=true

%Calculation Resolution:
dAngle=0.005 %radians
wavelengths=linspace(0.3, 0.800, 50); %microns

%------------------------------------------------------



thetaOut=[0:dAngle:pi/2];
phiOut=[0:dAngle:pi*2];

%Primary calculation: it should be noted that this calculation takes into
%acocunt refraction from n1 medium to air. 
outMap=Intensity_3D(wavelengths, thetaOut, phiOut, R, CA, inputAngle, n1, n2);
%%

C=IntensityToColor(wavelengths, outMap);
%image(C);

C_sphere=sphericalProjection( C, thetaOut, phiOut );
 

%Output image: 
figure
image([-1, 1], [-1, 1], C_sphere)
hold on
title(['\theta:', num2str(inputAngle), '^o,    R:', num2str(R), '\mu m  \eta: ', num2str(CA), '^o' ])
axis image
axis off

t=linspace(0, 2*pi);
plot(cos(t), sin(t), 'w', 'linewidth', 1)
if (gridLinesOn)
    %phi:
     for p=0:pi/4:pi
         plot([cos(p), -cos(p)], [sin(p), -sin(p)], 'w', 'linewidth', 1)
         hold on
     end
% theta:
    for thetaWhite=[pi/8:pi/8:pi/2];
        plot(sin(thetaWhite)*cos(t), sin(thetaWhite)*sin(t), 'w', 'linewidth', 1)
    end
    
end
