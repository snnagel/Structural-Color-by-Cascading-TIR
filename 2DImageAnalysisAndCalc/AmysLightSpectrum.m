function [LightIntensity] = AmysLightSpectrum(wavelengths)
%Uses Data from the LED's spectrum to return input spectrum for given
%wavelengths

filename='inputLightSpectrum/WhiteLight.xlsx'
sheet = 1;
xlRange = 'A1:B3468';

Data = xlsread(filename,sheet,xlRange);

LightIntensity=interp1(Data(:,1),smooth(Data(:,2)),wavelengths, 'pchip', 0)
LightIntensity=LightIntensity/max(LightIntensity);



end

