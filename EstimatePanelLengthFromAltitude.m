function x_hat = EstimatePanelLengthFromAltitude(groudtruthexcel)
%groudtruthexcel = "./OriginalDataset/groundtruth.xlsx";
%% Set up the Import Options and import the data
opts = spreadsheetImportOptions("NumVariables", 18);

% Specify sheet and range
opts.Sheet = "Sheet1";
opts.DataRange = "A2:R1319";

% Specify column names and types
opts.VariableNames = ["frameNum", "CameraMotion", "IlluminationVariation", "ViewpointChange", "OutofView", "BackgroundClutter", "LowResolution", "centerX", "centerY", "majorAxisLength", "minorAxisLength", "area", "altitude", "scaleChange", "DistanceBetweenTwoPoints", "ratio", "VarName17", "actualBackgroundCluttering"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Import the data
groundtruth = readtable(groudtruthexcel, opts, "UseExcel", false);
groundtruth(any(ismissing(groundtruth),2), :) = [];
% groundtruth(any(groundtruth.CameraMotion,2), :) = [];
% groundtruth(any(groundtruth.IlluminationVariation,2), :) = [];
% groundtruth(any(groundtruth.ViewpointChange,2), :) = [];
% groundtruth(any(groundtruth.OutofView,2), :) = [];
% groundtruth(any(groundtruth.BackgroundClutter,2), :) = [];
% groundtruth(any(groundtruth.LowResolution,2), :) = [];
groundtruth(any(groundtruth.majorAxisLength==0 & groundtruth.altitude>0,2), :) = [];
% Clear temporary variables
clear opts

%% Find the length of the platform using the altitude of the drone (OLS)
x = groundtruth.altitude;
x2 = groundtruth.altitude.^2;
A = [x2 x ones(length(x),1)];
y = groundtruth.majorAxisLength;
x_hat = A\y;
y_est = A * x_hat;
scatter(x,y); 
hold on;
plot(x,y_est);
xlabel('Altitude');
ylabel('Landmark Length (pixels)');
Image = getframe(gcf);
imwrite(Image.cdata, 'alt2lengthmodel.jpg');
end