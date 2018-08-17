clear;clc;
tic;
cd '/home/chris/caffe-master/chm_cross/chm12';
run('/home/chris/桌面/tool/vlfeat-0.9.20/toolbox/vl_setup');
file =char('A1','A2','B1','B2','C1','C2','D1','D2','E1','E2','F1','F2','G1','G2','H1','H2','I1','I2','J1','J2','K1','K2','L1','L2');
cellsize =32;
lbp_feature=[];
%{
for f=1:24
    for fold=2:4
    list=dir(['cross/',num2str(file(f,:)),'/',num2str(fold),'/*.jpg']);
    name=sort_nat({list.name});
    num = length(list);
    
         for img =1:num
                imm=imread(['cross/',num2str(file(f,:)),'/',num2str(fold),'/',cell2mat(name(img))]); 
                im = imresize(imm,[256 256]);
                im = single(rgb2gray(im));
                F= vl_lbp(im,cellsize);
                [M,N,P]=size(F);
                lbp= reshape(F, 1,M*N*P );
                lbp_feature = [lbp_feature;lbp];
         end
         %save(['lbp/',num2str(file(f,:)),'/lbp_',num2str(cellsize),'_',num2str(fold),'.mat'],'lbp_feature');
          %save('/home/chris/ap_clustering/lbp_all.mat','lbp_feature');
    end
    
end

save('/home/chris/ap_clustering/lbp_v51.mat','lbp_feature');
%}

v_1=[1,2,3,4,5];
v_2=[2,3,4,5,1];
v_n=char('v12','v23','v34','v45','v51');

for v_go=2:5
    fid=fopen(['lbp/lbp_',num2str(v_n(v_go,:)),'_train.txt'],'at');
for herb=1:24
    for c_fold=1:5
        if(c_fold == v_1(v_go)|| c_fold ==v_2(v_go))
             continue 
        else             
            load(['lbp/',num2str(file(herb,:)),'/lbp_',num2str(cellsize),'_',num2str(c_fold),'.mat'])
            [m,n] = size(lbp_feature);   %m:照片個數 n:特徵維度
            %%%%%
            for i=1:m
                fprintf(fid,'%d ',herb-1);
                for j=1:n
                    fprintf(fid, '%d:%f ', j, lbp_feature(i,j) ); 
                end
                fprintf(fid,'\n');
            end
            %%%%%
        end%if end
        
    end
    
end
fclose(fid);


fid=fopen(['lbp/lbp_',num2str(v_n(v_go,:)),'_test.txt'],'at');
for herb=1:24
    for c_fold=1:5
        if(c_fold ~= v_1(v_go)&& c_fold ~=v_2(v_go))
             continue 
        else   
            load(['lbp/',num2str(file(herb,:)),'/lbp_',num2str(cellsize),'_',num2str(c_fold),'.mat'])
            [m,n] = size(lbp_feature);   %m:照片個數 n:特徵維度
            %%%%%
            for i=1:m
                fprintf(fid,'%d ',herb-1);
                for j=1:n
                    fprintf(fid, '%d:%f ', j, lbp_feature(i,j) ); 
                end
                fprintf(fid,'\n');
            end
            %%%%%
        end%if end
        
    end
    
end

fclose(fid);

end

toc;