clear all;
clc;
Sinogram = ones(4096,256);
Sinogram(1:2000,:) = 0;
%%输入
image = zeros(400,400);
R = 55e-3;%环
pixel_s = 0.1e-3;
fr = 40e6;
angel = 2*pi/256;
vs = 1.5e3;
for i = 1:1:400
    for j = 1:1:400
        pa =0;
        for k = 1:1:256
            t = floor(sqrt(((j-200)*pixel_s-(cos(k*angel - pi)*R))^2+((i-200)*pixel_s-(sin(k*angel -pi)*R))^2)/vs*fr)+1;
		    pa = pa+Sinogram(t,k);
		end
		image(i,j) = pa;
	end
end
imagesc(image);
