%% Create Ground Truth
% this code uses the whiteDetectionAndBlobsValues function to create a
% ground truth of the moving platform and store that in an excel sheet.
close all; clear all; clc;
set(0, 'DefaultFigureVisible', 'on');
%% Create Table
T = table;

%% Read images
% Reads video form file and set up video player for displaying frames
imagefiles = dir('./SampleDataset/*.jpg');  
nfiles = length(imagefiles);    % Number of files found

%% Read Logfile for Altitude
logfile = readtable('./SampleDataset/logfile.txt','Delimiter',',');
altitude = logfile.Altitude;

%%
for i = 1:nfiles
    currentfilename = [imagefiles(i).folder '/' imagefiles(i).name];
    frame = imread(currentfilename);
    figure(2); imshow(frame);
    frameNum = str2num(imagefiles(i).name(1:end-3));
    
    % Locate center manually
    % imshow(frame);    
    % h = impoly;
    % centerPixel = getPosition(h);
    
    % Color Detection
    [CameraMotion, IlluminationVariation, ViewpointChange, OutofView, BackgroundClutter, LowResolution,centerX,centerY,majorAxisLength,minorAxisLength,area] = WhiteDetectionAndBlobsValues(frame,frameNum);

    % Add to table
    groundTruth(1,1).frameNum = frameNum;
    groundTruth(1,1).CameraMotion = CameraMotion;
    groundTruth(1,1).IlluminationVariation = IlluminationVariation;
    groundTruth(1,1).ViewpointChange = ViewpointChange;
    groundTruth(1,1).OutofView = OutofView;
    groundTruth(1,1).BackgroundClutter = BackgroundClutter;
    groundTruth(1,1).LowResolution = LowResolution;
    groundTruth(1,1).centerX = centerX;
    groundTruth(1,1).centerY = centerY;
    groundTruth(1,1).majorAxisLength = majorAxisLength;
    groundTruth(1,1).minorAxisLength = minorAxisLength;
    groundTruth(1,1).area = area;
    groundTruth(1,1).altitude = altitude(i);
    T = [T;struct2table(groundTruth)];
end

%% Write data to excel file
filename = './SampleDataset/groundtruth.xlsx';
writetable(T,filename,'Sheet',1);
release(videoPlayer); % close the player
