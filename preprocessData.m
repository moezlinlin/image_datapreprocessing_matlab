function preprocessData()
%MAIN Summary of this function goes here
%   Detailed explanation goes here
input_file_directory='D:\matlabworkspace\InformationExtraction\GW';
subdir  = dir(input_file_directory);  %trainData下面的文件列表，如idPage10354_Record1
fprintf('input_file_directory = %s \n',input_file_directory);
fprintf('length( subdir) = %d \n',length( subdir));
imageHeight = 100;
imageWidth = 200;
imageCount=0;
for i = 1 : length( subdir )
    if( isequal( subdir( i ).name, '.' )||...
        isequal( subdir( i ).name, '..')||...
        ~subdir( i ).isdir)               % 如果不是目录则跳过
        continue;
    end
    subdirpath = fullfile(input_file_directory, subdir( i ).name);
    fprintf('subdirpath = %s \n',subdirpath);   
    nextSubdir  = dir(subdirpath);  %获取idPage10354_Record1下面的文件列表
    fileName = strcat(subdir( i ).name,'.txt');
    fileText =fopen(fullfile('resultData4',fileName),'a+');
    for j = 1 : length( nextSubdir )
        if( isequal( nextSubdir( j ).name, 'words' ))  %若文件夹为words文件
            %transcriptionPath =  fullfile(subdirpath, nextSubdir( j ).name, strcat(subdir( i ).name, '_transcription.txt'));
             transcriptionPath = 'D:\matlabworkspace\InformationExtraction\GW\word_labels.txt';
%             fprintf('transcriptionPath = %s \n',transcriptionPath);
            chars_map = get_chars_map(transcriptionPath);
            imagePath = fullfile(input_file_directory,subdir( i ).name,nextSubdir( j ).name,'*.png');
          %   fprintf('imagePath = %s \n',imagePath);
            img_path_list = dir(imagePath);%获取该文件夹中所有png格式的图像
%             fprintf('所有png格式的图像: = %d \n',length( img_path_list));
            for k = 1 : length( img_path_list )
                imageName =  regexp(img_path_list( k ).name, '\.', 'split');
                transcription = chars_map(imageName{1});
%                 fprintf('图像名: = %s   识别结果： %s \n',imageName{1}, transcription);
                datpath = fullfile( input_file_directory, subdir( i ).name,nextSubdir( j ).name, img_path_list( k ).name);
                
                %%使用去除背景的方法
                %fprintf('图像名称: = %s \n',datpath);                
%                sourceImage=imread(datpath);
%                background=imopen(sourceImage,strel('ball',15,100));
%                imwrite(background,fullfile( input_file_directory, subdir( i ).name,'outputs', strcat('background_',img_path_list( k ).name)));
%                I2=imsubtract(sourceImage,background);
%                imwrite(I2,fullfile( input_file_directory, subdir( i ).name,'outputs', strcat('I2_',img_path_list( k ).name)));
%                I3=imadjust(I2,stretchlim(I2),[0 1]);  %调节图像的对比度
%                imwrite(I3,fullfile( input_file_directory, subdir( i ).name,'outputs', strcat('I3_',img_path_list( k ).name)));
%                thresh = graythresh(I3);     %自动确定二值化阈值
%                I4 = im2bw(I3,thresh);       %对图像二值化
%                imwrite(I4,fullfile( input_file_directory, subdir( i ).name,'outputs', strcat('I4_',img_path_list( k ).name)));
%                 % 中值滤波平滑
%                I5 = medfilt2(I4);
%                imwrite(I5,fullfile( input_file_directory, subdir( i ).name,'outputs', strcat('I5_',img_path_list( k ).name)));

                %%图像处理
                sourceImage=imread(datpath);
%                 I1=imadjust(sourceImage,[0 1],[1 0]);
               % thresh = graythresh(sourceImage);     %自动确定二值化阈值
               % I2 = im2bw(sourceImage,thresh);       %对图像二值化
%                 I3=bwareaopen(I2,9);
                se = strel('disk',1);        
                I3 = imerode(sourceImage,se);
                 % 中值滤波平滑
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
fprintf('全部处理完成! \n');
end

%%读取图片的识别结果，存储到映射表map中，key为图片名字，value为识别结果
function [chars_map] = get_chars_map(filename)
fin = fopen(filename, 'r');
chars_map = containers.Map;
while ~feof(fin)
    line = fgetl(fin);
    if isempty(strtrim(line))
        continue;
    end
    y = regexp(line, '\ ', 'split');
%     fprintf('y{1}: = %s   y{2}： %s \n',y{1},y{2});
    temp = containers.Map(y{1},y{2});
    chars_map = [chars_map; temp];    
end
fclose(fin);
end

