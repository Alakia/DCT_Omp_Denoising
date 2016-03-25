function  [ksvd_step_output psnr_step D_step Dictionary] = KSVDNONH(Data,DCT,BETA,errorGoal,Image,BETA_sig,sigma,L)
% =========================================================================
%%
Dictionary                              = DCT;
%1 对初始的字典进行归一化处理
Dictionary                              = Dictionary*diag(1./sqrt(sum(Dictionary.*Dictionary)));
Dictionary                              = Dictionary.*repmat(sign(Dictionary(1,:)),size(Dictionary,1),1); % multiply in the sign of the first element.
iter                                    = 15;
ksvd_step_output                        = zeros(256*256,iter+1);
psnr_step                               = zeros(1,iter+1);
D_step                                  = zeros(64*256,iter+1);
% IOutstep                                = DenoisingByStep(Image,BETA_sig,Dictionary,sigma);
% ksvd_step_output(:,1)                   = IOutstep(:);
% psnr_step(1)                            = 20*log10(255/sqrt(mean((IOutstep(:)-Image(:)).^2)));
% D_step(:,1)                             = Dictionary(:);
%%
%2 对字典进行20次的更新
for iterNum = 1:iter
    disp(iterNum)
    CoefMatrix                               = OMPerrNONHtest(Dictionary,Data,BETA,errorGoal,8);
%     CoefMatrix                     = OMPerrNONHtestnew(Dictionary,Data,BETA,errorGoal,8);
% TSSC二次追踪     
% CoefMatrix_firstdenoiseblk = OMP(DCT,Data-Dictionary* CoefMatrix,10);
%     CoefMatrix_firstdenoiseblk          = OMPerrNONHtest(DCT,Data-Dictionary* CoefMatrix,BETA,0.85*errorGoal,53);
%     DA2                                 = DCT*CoefMatrix_firstdenoiseblk;
    DA2                                      = [];
    rPerm                                    = randperm(size(Dictionary,2));
    for j = rPerm
        [betterDictionaryElement,CoefMatrix] = I_findBetterDictionaryElement(Data,Dictionary,BETA,j,CoefMatrix, DA2 );
        Dictionary(:,j)                      = betterDictionaryElement;
    end  
%     IOutstep                                 = DenoisingByStep(Image,BETA_sig,Dictionary,sigma);
%     ksvd_step_output(:,iter+1)               = IOutstep(:);
%     psnr_step(iter+1)                        = 20*log10(255/sqrt(mean((IOutstep(:)-Image(:)).^2)));
%     D_step(:,iter+1)                         = Dictionary(:);
end
end



