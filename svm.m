clear;clc;
tic
cd '/home/chris/libsvm-3.21/matlab'
[heart_scale_label, heart_scale_inst] = libsvmread('sift/sift_v51_train.txt');
[label, inst] = libsvmread('sift/sift_v51_test.txt');

%------------------------------------------------------------
model = svmtrain(heart_scale_label, heart_scale_inst);%
%lbp
%model = svmtrain(heart_scale_label, heart_scale_inst, '-c 32.0 -g 0.03125');%v12_34_45_51
%model = svmtrain(heart_scale_label, heart_scale_inst, '-c 512.0 -g 0.0078125');%v23

%hog
%model = svmtrain(heart_scale_label, heart_scale_inst, '-c 32.0 -g 0.03125');%v45
%model = svmtrain(heart_scale_label, heart_scale_inst, '-c 8.0 -g 0.125');%v12
%model = svmtrain(heart_scale_label, heart_scale_inst, '-c 512.0 -g 0.0078125');%v23
%model = svmtrain(heart_scale_label, heart_scale_inst, '-c 512.0 -g 0.001953125');%v34

%sift
%model = svmtrain(heart_scale_label, heart_scale_inst, '-c 128.0 -g 0.00048828125');%v45
%model = svmtrain(heart_scale_label, heart_scale_inst, '-c 128.0 -g 0.001953125');%v12
model = svmtrain(heart_scale_label, heart_scale_inst, '-c 32.0 -g 0.001953125');%v23_v34_51
[predict_label, accuracy, dec_values] = svmpredict(label, inst, model );
 %%%%%%%%%%%%%%%%%%%%%%%
 
 
 
 i=0;  
vector=[];
acc = [];
n=40;
    for x=1:24       
       v=zeros(24,1);
        for y=1:n
            a = predict_label(i+y);
           v(a+1)=v(a+1)+1;         
        end
        i=i+n;
        avg = v(x)/40;
        acc=[acc;avg];
        vector = [vector, v];
    end
vector =vector';
herb_acc = sum(acc)/24;
toc;