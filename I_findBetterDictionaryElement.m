function [betterDictionaryElement,CoefMatrix] = I_findBetterDictionaryElement(Data,Dictionary,BETA,j,CoefMatrix,DA2)

%找出用了字典中的该列表达的那几列数据
relevantDataIndices = find(CoefMatrix(j,:));
if (length(relevantDataIndices)<1)
    ERR=BETA.*(Data-Dictionary*CoefMatrix);
    sumerr=sum(ERR.^2);
    [indx]=find(sumerr==max(sumerr));
    pos=indx(1);
    betterDictionaryElement=(Data(:,pos)./BETA(:,pos))/norm((Data(:,pos)./BETA(:,pos)));
    
     
     CoefMatrix(j,:) = 0;

    return;
end
%% improved weighed lowrank
% [n,m]                                                          = size(BETA(:,relevantDataIndices));
% betterDictionaryElement                                        = zeros(n,1);
% betaVector                                                     = zeros(m,1);
% iter                                                           = 20;
% for i = 1:iter
% tmpCoefMatrix                                                  = CoefMatrix(:,relevantDataIndices); 
% tmpBETA                                                        = BETA(:,relevantDataIndices);
% tlabel                                                         = zeros(1,length(relevantDataIndices));
% dictemp                                                        = Dictionary(:,j);
% error                                                          = zeros(size(Data(:,relevantDataIndices)));
% for i3 = 1:length(relevantDataIndices)
%     tlabel(1,i3)                                               = dictemp'*diag(tmpBETA(:,i3))*dictemp;
%     error(:,i3)                                                = tmpBETA(:,i3).*(Data(:,i3)-Dictionary*tmpCoefMatrix(:,i3))+tlabel(1,i3)*dictemp*tmpCoefMatrix(j,i3);
% end
% ttemp                                                          = sum(BETA,2);
% t1                                                             = diag(ttemp)/length(relevantDataIndices);
% dictemp                                                        = Dictionary(:,j);
% t                                                              = dictemp'*t1*dictemp;
% save('test.mat','t');
% error                                                          = tmpBETA.*(Data(:,relevantDataIndices)-Dictionary*tmpCoefMatrix)+dictemp*tmpCoefMatrix(j,:);
% error                                                          = tmpBETA.*(Data(:,relevantDataIndices));
% for ii=1:size(t,2)
%     error(:,ii)=error(:,ii)+t(ii)*dictemp(:,ii)*tmpCoefMatrix(j,ii);
% end
% [betterDictionaryElement,singularValue,betaVector_t]           = svds(error,1);
% betaVector                                                     = betaVector_t*singularValue;
% CoefMatrix(j,relevantDataIndices)                              = betaVector';
% end

% %得到这几列数据对应于相应字典中该列的系数
tmpCoefMatrix = CoefMatrix(:,relevantDataIndices); 
% 
% %求出当去掉这几列数据的表达中的该列的成分后，这几列数据与它们的表达之间的误差
tmpCoefMatrix(j,:) = 0;
Error =(Data(:,relevantDataIndices) - Dictionary*tmpCoefMatrix); 
% Error= DA2(:,relevantDataIndices)+Dictionary(:,j)* CoefMatrix(j,relevantDataIndices); 
% %求新的该列，使误差在减去该列的表达后最小。并求出对应的系数。
% % tmpBETA=BETA(:,relevantDataIndices);
[u,s,v]=svds(Error,1);
betterDictionaryElement=u;
          betaVector=s*v;
% % a=CoefMatrix(j,relevantDataIndices) ;
% % [betterDictionaryElement,betaVector]=weirank(tmpBETA,errors,errorGoal,DCT);
% 
% %更新系数矩阵
CoefMatrix(j,relevantDataIndices) =betaVector';% *signOfFirstElem
% disp(j)
end    
