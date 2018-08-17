clear;clc;
tic;

cd '/home/chris/ap_clustering';
run('/home/chris/桌面/tool/vlfeat-0.9.20/toolbox/vl_setup');
file =char('A1','A2','B1','B2','C1','C2','D1','D2','E1','E2','F1','F2','G1','G2','H1','H2','I1','I2','J1','J2','K1','K2','L1','L2');
cellsize =32;
center_all=[];
class=24;
cluster=zeros(class,class);
load('/home/chris/ap_clustering/lbp_all.mat');


all=100;
nn=20;

for test=1:1
x=[];
b=randperm(all);
    for y=1:24
        for z=1:nn
            n=((y)-1)*all+b(z);
            x=[x;lbp_feature( n ,  : ) ];
            %x=[x;cnn_fc6( n ,  : ) ];
        end
    end
    data=x;
    nbclusters=14;
    sigma = 10;
    

[clusters, evalues, evectors] = spcl(data, nbclusters,sigma,'kmean', [2 2]);

 center=zeros(24,1);
 for i=1:24
     for j=1:nn
         num= mode(clusters( (i-1)*nn+1:i*nn));
         center(i)=num;
     end
 end
%}
center_all=[center_all,center];

end

x =center_all;
count=zeros(14,10);
result = zeros(14,10);
for test=1:5
    cluster=0;
for i=1:24
    
    if(count(x(i,test),test)==0)
        count(x(i,test),test)=1;
        number= find(x(:,test)==x(i,test));
        for j = number'
            result(j,test)=cluster;
        end
    cluster=cluster+1;
    
    end
    
end
end