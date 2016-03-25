O_image = double(imread('201.png'));
psnrper = zeros(15,25);mseper = zeros(15,25);
for i = 1:25
    for j = 1:15
        temp = reshape(imageper25(:,j,i),[256 256]);
        psnrper(j,i) = 20*log10(255/sqrt(mean((temp(:)-O_image(:)).^2)));mseper(j,i) = sqrt(mean((temp(:)-O_image(:)).^2));
    end
end