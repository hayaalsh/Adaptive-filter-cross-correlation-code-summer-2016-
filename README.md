# Adaptive Cross-Correlation Filter (Summer 2016)

1. The `GroundTruthBuilder.m` reads images and UAV logs (mainly look at altitude) and enables users to annotate their dataset. To speed up the process, I used a `WhiteDetectionAndBlobsValues.m` function that detects initial objects of interest. After annotating the entire dataset, the script generates the `groundtruth.xlsx`.
2. Using a subset of `groundtruth.xlsx` data, we esimate a quadratic OLS model to determine the size of landmark from current altitude.
  <img src="https://github.com/hayaalsh/AdaptiveCrossCorrelationFilterSummer2016/blob/main/alt2lengthmodel.jpg" width="500">

3. We then generate two manually-designed filters whose scales are automatically updated using the model we developed above. The two scaled filters are then correlated with each frame using normalized cross-correlation. 

  <img src=https://github.com/hayaalsh/AdaptiveCrossCorrelationFilterSummer2016/blob/main/filter1.png width="300"> <img     src=https://github.com/hayaalsh/AdaptiveCrossCorrelationFilterSummer2016/blob/main/filter2.png width="300">

4. We plot a bounding box around the detected landmark and return its pixel coordinates once a match is found.

https://user-images.githubusercontent.com/22026004/145083332-09434125-70c0-4db9-855d-738ef879f433.mp4

Note: This model will fail catastrophically if the altitude information isn't correct. If altitude is unknown, we need to generate filters at all possible dimensions and cross-correlate each of them with every frame. Alternatively, one could train a DL model that takes care of all that.
