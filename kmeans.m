clear;clc;
tic;

file =char('A1','A2','B1','B2','C1','C2','D1','D2','E1','E2','F1','F2','G1','G2','H1','H2','I1','I2','J1','J2','K1','K2','L1','L2');
cd '/home/chris/caffe-master/chm_cross/chm12';


load('/home/chris/ap_clustering/lbp.mat');

center_all=[];
for test=1:5
x=[];
nn=20;
d=60;
b=randperm(d);
    for y=1:24
        for z=1:20
            n=((y)-1)*d+b(z);
            x=[x;lbp_feature( n ,  : ) ];
            %x=[x;cnn_fc6( n ,  : ) ];
        end
    end
    data = x' ;
    numClusters = 14 ;
    [centers, assignments] = vl_kmeans(data, numClusters); 

numdata = 480;

 center=zeros(24,1);
 for i=1:24
     for j=1:nn
         num= mode(assignments( (i-1)*nn+1:i*nn));
         center(i)=num;
     end
 end
%}
center_all=[center_all,center];
end

toc;