function rgb  = colorConversion( wavelengths, Intensity )
%takes spectrum- list of wavelengths and intensity values and returns
%corresponding rgb values (Nx3 array) based on cie color conversion. 
%Wavelengths should be a Column vector!
%first dimension of Intensity corresponds to which wavelength
%(wavelengths x N)
%
%   Intensity can have dimension of 1, 2

%load CIE data
CIEXYZ_Data = dlmread('SpectrumToColor/ciexyz31.csv');
CIE_1 = interp1(CIEXYZ_Data(:,1),CIEXYZ_Data(:,2),wavelengths, 'pchip', 0);
CIE_2 = interp1(CIEXYZ_Data(:,1),CIEXYZ_Data(:,3),wavelengths, 'pchip', 0);
CIE_3 = interp1(CIEXYZ_Data(:,1),CIEXYZ_Data(:,4),wavelengths, 'pchip', 0);
%figure(3)
%plot(wavelengths)


N=size(Intensity, 2)
rgb=zeros(N, 3)
    
%Determine Color: 
maxIntensity=max(max(Intensity))

for ii=1:N

        inten=Intensity(:, ii);
        inten=inten/maxIntensity;
if ii==50
   % plot(inten)
end

            X = sum(inten.*CIE_1)/sum(CIE_1);
            Y = sum(inten.*CIE_2)/sum(CIE_2);
            Z = sum(inten.*CIE_3)/sum(CIE_3);
            
            XYZ=[X;Y;Z];
            
            xyzToRGB =  [3.2404542, - 1.5371385, - 0.4985314;
                        -0.9692660, 1.8760108, 0.0415560;
                        0.0556434, - 0.2040259, 1.0572252];
            


            rgb(ii, :)=xyzToRGB*XYZ;

            %sRGB:
            for jj=1:3
                if (rgb(ii, jj) > 0.0031308 ) 
                    rgb(ii, jj) = 1.055 * ( rgb(ii, jj) ^ ( 1 / 2.4 ) ) - 0.055;
                else                     
                    rgb(ii, jj) = 12.92 * rgb(ii, jj);
                end
            end

           
end

end

