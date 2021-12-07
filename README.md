# Adaptive Cross-Correlation Filter (Summer 2016)

In the summer of 2016, I joined the RISC lab as an undergraduate summer intern. I worked on developing a system to detect a landmark placed on a moving vehicle. The work was part of an international robotics challenge called [Mohamed Bin Zayed International Robotics Challenge](www.mbzirc.com) (MBZIRC). The work was never used in the actual competition because it wasn't computationally efficient. 

This was my **very first experience** with computer vision, and I really had fun working on this particular problem. The work was never used on the competition day because it's computationally intractable under altitude information uncertainty. If altitude is unknown, one should generate filters at all possible dimensions and cross-correlate each of them with every frame. It would've been exciting to explore switching between these two modes depending on altitude uncertainty. Alternatively, one could train a DL model that takes care of all that (see below).

https://user-images.githubusercontent.com/22026004/145083332-09434125-70c0-4db9-855d-738ef879f433.mp4

1. The `GroundTruthBuilder.m` reads images and UAV logs (mainly look at altitude) and enables users to annotate their dataset. To speed up the process, I used a `WhiteDetectionAndBlobsValues.m` function that detects initial objects of interest. After annotating the entire dataset, the script generates the `groundtruth.xlsx`.
2. Using a subset of `groundtruth.xlsx` data, we esimate a quadratic OLS model to determine the size of landmark from current altitude.

  <img src="https://github.com/hayaalsh/AdaptiveCrossCorrelationFilterSummer2016/blob/main/alt2lengthmodel.jpg" width="500">

3. We then generate two manually-designed filters whose scales are automatically updated using the model we developed above. The two scaled filters are then correlated with each frame using normalized cross-correlation. We finally plot a bounding box around the detected landmark and return its pixel coordinates once a match is found (`CrossCorrelation.m`).

  <img src=https://github.com/hayaalsh/AdaptiveCrossCorrelationFilterSummer2016/blob/main/filter1.png width="300"> <img     src=https://github.com/hayaalsh/AdaptiveCrossCorrelationFilterSummer2016/blob/main/filter2.png width="300">



# DL model results (2017)

https://user-images.githubusercontent.com/22026004/145096884-1841e75b-47ff-496f-a7b2-7c3957db5311.mp4
