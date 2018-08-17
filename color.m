clear;clc;
tic;
cd '/home/chris/caffe-master/chm_aug/chm_test';
file =char('A1','A2','B1','B2','C1','C2','D1','D2','E1','E2','F1','F2','G1','G2','H1','H2','I1','I2','J1','J2','K1','K2','L1','L2');

phone = {'iphone','xiaomi','samsung','asus'};
    e_xx=[];
    e_ss=[];
    e_aa=[];
    
    sum_i=[];
    sum_x=[];
    sum_s=[];
    sum_a=[];
    
for f=1:24
    list=dir(['iphone/test/',num2str(file(f,:)),'/*.jpg']);
    name=sort_nat({list.name});
    num = length(list);
    v_i=zeros(256,1);
    v_x=zeros(256,1);
    v_s=zeros(256,1);
    v_a=zeros(256,1);
%3
     for img = 1:40
                 im_i=imread(['iphone/test/',num2str(file(f,:)),'/',cell2mat(name(img))]); 
                 [m,n,p]=size(im_i);
                 for i=1:m
                     for j=1:n
                            value_r = im_i(i,j,1);
                            value_g = im_i(i,j,2);
                            value_b = im_i(i,j,3);
                            v_i(value_r+1)=v_i(value_r+1)+1;
                            v_i(value_g+1)=v_i(value_g+1)+1;
                            v_i(value_b+1)=v_i(value_b+1)+1;
                     end
                 end
                 
                 im_x=imread(['xiaomi/test/',num2str(file(f,:)),'/',cell2mat(name(img))]); 
                 [m,n,p]=size(im_x);
                 for i=1:m
                     for j=1:n
                            value_r = im_x(i,j,1);
                            value_g = im_x(i,j,2);
                            value_b = im_x(i,j,3);
                            v_x(value_r+1)=v_x(value_r+1)+1;
                            v_x(value_g+1)=v_x(value_g+1)+1;
                            v_x(value_b+1)=v_x(value_b+1)+1;
                     end
                 end
                 
                 im_s=imread(['samsung/test/',num2str(file(f,:)),'/',cell2mat(name(img))]); 
                 [m,n,p]=size(im_s);
                 for i=1:m
                     for j=1:n
                            value_r = im_s(i,j,1);
                            value_g = im_s(i,j,2);
                            value_b = im_s(i,j,3);
                            v_s(value_r+1)=v_s(value_r+1)+1;
                            v_s(value_g+1)=v_s(value_g+1)+1;
                            v_s(value_b+1)=v_s(value_b+1)+1;
                     end
                 end
                 
                 im_a=imread(['asus/test/',num2str(file(f,:)),'/',cell2mat(name(img))]); 
                 [m,n,p]=size(im_a);
                 for i=1:m
                     for j=1:n
                            value_r = im_a(i,j,1);
                            value_g = im_a(i,j,2);
                            value_b = im_a(i,j,3);
                            v_a(value_r+1)=v_a(value_r+1)+1;
                            v_a(value_g+1)=v_a(value_g+1)+1;
                            v_a(value_b+1)=v_a(value_b+1)+1;
                     end
                 end
                 
                    sum_i=[sum_i;im_i];
                    sum_x=[sum_x;im_x];
                    sum_s=[sum_s;im_s];
                    sum_a=[sum_a;im_a];
                 e_x = 0;
                 e_s=0;
                 e_a=0;
                 for n=1:256
                    %{  
                     e_x = e_x+abs(v_i(n)-v_x(n));
                        e_s = e_s+abs(v_i(n)-v_s(n));
                        e_a =e_a+abs(v_i(n)-v_a(n));
                    %}
                     
                     e_x = e_x+min(v_i(n),v_x(n));
                     e_s = e_s+min(v_i(n),v_s(n));
                     e_a = e_a+min(v_i(n),v_a(n))^2;
                    
                  end
                 
                                
     end

                 e_xx=[e_xx, e_x/40];
                 e_ss= [e_ss,e_s/40];
                 e_aa= [e_aa,e_a/40];
                 
                
end

                 e_xx=e_xx/(256*256*3);
                 e_ss= e_ss/(256*256*3);
                 e_aa= e_aa/(256*256*3);


figure;
                 h1=histogram(sum_i);
                 hold on
                 h2=histogram(sum_x);
                 h3=histogram(sum_s);
                 h4=histogram(sum_a);
toc;