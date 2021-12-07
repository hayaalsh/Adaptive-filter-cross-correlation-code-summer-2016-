# Adaptive Cross Correlation Filter (Summer 2016)

1. The `GroundTruthBuilder.m` reads images and UAV logs, and enable the user to annotate their dataset. To speedup the process, I used a `WhiteDetectionAndBlobsValues.m` function that detects 
2. 
3. We mainly look at altitude. The script generates the `groundtruth.xlsx`.
4. Using a subset of `groundtruth.xlsx` data, we esimate a quadratic OLS model to determine the size of landmark from current altitude.
5. We then genereate 2 mannually-designed filters at the estimated dimintions, and apply normalized cross-correlation between the 2 filters. 

![alt text](http://url/to/img.png)

5. Once a match is found, we plot a bounding box around the deteceted landmark [Video]
