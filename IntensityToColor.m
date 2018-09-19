function [C] = IntensityToColor(wavelengths, Inten)

%A(theta, phi, wavelength, vertical pol/horizontal pol)
%the intensity in the two polarization direction is added together. 

%Determine Color: 

%load CIE data
CIEXYZ_Data = dlmread('SpectrumToColor/ciexyz31.csv');
CIE_1 = interp1(CIEXYZ_Data(:,1),CIEXYZ_Data(:,2),wavelengths*1000, 'pchip', 0);
CIE_2 = interp1(CIEXYZ_Data(:,1),CIEXYZ_Data(:,3),wavelengths*1000, 'pchip', 0);
CIE_3 = interp1(CIEXYZ_Data(:,1),CIEXYZ_Data(:,4),wavelengths*1000, 'pchip', 0);

%initiate colormap to zero: 
C=zeros(size(Inten, 2), size(Inten, 3), 3);

maxIntensity=max(max(max(Inten)));

for ll= 1:size(Inten, 2)
    for jj=1:size(Inten, 3)

        %normalize across whole image:
        intensity=Inten( :, ll, jj)/maxIntensity;
       
        %multiply and integrate with color matching functions
        if not(sum(intensity)==0)
            X = sum(intensity'.*CIE_1)/sum(CIE_1);
            Y = sum(intensity'.*CIE_2)/sum(CIE_2);
            Z = sum(intensity'.*CIE_3)/sum(CIE_3);

            XYZ=[X;Y;Z];
            
            %conversion matrix:
            xyzToRGB =  [3.2404542, - 1.5371385, - 0.4985314;
                        -0.9692660, 1.8760108, 0.0415560;
                        0.0556434, - 0.2040259, 1.0572252];
            
            %linear rgb:
            rgb=xyzToRGB*XYZ;

            %sRGB (gamma correction):
            for kk=1:3
                if (rgb(kk) > 0.0031308 ) 
                    rgb(kk) = 1.055 * ( rgb(kk) ^ ( 1 / 2.4 ) ) - 0.055;
                else                     
                    rgb(kk) = 12.92 * rgb(kk);
                end
            end
            
            %color map:
            C(ll, jj, 1)=rgb(1);
            C(ll, jj, 2)=rgb(2);
            C(ll, jj, 3)=rgb(3);

           
        end
    end
end
end