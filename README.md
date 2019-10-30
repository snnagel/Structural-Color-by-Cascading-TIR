# Structural-Color-by-Cascading-TIR
This repository contains MATLAB code that calculates the color expected from interference of light undergoing total internal reflection along microscale concave structures, as shown in https://rdcu.be/boHno. No other software is required.

To generate images of the color distribution download all files into one folder and open CreateColorDistribution.m in MATLAB, set your input parameters and run. Be sure that any subfolders are included on the matlab path. 

Typical runtime is about 1-10 minutes depending on resolution of the calculation

For 2D analysis comparison to cylinders, run AnalysisCylinder.m from the 2DImageAnalysisAndCalc folder.  The dependency on various parameters can be created from parameterTrends.m
