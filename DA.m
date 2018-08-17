clear;clc;
tic;
cd '/home/chris/caffe-master';
file =char('A1','A2','B1','B2','C1','C2','D1','D2','E1','E2','F1','F2','G1','G2','H1','H2','I1','I2','J1','J2','K1','K2','L1','L2');
%phone = {'iphone','xiaomi','samsung','asus'};

white =imread('chm_phone_aug/white.jpg');

for phone=1:4
    %a=char(phone(p));
    for f=1:24
    for fold=1:1  
    list=dir(['chm_phone/cross/',num2str(phone),'/',num2str(file(f,:)),'/*.jpg']); %照片路徑
    name=sort_nat({list.name});
    num = length(list);
        
    for img = 1:num
               %%%
               for i=1:length(list(img).name)
                    if(list(img).name(i)=='.')
                    only_name=i-1;
                    end
               end
               %%%
              im=imread(['chm_phone/cross/',num2str(phone),'/',num2str(file(f,:)),'/',list(img).name]); 
              im = imresize(im,[256 256]);
              [m,n,p] = size(im);
            
              %{
              %旋轉         
              A=imcomplement(im);
              A1 = imrotate(A,10,'bicubic','crop');
              A_1=imcomplement(A1);
              A2 = imrotate(A,-10,'bicubic','crop');
              A_2=imcomplement(A2);
              %figure,imshow(A_1);
              
              
              %放大
              im_big = imresize(im,4/3);
              [big_m,big_n,big_p]=size(im_big);
              im_big= im_big(  big_m/2-128   : big_m/2+127 , big_m/2-128  :  big_m/2+127 , : );
              A_3 = im_big;
              
              %縮小
              im_small = imresize(im,3/4); 
              small=white;
              for i = 31:222
                  for j =31:222
                        small(i,j,:)=im_small(i-30,j-30,:);
                  end
              end
              A_4 = small;
              
              
             %亮暗
              for x = 1:m
                for y = 1:n
                    bright_im(x,y,:) = im(x,y,:)+30;
                    dark_im(x,y,:)= im(x,y,:)-50;
                end
              end
            A_5 = bright_im;
            A_6= dark_im;
            %figure,imshow(bright_im);
            %figure,imshow(dark_im);
             %}
              
              %hisq 
                 hsv = rgb2hsv(im);
                 v=hsv(:,:,3);
                 %vv = histeq(v);
                 vv=adapthisteq(v);
                 hsv(:,:,3)=vv;
                 A_7=hsv2rgb(hsv);

            %imwrite(im,['chm_phone_aug/aug/',num2str(a),'/',num2str(file(f,:)),'/',list(img).name]);
            for n=7:7
                eval(['imm=A_',num2str(n),';']); 
                imwrite(imm,['chm_phone_aug/aug/',num2str(phone),'/',num2str(file(f,:)),'/',list(img).name(1:only_name),'_',num2str(n),'.jpg']);
                 
            end
            
        
       end
    end   
    end
end

toc;