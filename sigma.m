for image_index=[  1  ]
    image_index=[num2str(image_index),'.png'];     
for L=[  1 2 4 8  ]
%    L=4; %%%%视数
   psnrtemp=zeros(2,1);
%    outputtemp = zeros(256*256,1);dictemp = zeros(64*256,1);coeftemp = zeros(256*249*249,1);
%    psnrper = zeros(1,1);mseper = zeros(1,1);ssimper = zeros(1,1);imageper25 = [];
  for iteration=[1:1] ; %%%%视数
      save('index.mat','image_index','L','iteration','psnrtemp');
%       clear all;
%       load index.mat;
      [O_image]=double((imread(num2str(image_index))));%%%%读一幅图
%       O_image = O_image(fix(512/4):fix(512/4)+255,fix(512/4):fix(512/4)+255);
%   randn('seed',0)
% s = zeros(size(O_image));
% for k = 1:L
%     s = s + abs(randn(size(O_image)) + 1i * randn(size(O_image))).^2 / 2;
% end
% N_image = O_image .* sqrt(s / L);%%%%%%%噪声图

N_image = O_image;
tic
output = improved_sigma_filtering(O_image,N_image,L);
time = toc
psnrtemp(1,iteration) = 20*log10(255/sqrt(mean((output(:)-O_image(:)).^2)));
psnrtemp(2,iteration) = time;

  end
  psnrfinal = mean(psnrtemp(1,:));
  tfinal = mean(psnrtemp(2,:));
  
  save ( ['F:\MatlabWork\new\code\2013.8.20-重叠SOMP-1 - 副本2\DATA\',num2str(image_index),'\4-20-intensity-improvedsigma-iter1','-psnrfinal',num2str(psnrfinal),'--t',num2str(tfinal),'--L=',num2str(L),'.mat']','output','psnrtemp');
end
end