function testSave

% transcriptionPath = 'D:\matlabworkspace\InformationExtraction_IAM\test_labels.txt';
% chars_map = get_chars_map(transcriptionPath);
% %save label.mat chars_map
% save Char chars_map
charss_map=containers.Map
load('Char.mat');
transcription = chars_map('a01-026x-08-02');
fprintf('ʶ������ %s \n', transcription);

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
    y = regexp(line, '\t', 'split');
    fprintf('y{1}: = %s   y{2}�� %s \n',y{1},y{2});
    temp = containers.Map(y{1},y{2});
    chars_map = [chars_map; temp];    
end
fclose(fin);
end