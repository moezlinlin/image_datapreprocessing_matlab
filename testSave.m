function testSave

% transcriptionPath = 'D:\matlabworkspace\InformationExtraction_IAM\test_labels.txt';
% chars_map = get_chars_map(transcriptionPath);
% %save label.mat chars_map
% save Char chars_map
charss_map=containers.Map
load('Char.mat');
transcription = chars_map('a01-026x-08-02');
fprintf('识别结果： %s \n', transcription);

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
    y = regexp(line, '\t', 'split');
    fprintf('y{1}: = %s   y{2}： %s \n',y{1},y{2});
    temp = containers.Map(y{1},y{2});
    chars_map = [chars_map; temp];    
end
fclose(fin);
end