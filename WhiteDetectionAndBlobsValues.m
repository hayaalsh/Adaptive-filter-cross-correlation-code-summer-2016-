%% WhiteDetectionAndBlobsValues
% A function to detect white objects only and report there blobs values 
% including area, min and max length, and centroid.
% if multiple objects are detected, make user select one.

% Aspect Ratio Change: the fraction of ground truth aspect ratio in the first frame and at least one subsequent frame is outside the range [0.5, 2] (cal).
% Fast Motion: motion of the ground truth bounding box is larger than 20 pixels between two consecutive frames. (cal)
% Scale Variation: the ratio of initial and at least one subsequent bounding box is outside the range [0.5, 2] (cal).

% Background Clutter: the background near the target has similar appearance as the target. (cal)
% Camera Motion: abrupt motion of the camera (measure). 
% Illumination Variation: the illumination of the target changes significantly (measure).
% Low Resolution: at least one ground truth bounding box has less than 400 pixels. (cal)
% Viewpoint Change: viewpoint affects target appearance significantly (measure).
% Out-of-View: some portion of the target leaves the view.  (cal)

% Partial Occlusion: the target is partially occluded. = 0
% Full Occlusion: the target is fully occluded. = 0
% Similar Object: there are objects of similar shape or same type near the target. = 0

function [CameraMotion, IlluminationVariation, ViewpointChange, OutofView, BackgroundClutter, LowResolution, centerX,centerY,majorAxisLength,minorAxisLength,area] = WhiteDetectionAndBlobsValues(frame,frameNum)
%% Color thresholding
frameGrayscale = rgb2gray(frame);   % Convert frame to grayscale
thresh = 0.75; % Threshold for white detection
frameRedChannel = im2bw(frame(:,:,1), thresh); % obtain the white component from red layer
frameGreenChannel = im2bw(frame(:,:,2), thresh); % obtain the white component from green layer
frameBlueChannel = im2bw(frame(:,:,3), thresh); % obtain the white component from blue layer
framebw = frameRedChannel & frameGreenChannel & frameBlueChannel; % get the common region
frameFiltered = medfilt2(framebw,[3,3]);% Filter out the noise by using median filter
frameFiltered = bwareaopen(frameFiltered,100);

% fill holes
frameFiltered = imfill(frameFiltered, 'holes');

[labeledImage,numberOfLabels] = bwlabel(frameFiltered, 8);

%% Blobs parameters
blobMeasurements = regionprops(labeledImage, frameGrayscale, 'MajorAxisLength', ...
    'MinorAxisLength','Centroid','Area');
allBlobCentroids = [blobMeasurements.Centroid];
centroidsX = allBlobCentroids(1:2:end-1);
centroidsY = allBlobCentroids(2:2:end);

allBlobMajorAxisLength = [blobMeasurements.MajorAxisLength];
allBlobMinorAxisLength = [blobMeasurements.MinorAxisLength];
allBlobArea = [blobMeasurements.Area];

%% Set defualt values
centerX = -1;
centerY = -1;
majorAxisLength = 0;
minorAxisLength = 0;
area = 0;
BackgroundClutter = 0;
LowResolution = 0;

%% Select from multiple blobs
figure(1); imshow(labeledImage);
text(0, 0, num2str(frameNum), 'FontSize', 14, 'FontWeight', 'Bold', 'Color', 'r');

prompt = {'Camera Motion:','Illumination Variation:',' Viewpoint Change','OutofView'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'0','0','0','0'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
CameraMotion = str2num(answer{1});
IlluminationVariation = str2num(answer{2});
ViewpointChange = str2num(answer{3});
OutofView = str2num(answer{4});

if (numberOfLabels > 0)
    BackgroundClutter = 1;
    for k = 1 : numberOfLabels           % Loop through all blobs.
        text(centroidsX(k), centroidsY(k), num2str(k), 'FontSize', 14, 'FontWeight', 'Bold', 'Color', 'r');
    end

    prompt = {'There are more than 1 detected objects. Please enter the number of the object to be detected.'};
    dlg_title = 'Object number';
    num_lines = 1;
    default = {'0'};
    answer = inputdlg(prompt,dlg_title,num_lines,default);
    k = str2num(answer{1});  
    if (k > 0)
        centerX = centroidsX(k);
        centerY = centroidsY(k);
        majorAxisLength = allBlobMajorAxisLength(k);
        minorAxisLength = allBlobMinorAxisLength(k);
        area = allBlobArea(k);
    end
    
    if (area < 400)
        LowResolution = 1;
    end
end

end

