clear;clc;
tic;
cd '/home/chris/caffe-master/';


result = load('chm_python/phone_aug/phone_aug_asus.txt'); %文件
%label = result(:,2);
%predict_label = result(:,3);
acc = [];
i=0;  
vector=[];
n=40;
    for x=1:24   
       v=zeros(24,1);
        for y=1:n
            a = result(i+y);
           v(a+1)=v(a+1)+1;         
        end
        i=i+n;
        avg = v(x)/40;
        acc=[acc;avg];
        vector = [vector, v];
    end
vector1 =vector';
herb_acc = sum(acc)/24;

toc;