function output = improved_sigma_filtering(im,nim,L)

%     close all;
%     clear all;
%     clc;
%     load squaretext;
%     load noisesquaretext;
    yita=1;%%%%for one-look intensity, ηv=1 for one-look amplitude data, ηv=0.5227 
    Tk=6  ; %%%%%%%%%%%%%%%%%%%% 5 6 7 
    
    
     
    %%%%improved sigma filter%%%%%
%     image='image_Cameraman256.png';
%     image='F:\matlab\zd_text_improved_sigma_filtering\squaretext.png';
%     image='F:\matlab\zd_text_improved_sigma_filtering\squaretext.png';
%     im=double(imread(image));

%     im=squaretext;
% im=double(imread(image));
%     figure
%     imshow(uint8(im));
    %%%%%%%%%%%%%%%%%%%%%%%%%产生sar图像%%%%%%%%%%%%%%
%     load sarnoise.mat;
%     nim=im.*sarnoise_onelook;
%     image='F:\matlab\zd_text_improved_sigma_filtering\sarnoisecameraman.png';
%     image='F:\matlab\zd_text_improved_sigma_filtering\sarnoisesquaretext.png';
%      image='F:\matlab\zd_text_improved_sigma_filtering\sarnoisesquaretext2.png';
%     nim=double(imread(image));
%     nim=noisesquaretext;
%     figure
%     imshow(uint8(nim));
    [M,N]=size(im);
    n=round(0.98*M*N);
    l=sort(nim(:));
    level=l(n);
    
    
%     level=max(max(nim));
    
    mode=zeros(11,11);
    mode33=zeros(3,3);
    background=zeros(M,N);
    expandim=[zeros(5,5) zeros(5,N) zeros(5,5);zeros(M,5) nim zeros(M,5);zeros(5,5) zeros(5,N) zeros(5,5)];%%expand the image uses 5 Ls with 0%%
    expandbackground=[zeros(5,5) zeros(5,N) zeros(5,5);zeros(M,5) background zeros(M,5);zeros(5,5) zeros(5,N) zeros(5,5)];
    newim=zeros(M,N);
    %%%%%% I1    I2   I2-I1  yita      
    if L == 1
%     tableI=[0.436,1.92,1.484,0.4057;   %sigma =  0.5
%         0.343,2.12,1.868,0.4954;      %         0.6
%         0.254,2.582,2.328,0.5911;     %         0.7 
%         0.168,3.094,2.926,0.6966;     %         0.8
%         0.084,3.941,3.857,0.8191;     %         0.9
%         0.043,4.840,4.797,0.8599] ;    %         0.95

tableI=[0.653997,1.40002,0.746019,0.208349;   %sigma =  0.5
            0.578998,1.50601,0.927012,0.255358;      %         0.6
            0.496999,1.63201,1.13501,0.305303;     %         0.7 
            0.403999,1.79501,1.39101,0.361078;     %         0.8
            0.286000,2.04301,1.75701,0.426375;     %         0.9
            0.203000,2.25998,2.05698,0.466398] ;    %         0.95
    elseif L == 4
%         tableI=[0.694,1.385,0.691,0.1921;   %sigma =  0.5
%             0.630,1.495,0.865,0.2348;      %         0.6
%             0.560,1.627,1.067,0.2825;     %         0.7 
%             0.480,1.804,1.324,0.3354;     %         0.8
%             0.378,2.094,1.716,0.3991;     %         0.9
%             0.302,2.360,2.058,0.4391] ;    %         0.95
        tableI=[0.832,1.179,0.347,0.0894192;   %sigma =  0.5
            0.793,1.226,0.433,0.112018;      %         0.6
            0.747,1.279,0.532,0.139243;     %         0.7 
            0.691,1.347,0.656,0.167771;     %         0.8
            0.613,1.452,0.839,0.201036;     %         0.9
            0.548,1.543,0.995,0.222048] ;    %         0.95
    end
    %%%%%% A1    A2   A2-A1  yita                        
    tableA=[0.653997,1.40002,0.746019,0.208349;   %sigma =  0.5
        0.578998,1.50601,0.927012,0.255358;      %         0.6
        0.496999,1.63201,1.13501,0.305303;     %         0.7 
        0.403999,1.79501,1.39101,0.361078;     %         0.8
        0.286000,2.04301,1.75701,0.426375;     %         0.9
        0.203000,2.25998,2.05698,0.466398] ;    %         0.95

    %%%%%%%%%%%%%%%%%%强散射点目标标记：
    for i=1:M
        for j=1:N
            exi=i+5;exj=j+5;
            if expandim(exi,exj)>=level
                mode33=zeros(3,3);
                k=0;
                for mi=-1:1
                    for mj=-1:1
                        if expandim(exi+mi,exj+mj)>=level
                            k=k+1;
                            mode33(mi+2,mj+2)=1;
                        end
                    end
                end
                if k>=Tk;
                    for mi=-1:1
                        for mj=-1:1
                            if mode33(mi+2,mj+2)==1
                                expandbackground(exi+mi,exj+mj)=mode33(mi+2,mj+2);
                                newim(i+mi,j+mj)=nim(i+mi,j+mj);
                            end
                        end
                    end
                end
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  j=20;
%  i=43;
for i=1:M
    for j=1:N
        exi=i+5;exj=j+5;
        if expandbackground(exi,exj)==0;   %%%%%%%%%%%%%%%%%%%%%%%%%%%%未标记点进行MMSE
            mode33=expandim(exi-1:exi+1,exj-1:exj+1);
            L=reshape(mode33,9,1);
            seed1=MMSE(L,expandim(exi,exj),yita);
            sigmarange=tableI(5,1:2)*seed1;
            L1=[];
            size11=0;
            for i11=-5:5
                for j11=-5:5
                    if (expandim(exi+i11,exj+j11)>=sigmarange(1))&&(expandim(exi+i11,exj+j11)<=sigmarange(2))
%                            background(i+i11,j+j11)=255;
                        size11=size11+1;
                        L1(size11)=expandim(exi+i11,exj+j11);
                    end
                end
            end
            [m,n]=size(L1);
            L1=reshape(L1,m*n,1);
%             figure
%             imshow(uint8(background))
%             if isempty(L)
%                 newim(i,j)=nim(i,j);
%             else
                seed2=MMSE(L1,expandim(exi,exj),tableI(5,4));
                newim(i,j)=seed2;
%             end
        else
            newim(i,j)=nim(i,j);
        end
    end
end

output  = newim;


% figure
% 
% imshow(uint8(newim));
% K=PSNR(uint8(im),uint8(newim))
% imim=[im nim newim];
% imshow(uint8(imim))
% imwrite(uint8(newim),'F:\matlab\zd_text_improved_sigma_filtering\cameramanresultlee.png')
%%%%%%%%%%%%%均值滤波
% filterave=fspecial('average',[5 5]);
% aveim=imfilter(nim,filterave);  %% aveim: use average filter to operate %%
% figure;title('average filting use 5*5 matrix')
% aveim=uint8(aveim);
% imshow(aveim);
% imwrite(uint8(aveim),'F:\matlab\zd_text_improved_sigma_filtering\cameramanresultave55.png')


% 
% %%%%计算四块的均值%%%%%%%%%
% % image='F:\matlab\zd_text_improved_sigma_filtering\squaretextresult2TK=6.png.png'
% % im=imread(image);
% im=newim;
% A=[mean(reshape(im(40:89,40:89),1,2500)) ,mean(reshape(im(40:89,168:217),1,2500)) ,mean(reshape(im(168:217,40:89),1,2500)) ,mean(reshape(im(168:217,168:217),1,2500))]
% %%%%%%%%%%%%计算亮点均值
% 
% x=[];
% for i=1:256
%     if mod(i,12)==8
%         
%         x=cat(1,x,newim(127:129,i-1:i+1));
%         x=cat(1,x,newim(i-1:i+1,127:129)');
%     end
% end
% A=mean(x(:))
%%%%%%%计算背景

end