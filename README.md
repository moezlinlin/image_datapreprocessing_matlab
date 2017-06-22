# image_datapreprocessing_matlab
statisticsData.m：是用于统计图片信息，比如宽高，类标等

preprocessData.m：是用于进行数据处理，读取数据图片，对图片进行去除背景、二值化、平滑等处理，将图片进行归一化，然后将处理完后的图片存入“resultImage”中，并且将图片信息转换为坐标，存入“resultData”，里面每个record存为一个txt文件

readData.m：为了确保将处理完的图片转换为坐标不出错，使用readData重新读取“resultData”中的一个record，将图片画出来，看看坐标是否正确

命令：preprocessData('E:/Matlab_workspace/InformationExtraction/trainData');
statisticsData('E:/Matlab_workspace/InformationExtraction/trainData');
readData('E:/Matlab_workspace/InformationExtraction/resultData/idPage10354_Record3.txt');
