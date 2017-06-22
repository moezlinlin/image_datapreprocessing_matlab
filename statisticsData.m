function statisticsData( input_file_directory)
%MAIN Summary of this function goes here
%   Detailed explanation goes here
subdir  = dir(input_file_directory);  %trainData������ļ��б���idPage10354_Record1
fprintf('input_file_directory = %s \n',input_file_directory);
fprintf('length( subdir) = %d \n',length(subdir));
widthArray = zeros(7,1);
HeightArray = zeros(7,1);
imageHight = 0;
imageWidth = 0;
imageCount = 0;
minWidth = inf;
maxWidth = 0;
minHeight = inf;
maxHeight = 0;
labelCount_map = containers.Map;  %����ÿ������ж��ٸ�����
label_map = containers.Map;  %��ÿ�����ӳ��Ϊ����
labelNum = 0;
for i = 1 : length( subdir )
    if( isequal( subdir( i ).name, '.' )||...
        isequal( subdir( i ).name, '..')||...
        ~subdir( i ).isdir)               % �������Ŀ¼������
        continue;
    end
    subdirpath = fullfile(input_file_directory, subdir( i ).name);
    fprintf('subdirpath = %s \n',subdirpath);   
    nextSubdir  = dir(subdirpath);  %��ȡidPage10354_Record1������ļ��б�
    for j = 1 : length( nextSubdir )
        if( isequal( nextSubdir( j ).name, 'words' ))  %���ļ���Ϊwords�ļ�
            
            %%ͳ�����
         %   transcriptionPath =  fullfile(subdirpath, nextSubdir( j ).name, strcat(subdir( i ).name, '_transcription.txt'));
         transcriptionPath = 'D:\matlabworkspace\InformationExtraction\GW\word_labels.txt';
%             fprintf('transcriptionPath = %s \n',transcriptionPath);
            chars_map = get_chars_map(transcriptionPath);
            labelArray = values(chars_map);
            for l = 1:length(labelArray)
                if isKey(labelCount_map,labelArray{l})
                    labelCount = labelCount_map(labelArray{l});
                    labelCount_map(labelArray{l}) =  labelCount +1;
                else
%                     fprintf('labelArray(l) = %s \n',labelArray{l});
                    labelCount_map(labelArray{l}) = 1;
%                     temp = containers.Map({labelArray(l)},{1});
%                     label_map = [label_map; temp];
                end
                if isKey(label_map,labelArray{l})
                    continue;
                else
%                     fprintf('labelArray(l) = %s \n',labelArray{l});
                    label_map(labelArray{l}) = labelNum;
                    labelNum = labelNum+1;
%                     temp = containers.Map({labelArray(l)},{1});
%                     label_map = [label_map; temp];
                end
            end
            
            imagePath = fullfile(input_file_directory,subdir( i ).name,nextSubdir( j ).name,'*.png');
            
%             fprintf('imagePath = %s \n',imagePath);
            img_path_list = dir(imagePath);%��ȡ���ļ���������png��ʽ��ͼ��
%             fprintf('����png��ʽ��ͼ��: = %d \n',length( img_path_list));
            imageCount = imageCount + length( img_path_list );
            for k = 1 : length( img_path_list )
                 imageName =  regexp(img_path_list( k ).name, '\.', 'split');
                 transcription = chars_map(imageName{1});
%                 fprintf('ͼ����: = %s   ʶ������ %s \n',imageName{1}, transcription);
                 datpath = fullfile( input_file_directory, subdir( i ).name,nextSubdir( j ).name, img_path_list( k ).name);
%                 
%                 ʹ��ȥ�������ķ���
%                 fprintf('ͼ������: = %s \n',datpath);                
%                sourceImage=imread(datpath);
%                background=imopen(sourceImage,strel('ball',15,100));
%                imwrite(background,fullfile( input_file_directory, subdir( i ).name,'outputs', strcat('background_',img_path_list( k ).name)));
%                I2=imsubtract(sourceImage,background);
%                imwrite(I2,fullfile( input_file_directory, subdir( i ).name,'outputs', strcat('I2_',img_path_list( k ).name)));
%                I3=imadjust(I2,stretchlim(I2),[0 1]);  %����ͼ��ĶԱȶ�
%                imwrite(I3,fullfile( input_file_directory, subdir( i ).name,'outputs', strcat('I3_',img_path_list( k ).name)));
%                thresh = graythresh(I3);     %�Զ�ȷ����ֵ����ֵ
%                I4 = im2bw(I3,thresh);       %��ͼ���ֵ��
%                imwrite(I4,fullfile( input_file_directory, subdir( i ).name,'outputs', strcat('I4_',img_path_list( k ).name)));
%                 ��ֵ�˲�ƽ��
%                I5 = medfilt2(I4);
%                imwrite(I5,fullfile( input_file_directory, subdir( i ).name,'outputs', strcat('I5_',img_path_list( k ).name)));
% 
%                 ͼ����
                 sourceImage=imread(datpath);
%                 thresh = graythresh(sourceImage);     %�Զ�ȷ����ֵ����ֵ
%                 I2 = im2bw(sourceImage,thresh);       %��ͼ���ֵ��
%                 se = strel('disk',1);        
%                 I3 = imerode(I2,se);
%                  ��ֵ�˲�ƽ��
%                 I4 = medfilt2(~I3);
%                 imwrite(I2,fullfile( input_file_directory, subdir( i ).name,'outputs', strcat('I2_',img_path_list( k ).name)));
%                 imwrite(I4,fullfile( input_file_directory, subdir( i ).name,'outputs', strcat('I4_',img_path_list( k ).name)));
%                 imwrite(I3,fullfile( input_file_directory, subdir( i ).name,'outputs', strcat('I3_',img_path_list( k ).name)));
                 [m,n]=size(sourceImage);
                 imageHight =  imageHight + m;
                 imageWidth = imageWidth + n;
                 imageCount = imageCount+1;
                 if m<minHeight
                     minHeight = m;
                 end
                 if m>maxHeight
                     maxHeight = m;
                 end
                 if n<minWidth
                     minWidth = n;
                 end
                 if n>maxWidth
                     maxWidth = n;
                 end
%                 ͳ��ͼ���С
                 if n>0 && n<=50
                     widthArray(1) = widthArray(1)+1;
                 elseif n>50 && n<=100
                     widthArray(2) = widthArray(2)+1;
                 elseif n>100 && n<=150
                     widthArray(3) = widthArray(3)+1;
                 elseif n>150 && n<=200
                     widthArray(4) = widthArray(4)+1;
                elseif n>200 && n<=250
                    widthArray(5) = widthArray(5)+1;
                elseif n>250 && n<=300
                    widthArray(6) = widthArray(6)+1;
                elseif n>300
                    widthArray(7) = widthArray(7)+1;
                end
                
                if m>0 && m<=50
                    HeightArray(1) = HeightArray(1)+1;
                elseif m>50 && m<=100
                    HeightArray(2) = HeightArray(2)+1;
                elseif m>100 && m<=150
                    HeightArray(3) = HeightArray(3)+1;
                elseif m>150 && m<=200
                    HeightArray(4) = HeightArray(4)+1;
                elseif m>200 && m<=250
                    HeightArray(5) = HeightArray(5)+1;
                elseif m>250 && m<=300
                    HeightArray(6) = HeightArray(6)+1;
                elseif m>300
                    HeightArray(7) = HeightArray(7)+1;
                end
%                 BW1=bwmorph(I3,'thin');
%                 BW1 = bwmorph(I3,'open');
%                 imwrite(BW1,fullfile( input_file_directory, subdir( i ).name,'outputs', strcat('BW1_',img_path_list( k ).name)));
%                 BW2 = bwmorph(BW1,'close');
%                 imwrite(BW2,fullfile( input_file_directory, subdir( i ).name,'outputs', strcat('BW2_',img_path_list( k ).name)));
%                 BW3 = bwmorph(BW2,'clean',3);
%                 imwrite(BW3,fullfile( input_file_directory, subdir( i ).name,'outputs', strcat('BW3_',img_path_list( k ).name)));
             end
        end
    end
end

fid1=fopen('statistics_data.txt','w+');
fprintf(fid1, 'width 0~50 : %d \n', widthArray(1));
fprintf(fid1, 'width 50~100 : %d \n', widthArray(2));
fprintf(fid1, 'width 100~150 : %d \n', widthArray(3));
fprintf(fid1, 'width 150~200 : %d \n', widthArray(4));
fprintf(fid1, 'width 200~250 : %d \n', widthArray(5));
fprintf(fid1, 'width 250~300 : %d \n', widthArray(6));
fprintf(fid1, 'width 300~ : %d \n', widthArray(7));

fprintf(fid1,'\n');
fprintf(fid1, 'height 0~50 : %d \n', HeightArray(1));
fprintf(fid1, 'height 50~100 : %d \n', HeightArray(2));
fprintf(fid1, 'height 100~150 : %d \n', HeightArray(3));
fprintf(fid1, 'height 150~200 : %d \n', HeightArray(4));
fprintf(fid1, 'height 200~250 : %d \n', HeightArray(5));
fprintf(fid1, 'height 250~300 : %d \n', HeightArray(6));
fprintf(fid1, 'height 300~ : %d \n', HeightArray(7));
fprintf(fid1,'\n');
fprintf(fid1, 'imageCount : %d \n', imageCount);
fprintf(fid1, 'averImageHeight : %f \n', imageHight/imageCount);
fprintf(fid1, 'averImageWidth : %f \n', imageWidth/imageCount);
fprintf(fid1, 'minWidth : %d  , maxWidth : %d  \n', minWidth, maxWidth);
fprintf(fid1,  'minHeight : %d  , maxHeight : %d  \n', minHeight, maxHeight);
fclose(fid1);
fprintf('0~50 : %d , 50~100 : %d , 100~150 : %d , 150~200 : %d , 200~250 : %d ,250~300 : %d , 300 : %d \n',widthArray(1),widthArray(2),widthArray(3),widthArray(4),widthArray(5),widthArray(6),widthArray(7));
fprintf('0~50 : %d , 50~100 : %d , 100~150 : %d , 150~200 : %d , 200~250 : %d ,250~300 : %d , 300 : %d \n',HeightArray(1),HeightArray(2),HeightArray(3),HeightArray(4),HeightArray(5),HeightArray(6),HeightArray(7));
fprintf('allImageHight = %ld  imageCount = %ld    averImageHeight = %f \n',imageHight,imageCount,imageHight/imageCount);
fprintf('allImageWidth = %ld  imageCount = %ld    averImageWidth = %f \n',imageWidth,imageCount,imageWidth/imageCount);
fprintf('minWidth = %ld  maxWidth = %ld    minHeight = %d  maxHeight = %d \n',minWidth,maxWidth,minHeight,maxHeight);

labelKeys =  keys(labelCount_map);
fprintf('labelCount = %ld \n',length(labelKeys));
fid2=fopen('statistics_label.txt','w+');
fprintf(fid2,'labelCount = %ld \n',length(labelKeys));
maxlabelLength=0;
for p = 1:length(labelKeys)
    fprintf(fid2,'%s : %d \n',labelKeys{p},labelCount_map(labelKeys{p}));
    fprintf('length(labelKeys) = %d \n',length(labelKeys{p}));
    if maxlabelLength<length(labelKeys{p})
        maxlabelLength = length(labelKeys{p});
    end
end
fprintf('maxlabelLength = %d \n',maxlabelLength);
fprintf(fid2,'maxlabelLength = %ld\n',maxlabelLength);
fclose(fid2);

allLabelKeys =  keys(label_map);
fprintf('label_map labelCount = %ld \n',length(allLabelKeys));
fid3=fopen('label.txt','w+');
fprintf(fid3,'%ld\n',length(label_map));
count =0;

for p = 1:length(label_map)
    fprintf(fid3,'%s\t%d\n',allLabelKeys{p},count);
    count = count +1;
end


fclose(fid3);


fid4=fopen('labelchar.txt','w+');
for p = 1:length(label_map)
    fprintf(fid4,'%s\n',allLabelKeys{p});
end
fclose(fid4);

fprintf('imageCount = %d! \n',imageCount);
fprintf('ȫ���������! \n');
end


%%��ȡͼƬ��ʶ�������洢��ӳ���map�У�keyΪͼƬ���֣�valueΪʶ����
function [chars_map] = get_chars_map(filename)
fin = fopen(filename, 'r');
chars_map = containers.Map;
while ~feof(fin)
    line = fgetl(fin);
    if isempty(strtrim(line))
        continue;
    end
    y = regexp(line, '\ ', 'split');
    temp = containers.Map(y{1},y{2});
    chars_map = [chars_map; temp];
        
end
fclose(fin);
end

