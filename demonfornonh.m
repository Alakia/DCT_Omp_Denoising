clc;clear all
        bb  = 8; 
        K   = 256;
        C   = 1.1;
       
for image_index = [  1502 ]
    image_index = [num2str(image_index),'.png']; 
        for L = [ 1  ]; %%%%视数
            psnrtemp           = zeros(2,1);IFinal = [];
            dictemp = zeros(64*256,1);coeftemp = zeros(512*(512-8+1)*(512-8+1),1);
            psnrper = zeros(1,1);mseper = zeros(1,1);ssimper = zeros(1,1);mseblk = zeros(1,255025);
%             recount = zeros(1,25);
            for iteration = 1:1
                disp(iteration);
                save('index.mat','image_index','L','iteration','bb','K','C','psnrtemp','dictemp','coeftemp','psnrper','mseper','ssimper','mseblk');
                clear all;
                load  index.mat;
                [O_image]      = double((imread(num2str(image_index))));%%%%读一幅图
                slidingDis     = 1;   
%                 randn('seed', 0); 
%                 i              = sqrt(-1);
%                 s              = zeros(size(O_image));
%                     for k = 1:L
%                         s      = s + abs(randn(size(O_image)) + 1i * randn(size(O_image))).^2 / 2;
%                     end
%                 N_image        = O_image .* sqrt(s / L);%%%%%%%噪声图
%                 N_image = O_image + L*randn(size(O_image));
                
                N_image = O_image;
                mean_noise     = gamma(L+0.5)*(1/L)^(1/2)/gamma(L);%%%%%%%噪声的均值
                SN_image       = N_image/mean_noise;
%                 SN_image       = N_image;
%                 PSNRIn = 0;
                PSNRIn           = 20*log10(255/sqrt(mean((SN_image(:)-O_image(:)).^2)));
                %%%%%%%%%%求权值矩阵
                [m,n]          = size(N_image);
                p_image        = padarray(N_image,[3 3],'symmetric');
                e_image        = zeros(m,n);
                    for  k = 1:m
                        for j = 1:n
                            e_image(k,j) = mean(mean( p_image(k:k+6,j:j+6)));
                        end
                    end
                matrix_sigma   = ((e_image/mean_noise).*(4/pi-1)^0.5)./L.^0.5;
                tic
                [mseblk0 ksvd_step_output psnr_step D_step IOut Dictionary Coefs] = denoiseImageKSVDNONH(O_image,SN_image,matrix_sigma,bb,K,C,slidingDis,L);
                time              = toc;
%                 PSNROut = 0;
                SNRtmp = (sum(sum(N_image.^2)))/(sum(sum((IOut(:)-N_image(:)).^2)));
                SNR = 10*log10(SNRtmp);
                ratioimg = IOut./SN_image;
                PSNROut           = 20*log10(255/sqrt(mean((IOut(:)-O_image(:)).^2)));MSE = sqrt(mean((IOut(:)-O_image(:)).^2));
                psnrtemp(1,iteration) = PSNROut;
                psnrtemp(2,iteration) = time;
%                 mseblk(iteration,:) = mseblk0;
                K3 = [0.01 0.03];
                window3 = ones(8);
                L3 =max(IOut(:));
                [mssim, ssim_map] = ssim(O_image,IOut, K3, window3, L3);
                IOuttemp = IOut(:);
%                 for number = 1:15
%     psnrper(iteration,number) = 20*log10(255/sqrt(mean((IOuttemp-O_image(:)).^2)));
%     mseper(iteration,number) = sqrt(mean((IOuttemp-O_image(:)).^2));
%     [mssim, ssim_map] = ssim(O_image,IOut);
%     ssimper(iteration,number) = mssim;
% end
%                 outputtemp(:,iteration) = IOut(:);
%                 dictemp(:,iteration) = Dictionary(:);
%                 coeftemp(:,iteration) = Coefs(:);
                [tp1 tp2] = size(Coefs);


%                 if PSNROut >= max(psnrtemp(1,:))
%                     save('maxksvddis2error.mat','IOut');
%                     IFinal = IOut;
%                 end
%                 if PSNROut <= max(psnrtemp(1,:))
%                     save('minksvddis2error.mat','IOut');
%                 end
                disp(PSNRIn);disp(PSNROut);disp(time);
            end
            mseblkmean = mean(mseblk,2);
            PSNRFinal = mean(psnrtemp(1,:));
            TFinal    = mean(psnrtemp(2,:));
            tempp1 = psnrtemp(1,:);
            [num bes] = max(tempp1);
%             bestoutput = reshape(outputtemp(:,bes),[512 512]);
%             bestdic = reshape(dictemp(:,bes),[64 256]);
%             bestcoef = reshape(coeftemp(:,bes),[tp1 tp2]);
%             [coefplots] = coefplot(bestcoef);
            bestoutput = [];bestdic = [];bestcoef = [];coefplots = [];
            figure;imshow(IOut,[]);
%             save(['F:\MatlabWork\new\code\2013.7.14-OMP部分代码效果调试 -3\data\',num2str(image_index),'\+Dmse1-18-newim2col-collectratioimg-omp8-realper1-iter1','--L=',num2str(L),'-Psnrout',num2str(PSNRFinal),'-Psnrin',num2str(PSNRIn),'-mse',num2str(MSE),'-ssim',num2str(mssim),'-SNR',num2str(SNR),'-Time=',num2str(TFinal),'.mat']','psnrtemp','dictemp','coeftemp','coefplots','bestoutput','bestdic','bestcoef','IOut','psnrper','ssimper','Coefs','Dictionary','mseblk','mseblkmean','ratioimg');
        end
end

% end
