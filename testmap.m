%filename = 'D:\matlabworkspace\InformationExtraction_IAM\word_labels.txt';
filename='D:\matlabworkspace\InformationExtraction\GW\word_labels.txt';
fin = fopen(filename, 'r');
chars_map = containers.Map;
while ~feof(fin)
    line = fgetl(fin);
    if isempty(strtrim(line))
        continue;
    end
    y = regexp(line, '\t', 'split');
    temp = containers.Map(y{1},y{2});
    chars_map = [chars_map; temp];
        
end
fclose(fin);