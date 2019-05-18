a
clear all;close all;clc;
SE1=[1 1 1 1 1 1 1 1 1];
SE2=[0 0 0 0 1 0 0 0 0;
    0 0 0 1 1 1 0 0 0;
    0 0 1 1 1 1 1 0 0;
    0 1 1 1 1 1 1 1 0;
    1 1 1 1 1 1 1 1 1;
    0 1 1 1 1 1 1 1 0;
    0 0 1 1 1 1 1 0 0;
    0 0 0 1 1 1 0 0 0;
    0 0 0 0 1 0 0 0 0];
yuzhi=40
I=imread('1.png');
w2=fspecial('average',[5 5]); %% 先定义一个滤波器
I=imfilter(I,w2,'replicate'); %%让图像通过滤波器
%         I=imadjust(I);
%         I=double(I);
[hight,width]=size(I);
A=zeros(hight,width);
high=zeros(hight,width);high_area1=zeros(hight,width);high_area2=zeros(hight,width);
I=imdilate(I,SE1);
I=imopen(I,SE2);
I=imdilate(I,SE1);
I=imopen(I,SE2);
I=imdilate(I,SE1);
I=imopen(I,SE2);
[m,n]=size(I);
%########################################################################%
%聚类
R=reshape(I,m*n,1);
R=double(R);
% [Idx,C]=kmeans(R,3);
%         [Idx,C]=kmeans(R,3,'dist','sqEuclidean','Start','uniform','Replicates',2);
a1=max(R);
aa1=0.5*a1;
aa2=0.75*a1;
aa=[0;aa1;aa2];
[Idx,C]=kmeans(R,3,'dist','sqEuclidean','Start',aa);

I_seg = reshape(C(Idx, :), m, n);

%########################################################################%
% imshow(I_seg)
%         cmap = colormap(jet(90));
%         rgb = ind2rgb(floor(I_seg),cmap);
% subplot(122),
%         imshow(rgb);
% I_seg= bwareaopen(I_seg,3000,8);
I_seg(find(I_seg<10))=0;
%         imshow(I_seg)
%         [L,num]=bwlabel(I_seg,4);%标记连通区域，计算面积，绘制矩形
%                 max_seg=max(max(I_seg));
%         A(find(I_seg==max_seg))=max_seg;
L=im2bw(I_seg);
%         L(find(L<1))==0;
imshow(L)
L= bwareaopen(L,8000,8);
%         S = regionprops(L, 'Area');
%         L=I_seg;
STATS = regionprops(L,'BoundingBox','Centroid');
%         centroid = regionprops(L,'Centroid');
%         imshow(A)
mean_valz=[];
for i=1:size(STATS,1)
                hold on
                rectangle('position', STATS(i).BoundingBox, 'EdgeColor', 'r');         %绘制矩形
    area_pixel=I( (STATS(i).BoundingBox(2)) : (STATS(i).BoundingBox(4)+STATS(i).BoundingBox(2)) , (STATS(i).BoundingBox(1)) : (STATS(i).BoundingBox(3)+STATS(i).BoundingBox(1)) );
    mean_val=mean(area_pixel(find(area_pixel~=0)));
    %             mean_valz=[mean_valz,mean_val];
    %             figure
    %             imshow(area_pixel)
    %             plot(STATS.Centroid(i).STATS.Centroid(1),STATS.Centroid(i).STATS.Centroid(2),'*');
    %             area_pixel_val=I_seg(ceil(STATS.centroid(i).Centroid(2)),ceil(STATS.centroid(i).Centroid(1)))
    if (STATS(i).Centroid(2)-yuzhi)>0&(STATS(i).Centroid(1)-yuzhi)>0
        high_area1(ceil(STATS(i).Centroid(2)-yuzhi):(STATS(i).Centroid(2)+yuzhi),ceil(STATS(i).Centroid(1)-yuzhi):(STATS(i).Centroid(1)+yuzhi))=mean_val;
        % high_area1(ceil(STATS(i).Centroid(2)-yuzhi):(STATS(i).Centroid(2)+yuzhi),ceil(STATS(i).Centroid(1)-yuzhi):(STATS(i).Centroid(1)+yuzhi))=1;
        %             else
        %             high_area1((centroid(i).Centroid(2)):(centroid(i).Centroid(2)+50),(centroid(i).Centroid(1)):(centroid(i).Centroid(1)+50))=1;
    end
end
% name=cell2mat(regexp(file_path,'\d', 'match'));
% %             labeli=name(2:6);
% dirname=strcat(out_path,name(1:6),'\');
% a=['mkdir ' dirname];%创建命令
% system(a) %创建文件夹
% imwrite(uint8(high_area1),strcat(out_path,name(1:6),'\',image_name));



