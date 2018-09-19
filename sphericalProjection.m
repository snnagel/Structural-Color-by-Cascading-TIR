function C_sphere = sphericalProjection( C, thetaOut, phiOut, pixSize ) 
%This function takes a image where the axes correspond to theta
%and phi and transforms the image such that it is a spherical projection
%that is to say the (x, y) pixel values are: 
% x=Acos(phi)sin(theta)
% y=Asin(phi)sin(theta) for some scaling factor A (defines image size)


if nargin<4
    pixSize=0.05;%degree in radial direction
end

dAngle=thetaOut(2)-thetaOut(1);

x=[-90:pixSize:90]/90;
y=[-90:pixSize:90]/90;
C_sphere=zeros(length(x), length(y), 3);

%each x, y pixel
for ii=1:length(x)
    for jj=1:length(y)
        xx=x(ii);
        yy=y(jj);
        
        %determine matching theta and phi values:
        if xx^2+yy^2<1 && xx^2+yy^2~=0
        phiP=atan(yy/xx);
        if xx<0
            phiP=phiP+pi;
        elseif phiP<0
            phiP=phiP+2*pi;
        end
        thetaP=asin(sqrt(xx^2+yy^2));
        
        %nearest neighbor to get corresponding input pixel:
        thetaBin=round(thetaP/dAngle);
        phiBin=round(phiP/dAngle);
        
        if(thetaBin>0 && phiBin>0 && thetaBin<length(thetaOut) && phiBin<length(phiOut))
        C_sphere(ii, jj, :)=C(thetaBin, phiBin, :);
        end
        
        end
    end
end


end