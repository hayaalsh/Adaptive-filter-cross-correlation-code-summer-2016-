# Adaptive Cross-Correlation Filter (Summer 2016)

In the summer of 2016, I joined the RISC lab as an undergraduate summer intern. I worked on developing a system to detect a landmark placed on a moving vehicle. The work was part of an international robotics challenge called [Mohamed Bin Zayed International Robotics Challenge](www.mbzirc.com) (MBZIRC).

This was my **very first experience** with computer vision, and I really enjoyed working on this particular problem 😍 The work was not used in the competition for many reasons, one was being computationally intractable under uncertainties in altitude information. If altitude is unknown, one should generate filters at all possible dimensions and cross-correlate each of them with every frame. It would've been exciting to explore switching between these two modes under uncertainty. Alternatively, one could train a DL model that takes care of all that 🤪 (see below).

https://user-images.githubusercontent.com/22026004/145083332-09434125-70c0-4db9-855d-738ef879f433.mp4

1. The `GroundTruthBuilder.m` reads images and UAV logs (mainly look at altitude) and enables users to annotate their dataset. To speed up the process, I used a `WhiteDetectionAndBlobsValues.m` function that detects initial objects of interest. After annotating the entire dataset, the script generates the `groundtruth.xlsx`.
2. Using a subset of `groundtruth.xlsx` data, we esimate a quadratic OLS model to determine the size of landmark from current altitude.

<p align="center">
  <img src="https://github.com/hayaalsh/AdaptiveCrossCorrelationFilterSummer2016/blob/main/alt2lengthmodel.jpg" width="500">
</p>

3. We then generate two manually-designed filters whose scales are automatically updated using the model we developed above. The two scaled filters are then correlated with each frame using normalized cross-correlation. We finally plot a bounding box around the detected landmark and return its pixel coordinates once a match is found (`CrossCorrelation.m`).

<p align="center">
  <img src=https://github.com/hayaalsh/AdaptiveCrossCorrelationFilterSummer2016/blob/main/filter1.png width="300"> <img     src=https://github.com/hayaalsh/AdaptiveCrossCorrelationFilterSummer2016/blob/main/filter2.png width="300">
</p>

**Fun fact:** To my knowladge, in 2016, cheap, light, and commercially-available RGB-D cameras didn't exist neither did the DL models that can estimate depth from images only. You may be wondering, how then did we estimate the 3D location of a point from images only back in the day? What we used to do is a process called camera callibration. You mainly hold a checkerboard of known dimensions and move it infront of the camera, and use the collected data to learn camera paramters and convert pixel coordinates to 3D location of the object. I completely forgot about this step, and I'm very glad that I live at a time where this process is no longer needed as 3D location of an object can be easily measured or even learned.

<p align="center">
  <img src=https://user-images.githubusercontent.com/22026004/145243420-ebecc3ad-dafb-4cf1-b124-3cc404d22437.png width="300"> 
</p>

# DL model results (2017)

https://user-images.githubusercontent.com/22026004/145096884-1841e75b-47ff-496f-a7b2-7c3957db5311.mp4
