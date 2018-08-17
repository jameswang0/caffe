clear;clc;
tic;
cd '/home/chris/caffe-master/chm_cross/chm12';
file =char('A1','A2','B1','B2','C1','C2','D1','D2','E1','E2','F1','F2','G1','G2','H1','H2','I1','I2','J1','J2','K1','K2','L1','L2');
cellsize=32;
hog_feature=[];
%取特徵

for f=1:24
    for fold=1:5
    list=dir(['cross/',num2str(file(f,:)),'/',num2str(fold),'/*.jpg']); %照片路徑(img資料夾)
    name=sort_nat({list.name});
    num = length(list);
    
         for img =1:num
                imm=imread(['cross/',num2str(file(f,:)),'/',num2str(fold),'/',cell2mat(name(img))]); 
                im = imresize(imm,[256 256]);
                [hog,visualization]=extractHOGFeatures(im,'Cellsize',[cellsize cellsize]);
                hog_size = numel(hog);
                hog_feature = [hog_feature;hog];  
                %{
        subplot(1,2,1);
        imshow(im);
        subplot(1,2,2);
        plot(visualization);
        %}
         end
        
    %save(['hog/',num2str(file(f,:)),'/hog_',num2str(cellsize),'_',num2str(fold),'.mat'],'hog_feature');
    end
    
end



 
v_1=[1,2,3,4,5];
v_2=[2,3,4,5,1];
v_n=char('v12','v23','v34','v45','v51');
 
 %生成train txt 做交差驗證會有5個txt
for v_go=1:5
    
fid=fopen(['hog/hog_',num2str(v_n(v_go,:)),'_train.txt'],'at');
for herb=1:24
    for c_fold=1:5
        if(c_fold == v_1(v_go)|| c_fold ==v_2(v_go))
             continue 
        else   
            load(['hog/',num2str(file(herb,:)),'/hog_',num2str(cellsize),'_',num2str(c_fold),'.mat'])
            [m,n] = size(hog_feature);   %m:照片個數 n:特徵維度
            %%%%%
            for i=1:m
                fprintf(fid,'%d ',herb-1);
                for j=1:n
                    fprintf(fid, '%d:%f ', j, hog_feature(i,j) ); 
                end
                fprintf(fid,'\n');
            end
            %%%%%
        end%if end
        
    end
    
end
fclose(fid);

%生成test txt
fid=fopen(['hog/hog_',num2str(v_n(v_go,:)),'_test.txt'],'at');
for herb=1:24
    for c_fold=1:5
        if(c_fold ~= v_1(v_go)&& c_fold ~=v_2(v_go))
             continue 
        else   
            load(['hog/',num2str(file(herb,:)),'/hog_',num2str(cellsize),'_',num2str(c_fold),'.mat'])
            [m,n] = size(hog_feature);   %m:照片個數 n:特徵維度
            %%%%%
            for i=1:m
                fprintf(fid,'%d ',herb-1);
                for j=1:n
                    fprintf(fid, '%d:%f ', j, hog_feature(i,j) ); 
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