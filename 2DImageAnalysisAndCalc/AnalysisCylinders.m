
CA=70 %degrees
R=10/sind(CA) %Microns
n1=1.51
n2=1.0
illumAngles=0
figure
wavelengths=linspace(0.300, 0.800, 200);

%angle range to approximate non-collimation of beam:
coneSize=5

%Spectra of the incoming fiber light:
inSpectra=repmat(AmysLightSpectrum(fliplr(wavelengths*1000))', 1, length(theta));



    inputAngle=0
    outMap=zeros(length(wavelengths), length(theta));

for jj=-coneSize:.5:coneSize
    oMap=analyticalCalc(wavelengths, theta, R, CA, inputAngle+jj, n1, n2);
    outMap=outMap+oMap;
end


outMap=outMap.*inSpectra;

colors=colorConversion( fliplr(wavelengths)'*1000, outMap );
colorDist=zeros(1, size(colors, 1), 3);
for ii=1:size(colors, 1)
    colorDist(:, ii, 1)=colors(ii,1);
    colorDist(:, ii, 2)=colors(ii,2);
    colorDist(:, ii, 3)=colors(ii,3);
end
%%
image( theta*180/pi,phi*180/pi,  permute(colorDist, [1,2,  3])*1.2)
xlim([0, 90])

set(gcf, 'color', 'white')

%create colorMap from ping pong ball image: 
MakeColorMap
figure
subplot(2, 1, 1)
image( theta*180/pi,phi*180/pi,  permute(colorDist, [1,2,  3])*1.2)
xlim([-90, 0])

set(gcf, 'color', 'white')

subplot(2, 1, 2)
image( theta*180/pi,phi*180/pi, average/max(max(max(adjustedMap))))
xlabel('\theta (^o)')
ylabel('\phi (^o)')
xlim([-90, 0])
