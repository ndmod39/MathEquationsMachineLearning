clear all
close all
clc

srcPath = "C:\Users\hp\OneDrive\Desktop\1UNII\CAI Training Program\scans jpeg\page 1";
saPath = "C:\Users\hp\OneDrive\Desktop\1UNII\CAI Training Program\cropped images"; % Path to save cropped images

img_path = "C:\Users\hp\OneDrive\Desktop\1UNII\CAI Training Program\scans jpeg\page 1\Math_Symbols_Form 1.jpg";

img = imread(img_path);
% Convert image to grayscale and then to binary
grayImg = rgb2gray(img);
binImg = imbinarize(grayImg);
% Resize binary image to [1448 x 1024] pixels
imgF = imresize(binImg, [1448, 1024]);
% Get image size
[xi, yi] = size(imgF);
% Sum of zeros across columns and rows for segmentation
total0s = sum(~imgF, 1); % Sum of zeros in each column
total0sTra = sum(~imgF, 2); % Sum of zeros in each row
% Find starting points along x and y axes
jmi = find(total0s > 60, 1, 'first'); % First column with content
imi = find(total0sTra > 60, 1, 'last'); % Last row with content
% Crop imgF to remove unnecessary whitespace
imgFNew = imgF(1:imi, jmi:yi);
figure, imshow(imgFNew);
se = strel('line',9,9);
imgFNew = imerode(imgFNew,se);
imshow(imgFNew), title('Original')
figure, imshow(imgFNew);

[xi, yi] = size(imgFNew);

% Number of columns to process (this can be adjusted based on layout)
numCols = 6;
numRows = 10;
colWidth = yi / numCols; % Approximate width of each column
rowWidth = xi / numRows; 
% Loop through each column
for col = 1:numCols
    colStart = round((col - 1) * colWidth) + 0.5;
    colEnd = round(col * colWidth);
    
    for Row = 1:numRows
        % Loop over the bounding box of the column to locate each word
        rowStart = round((Row - 1) * rowWidth) + 0.5;
        rowEnd = round(Row * rowWidth);

        wordRegion = imgFNew(rowStart+15:rowEnd-5, colStart+10:colEnd-20);
        figure, imshow(wordRegion);

        % Save each word as a separate image
        newImg = wordRegion;
        saveFolder = fullfile(saPath, num2str(col - 1));
        if ~exist(saveFolder, 'dir')
            mkdir(saveFolder); % Create column folder if it doesn't exist
        end
        % Defining save path for new image
        newImgPath = fullfile(saveFolder, sprintf('word_%d_%d.jpg', Row, col));
        imwrite(newImg, newImgPath);
    end
end