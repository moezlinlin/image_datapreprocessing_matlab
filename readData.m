function readData( input_file_directory)
%%°´ÁĞÉ¨Ãè»Ö¸´Í¼Ïñ²¢ÏÔÊ¾
fid =fopen(input_file_directory,'r');
imageHeight = 120;
imageWidth = 250;
imageCount = 1;
count =1;
figureCount =1;
figure(figureCount);
while ~feof(fid)
    line = fgetl(fid);
    if isempty(strtrim(line))
        continue;
    end
    lineArray = regexp(line, '\|', 'split');
%     fprintf('y{1}: = %s   y{2}£º %s \n',y{1},y{2});
    coordinateArray = regexp(lineArray{3}, '\,', 'split'); 
    resultImage = zeros(imageHeight,imageWidth);
    for i = 2:length(coordinateArray)
        x = fix(str2num(coordinateArray{i})/imageWidth)+1;
        y = mod(str2num(coordinateArray{i}),imageWidth)+1;
        resultImage(x,y)  =  1;
    end
    subplot(2,2,count);
    imshow(resultImage);
    if count > 3
        figureCount = figureCount+1;
        figure(figureCount);
        count = 1;
    else
        count = count + 1;
    end
end
fclose(fid);
fprintf('Í¼Ïñ¶ÁÈ¡½áÊø\n');
end
