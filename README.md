# Adaptive Cross Correlation Filter (Summer 2016)

1. The `GroundTruthBuilder.m` reads images and UAV logs (mainly look at altitude), and enable the user to annotate their dataset. To speedup the process, I used a `WhiteDetectionAndBlobsValues.m` function that detects initial objects of intrest. After annotating the entire dataset, the script generates the `groundtruth.xlsx`.
2. Using a subset of `groundtruth.xlsx` data, we esimate a quadratic OLS model to determine the size of landmark from current altitude.
<img src="https://github.com/hayaalsh/AdaptiveCrossCorrelationFilterSummer2016/blob/main/alt2lengthmodel.jpg" width="500">

3. We then genereate 2 mannually-designed filters at the estimated dimintions, and apply normalized cross-correlation between the 2 filters. 
<img src=https://github.com/hayaalsh/AdaptiveCrossCorrelationFilterSummer2016/blob/main/filter1.png width="400"> <img src=https://github.com/hayaalsh/AdaptiveCrossCorrelationFilterSummer2016/blob/main/filter2.png width="400">


5. Once a match is found, we plot a bounding box around the deteceted landmark [Video]
