clear;clc;
tic;

file =char('A1','A2','B1','B2','C1','C2','D1','D2','E1','E2','F1','F2','G1','G2','H1','H2','I1','I2','J1','J2','K1','K2','L1','L2');
cd '/home/chris/caffe-master/chm_cross/chm12';

%{
for f=13:24
    for fold=1:5
    cd '/home/chris/caffe-master/chm_cross/chm12';
    list=dir(['cross/',num2str(file(f,:)),'/',num2str(fold),'/*.jpg']);
    name=sort_nat({list.name});
    num = length(list);
    keypoint=[];
    desc=[];
         for img =1:num
                cd '/home/chris/caffe-master/chm_cross/chm12';
                imm=imread(['cross/',num2str(file(f,:)),'/',num2str(fold),'/',cell2mat(name(img))]);              
                im = imresize(imm,[256 256]);
                
                im=rgb2gray(im);  
                cd '/home/chris/caffe-master/chm_cross/siftDemoV4';
                imwrite(im,'v1.jpg','quality',80);  
               [image, descrips, locs] = sift('v1.jpg');  
               [m,n]=size(descrips);
               desc = [desc ; descrips];
               keypoint = [keypoint , m] ;
               %showkeys(image, locs);
               
         end
         cd '/home/chris/caffe-master/chm_cross/chm12';
        save(['sift/',num2str(file(f,:)),'/desc_',num2str(fold),'.mat'],'desc');
        save(['sift/',num2str(file(f,:)),'/keypoint_',num2str(fold),'.mat'],'keypoint');
    
    end
end
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
v_1=[1,2,3,4,5];
v_2=[2,3,4,5,1];
v_n=char('v12','v23','v34','v45','v51');


%{
for v_go=1:5
v_d_train=[];
v_k_train=[];

for herb=1:24
    for c_fold=1:5
        if(c_fold == v_1(v_go)|| c_fold ==v_2(v_go))
             continue 
        else        
            load(['sift/',num2str(file(herb,:)),'/desc_',num2str(c_fold),'.mat'])
            load(['sift/',num2str(file(herb,:)),'/keypoint_',num2str(c_fold),'.mat'])
            v_d_train=[v_d_train;desc];
            v_k_train=[v_k_train,keypoint];
        end%if end     
    end 
end
save(['sift/desc_',num2str(v_n(v_go,:)),'_train.mat'],'v_d_train');
save(['sift/keypoint_',num2str(v_n(v_go,:)),'_train.mat'],'v_k_train');
        
v_d_test=[];
v_k_test=[];
for herb=1:24
    for c_fold=1:5
        if(c_fold ~= v_1(v_go) && c_fold ~=v_2(v_go))
             continue 
        else        
            load(['sift/',num2str(file(herb,:)),'/desc_',num2str(c_fold),'.mat'])
            load(['sift/',num2str(file(herb,:)),'/keypoint_',num2str(c_fold),'.mat'])
            v_d_test=[v_d_test;desc];
            v_k_test=[v_k_test,keypoint];
        end%if end     
    end 
end
save(['sift/desc_',num2str(v_n(v_go,:)),'_test.mat'],'v_d_test');
save(['sift/keypoint_',num2str(v_n(v_go,:)),'_test.mat'],'v_k_test');

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%}
%}



for v_go=1:5
    
 load(['sift/desc_',num2str(v_n(v_go,:)),'_test.mat'])
 load(['sift/keypoint_',num2str(v_n(v_go,:)),'_test.mat'])

 
data = v_d_test' ;
 x = v_k_test;
 
 
numClusters = 200 ;
%{
[centers, assignments] = vl_kmeans(data, numClusters); 
save(['sift/center_',num2str(v_n(v_go,:)),'.mat'],'centers');
%}


numdata=960;%1440/960
count=40;%60/40
load(['sift/center_',num2str(v_n(v_go,:)),'.mat'])
row =0 ;    


fid=fopen(['sift/sift_',num2str(v_n(v_go,:)),'_test.txt'],'at');

for img =1:numdata
        vector=zeros(numClusters,1);  
        for q=1:x(img)      
            y = data(:,q+row);
            [~, k] = min(vl_alldist(y, centers)) ;
            vector(k) = vector(k)+1;
        end
        row = row + x(img); %desc扣掉keypoint數量
        
          fprintf(fid,'%d ',fix((img-1)/count));
          for i=1:numClusters
              if(vector(i)~=0)
                fprintf(fid, '%d:%d ', i, vector(i) );
              end
          end
          fprintf(fid,'\n');
        
    
end
fclose(fid);

end
toc;