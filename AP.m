clear;clc;
tic;

cd '/home/chris/ap_clustering';
run('/home/chris/桌面/tool/vlfeat-0.9.20/toolbox/vl_setup');
file =char('A1','A2','B1','B2','C1','C2','D1','D2','E1','E2','F1','F2','G1','G2','H1','H2','I1','I2','J1','J2','K1','K2','L1','L2');
cellsize =32;
center_all=[];
class=24; %中藥種類
cluster=zeros(class,class);
load('/home/chris/ap_clustering/lbp_all.mat'); % 取特徵，要先事先取好

data=100;%每種中藥數量
for test=1:1 %做十次test=10
x=[];
b=randperm(data);
    for y=1:24
        for z=1:20 %隨機挑前20張
            n=((y)-1)*data+b(z);
            x=[x;lbp_feature( n ,  : ) ];
        end
    end
[N,F]=size(x);
 M=N*N-N; s=zeros(M,3); % Make ALL N^2-N similarities
 j=1;
 for i=1:N
   for k=[1:i-1,i+1:N]

     s(j,1)=i; s(j,2)=k; s(j,3)=-sum((x(i,:)-x(k,:)).^2); %算相似度
     j=j+1;
   end;
end;
 %p=median(s(:,3)); % Set preference to median similarity
 p=min(s(:,3));
 [idx,netsim,dpsim,expref]=apcluster(s,p);
 
 
  center=zeros(class,1);
 set = N/class;
 for i=1:class
         num= mode(idx( (i-1)*set+1 : (i-1)*set+set));
         center(i)=num;
 end
 
 fprintf('Number of clusters: %d\n',length(unique(idx)));
 fprintf('Fitness (net similarity): %f\n',netsim);
 
 center_all=[center_all,center];

end


toc;