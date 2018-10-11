%Image data (found manually from imageJ)
f='pingPongBallIm.CR2'
camAng=[45, 47]*pi/180;
centerCoord= [2356, 2203];
R=round(2697/2);
[ theta, phi, remapped]=PingPongToMap3D(inFile, camAng, centerCoord, R, 300, 0.1);
%[ theta, phi, remapped]=PingPongToMap3D_DrawLines(inFile, camAng, centerCoord, R, 18, pi);

%%
figure

subplot(3, 1, 1)
image( theta*180/pi,phi*180/pi, remapped/max(max(max(remapped))))
xlabel('\theta (^o)')
ylabel('\phi (^o)')
set(gcf, 'color', 'white')
title('Linearly Mapped')

%%
adjustB=repmat(1-0.8*abs(cos(theta+data(imNum, 1)/180*pi)), length(phi), 1, 3);

adjustedMap=adjustB.*remapped;

%
%%
subplot(3, 1, 2)
average=sum(remapped, 1)/length(phi)
image( theta*180/pi,phi*180/pi, average/max(max(max(remapped))))
xlabel('\theta (^o)')
ylabel('\phi (^o)')
set(gcf, 'color', 'white')
title('Averaged')


subplot(3, 1, 3)
average=sum(adjustedMap, 1)/length(phi)
image( theta*180/pi,phi*180/pi, average/max(max(max(adjustedMap))))
xlabel('\theta (^o)')
ylabel('\phi (^o)')
set(gcf, 'color', 'white')
title('Increased brightness at large angles:')
