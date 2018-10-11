function [ theta, phi, remapped] = PingPongToMap3D(imFilename, camAng, centerCoord, R, N, width  )
% Takes Amy's ping pong ball images and gives back a color bar and 
% corresponding angles. camAng should be in radians (theta, phi),
% centerCoord, R in pixels. 
%widht is in radians
%read in image: 
inputIm=imread(imFilename);
figure
%for viewing:
subplot(1, 2, 1)
image(inputIm*1.3);
axis image

subplot(1, 2, 2)
image(inputIm*1.3);
axis image

if nargin < 6
width=40 %pixels in x direction to average. 
end
if nargin < 5
N=180 %number of angles 
end
inputIm=double(inputIm).^1/2.2;
hold on
xc=centerCoord(1)
yc=centerCoord(2)

azAng=camAng(2)
polAng=camAng(1)

plot(xc, yc, 'ob')
phi=linspace(-width, width, round(N*width/pi*2))
remapped=zeros(length(phi), N, 3)
theta=linspace(-pi/2, pi/2, N)

rz=rotz(azAng*180/pi)
ry=roty(polAng*180/pi)

for ii=1:N
    thetai=theta(ii);
    for jj=1:length(phi)
        phij=phi(jj);
        
        realCoord=[sin(thetai)*cos(phij);sin(thetai)*sin(phij); cos(thetai)];
        mappedCoord=ry*rz*realCoord;
        beta=atan(mappedCoord(2)/mappedCoord(1));
        if mappedCoord(1)<0
            beta=beta+pi;
        end
        del=acos(mappedCoord(3));
        
        if del<pi/2    
            
        xp=round(xc-R*sin(del)*sin(beta));
        yp=round(yc-R*sin(del)*cos(beta));
        remapped(jj, ii,:)=inputIm( yp,xp, :);
        plot(xp,yp,  '.g');
        
        if thetai<pi/36 && thetai>-pi/36
            plot(xp, yp, '.w');
        end

        end
        
        
    end
end


end

