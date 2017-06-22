function preprocessData()
%MAIN Summary of this function goes here
%   Detailed explanation goes here
input_file_directory='D:\matlabworkspace\InformationExtraction\GW';
subdir  = dir(input_file_directory);  %trainData������ļ��б���idPage10354_Record1
fprintf('input_file_directory = %s \n',input_file_directory);
fprintf('length( subdir) = %d \n',length( subdir));
imageHeight = 100;
imageWidth = 200;
imageCount=0;
for i = 1 : length( subdir )
    if( isequal( subdir( i ).name, '.' )||...
        isequal( subdir( i ).name, '..')||...
        ~subdir( i ).isdir)               % �������Ŀ¼������
        continue;
    end
    subdirpath = fullfile(input_file_directory, subdir( i ).name);
    fprintf('subdirpath = %s \n',subdirpath);   
    nextSubdir  = dir(subdirpath);  %��ȡidPage10354_Record1������ļ��б�
    fileName = strcat(subdir( i ).name,'.txt');
    fileText =fopen(fullfile('resultData4',fileName),'a+');
    for j = 1 : length( nextSubdir )
        if( isequal( nextSubdir( j ).name, 'words' ))  %���ļ���Ϊwords�ļ�
            %transcriptionPath =  fullfile(subdirpath, nextSubdir( j ).name, strcat(subdir( i ).name, '_transcription.txt'));
             transcriptionPath = 'D:\matlabworkspace\InformationExtraction\GW\word_labels.txt';
%             fprintf('transcriptionPath = %s \n',transcriptionPath);
            chars_map = get_chars_map(transcriptionPath);
            imagePath = fullfile(input_file_directory,subdir( i ).name,nextSubdir( j ).name,'*.png');
          %   fprintf('imagePath = %s \n',imagePath);
            img_path_list = dir(imagePath);%��ȡ���ļ���������png��ʽ��ͼ��
%             fprintf('����png��ʽ��ͼ��: = %d \n',length( img_path_list));
            for k = 1 : length( img_path_list )
                imageName =  regexp(img_path_list( k ).name, '\.', 'split');
                transcription = chars_map(imageName{1});
%                 fprintf('ͼ����: = %s   ʶ������ %s \n',imageName{1}, transcription);
                datpath = fullfile( input_file_directory, subdir( i ).name,nextSubdir( j ).name, img_path_list( k ).name);
                
                %%ʹ��ȥ�������ķ���
                %fprintf('ͼ������: = %s \n',datpath);                
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
%                 % ��ֵ�˲�ƽ��
%                I5 = medfilt2(I4);
%                imwrite(I5,fullfile( input_file_directory, subdir( i ).name,'outputs', strcat('I5_',img_path_list( k ).name)));

                %%ͼ����
                sourceImage=imread(datpath);
%                 I1=imadjust(sourceImage,[0 1],[1 0]);
               % thresh = graythresh(sourceImage);     %�Զ�ȷ����ֵ����ֵ
               % I2 = im2bw(sourceImage,thresh);       %��ͼ���ֵ��
%                 I3=bwareaopen(I2,9);
                se = strel('disk',1);        
                I3 = imerode(sourceImage,se);
                 % ��ֵ�˲�ƽ��
                image = medfilt2(~I3);
%                 imwrite(I2,fullfile( input_file_directory, subdir( i ).name,'outputs', strcat('I2_',img_path_list( k ).name)));
%                 imwrite(I4,fullfile( input_file_directory, subdir( i ).name,'outputs', strcat('I4_',img_path_list( k ).name)));
%                 imwrite(I3,fullfile( input_file_directory, subdir( i ).name,'outputs', strcat('I3_',img_path_list( k ).name)));
         %       imwrite(image,fullfile( input_file_directory, subdir( i ).name,'outputs', strcat('I3_',img_path_list( k ).name)));
                [m n]=size(image); 
                resultImage = zeros(imageHeight,imageWidth);
                if m>imageHeight || n>imageWidth
                    widthScale = imageWidth/n;
                    heightScale = imageHeight/m;
                    if widthScale>heightScale
                        scaleImage =imresize(image,[imageHeight NaN]);
                        [s1 s2] = size(scaleImage);
                        offset = round((imageWidth - s2)/2);
                        for col = 1:s2
                            resultImage(:,col+offset) = scaleImage(:,col);
                        end
                    else
                        scaleImage =imresize(image,[NaN imageWidth]);
                        [s1 s2] = size(scaleImage);
                        offset = round((imageHeight - s1)/2);
                        for row = 1:s1
                            resultImage(row+offset,:) = scaleImage(row,:);
                        end
                    end
                else
                    rowOffset = round((imageHeight - m)/2);
                    colOffset = round((imageWidth - n)/2);
                    for row = 1:m
                        for col = 1:n
                           resultImage(row+rowOffset,col+colOffset)  = image(row,col);
                        end
                    end
                end
                imwrite(resultImage,fullfile('resultImage4',img_path_list( k ).name));
                fprintf(fileText,'%s',imageName{1});
                fprintf(fileText,'|');
                fprintf(fileText,'%s',transcription);
                fprintf(fileText,'|');
                [row col] = find(resultImage);
                for r = 1:length(row)-1
                    fprintf(fileText, '%s,', num2str((row(r)-1)*imageWidth+(col(r)-1)));
                end
                fprintf(fileText, '%s', num2str((row(length(row))-1)*imageWidth+(col(length(row))-1)));
                imageCount = imageCount+1;
                fprintf(fileText,'\n');
            end
            fclose(fileText);
        end
    end
end
fprintf('imageCount =  %d \n',imageCount);
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
%     fprintf('y{1}: = %s   y{2}�� %s \n',y{1},y{2});
    temp = containers.Map(y{1},y{2});
    chars_map = [chars_map; temp];    
end
fclose(fin);
end

