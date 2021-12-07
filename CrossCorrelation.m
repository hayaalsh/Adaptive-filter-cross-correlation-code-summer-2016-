close all; clear all; clc;
set(0, 'DefaultFigureVisible', 'on');

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 20);

% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Var1", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Altitude", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var20"];
opts.SelectedVariableNames = "Altitude";
opts.VariableTypes = ["string", "string", "string", "string", "string", "string", "string", "string", "string", "double", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var20"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var20"], "EmptyFieldRule", "auto");

% Import the data
dronedata = readtable("./OriginalDataset/logfile.txt", opts);
clear opts

%% Use Cross-Correlation to Find Template in Image 
% insert your image frames size
framesize = [720, 1280];
scaledownby = 3;
newframesize = framesize/scaledownby;

betasaltitude = EstimatePanelLengthFromAltitude("./SampleDataset/groundtruth.xlsx");
betasaltitude_scaled = betasaltitude/scaledownby;

% get drone intial altitude
altitude = dronedata.Altitude(2);
mylength2 = [altitude^2 altitude 1]*betasaltitude_scaled;
if mylength2 > min(newframesize)
    mylength2 = min(newframesize);
end

% Read images into the workspace and display them side-by-side.
filter1 = rgb2gray(imread('filter1.png'));
filter2 = rgb2gray(imread('filter2.png'));
%filter2 = imcrop(imrotate(filter1,45,'bilinear','crop'),[250 250 850 850]);

% imagefiles = dir('AnnotatedSet1/*.jpg');     
imagefiles = dir('./OriginalDataset/*.jpg');  
nfiles = length(imagefiles);    % Number of files found

vid = VideoWriter('result2','MPEG-4');
vid.FrameRate = 30;
open(vid);
f2 = figure(2);

for i = 1:nfiles
    currentfilename = [imagefiles(i).folder '/' imagefiles(i).name];
    sceneImage = imread(currentfilename);
    if size(sceneImage,1:2) ~= newframesize
        sceneImage = imresize(sceneImage,newframesize);
    end
    sceneImageBW = rgb2gray(sceneImage);
    sceneImageBW = sceneImageBW > 200;

    altitude = dronedata.Altitude(i+1);
    mylength = [altitude^2 altitude 1]*betasaltitude_scaled;
    if mylength > min(newframesize)
        mylength = min(newframesize);
    end
    
    filter1_sized = imresize(filter1,[mylength mylength]) > 200;
    filter2_sized = imresize(filter2,[mylength mylength]) > 200;
   
    % Perform cross-correlation and display result as surface.
    c1 = normxcorr2(filter1_sized,sceneImageBW);
    c2 = normxcorr2(filter2_sized,sceneImageBW);

    cval1 = max(c1(:));
    cval2 = max(c2(:));

    if cval1(1)>cval2(1) && cval1(1)>0.1
        cbest = c1;
        bestlength = mylength;
    elseif cval2(1)>cval1(1) && cval2(1)>0.1
        cbest = c2;
        bestlength = mylength;
    else
        cbest = zeros(size(c1));
        bestlength = 0;
    end
    
    % Find peak in cross-correlation. 
    [ypeak, xpeak] = find(cbest>0.1);%find(cbest==cvalbest); % find(cbest>0.4);

    set(0, 'currentfigure', f2);
    subplot(1,2,1);
    surf(cbest), shading flat
    zlim([-1 1]);

    if length(xpeak>0)
        yoffSet = median(ypeak)-bestlength;
        xoffSet = median(xpeak)-bestlength;
        sceneImage = insertShape(sceneImage, 'Rectangle', [xoffSet, yoffSet, bestlength, bestlength],'Color','r','LineWidth',4);
    end
    
    set(0, 'currentfigure', f2);
    subplot(1,2,2);
    imshow(sceneImage);
    set(f2,'Position',[0 0 900 300]);
    frame = getframe(f2);
    writeVideo(vid, frame);
end
close(vid);