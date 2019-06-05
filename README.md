# Project: Graphing and Tortuosity estimation of central Cerebrovascularity (GTecC)
This repository tries to serve as a guide and back-up of project code, potentially to be used for publication.

## About the software
The software was created with the intent to try to segment out the "central" vascularity surrounding the Circle of Willis. This is done using each image's own intensity distribution for their own segmentation. The proof of concept was seen discussed in Kollmannsberger (2017) [https://doi.org/10.1088/1367-2630/aa764b] and the foundation of our software builds on his code as well [https://github.com/phi-max/skel2graph3d-matlab].

As any code that is created hastily, it is rough around the edges; so don't expect perfection. 

### Pre processing
As the method is intensity based, we at least recommend:
1. Skullstripping. (A clean one, or else other parts of the brain with higher intensity may obscure the intensity distribution.)
2. Bias Field Correction. (Helps to find more of the vasculature.)

### Script specific comments
- alpha_graphing_protocol.m - Is the file that segments the cerebrovacularity.
- measure_tortuosity.m - Is the file that measures the tortuosity (different metrics) based on the segmented cerebrovascularity.
- phantom_vessel_example.m - An example, similar to Bullitt (2003), to ensure that the tortuosity metrics are correctly implemented and used as a tool in deciding which re-sampling rate should be used.
- graph_debugging.m - 3D plotting of the graphed artery/vessel/vasculature to aid debugging implementation mistakes and sampling errors.
- down_sample_link.m - A script for downsampling the links created in the graphing protocol. It was necessary, because the link resolution was too detailed to give expected values from the tortuosity metrics. An "optimal" rate may be deduced by running the synthetic data example across different rates.
- safeAcos.m - A safe arccosine to correct possible errors.


### What you need to use this software
1. The software that creates the graphs from skeletons can be found at https://github.com/phi-max/skel2graph3d-matlab.
2. Matlab2018a (or a newer version).
3. Either your own 3D images or the synthetic arteries created in the "phantom_vessel_example.m".

### How to install
- As with Matlab software solely consisting of ".m" files you just dump it in a path where Matlab checks for ".m" scripts.

### Probable maximum potential of the software (Assuming decent images, and the previous)

- 1 Binarization of vasculature
![Binarizatio of vasculature](https://github.com/labhstats/lbhs_graph_tortuosity/blob/master/screenshot_O_variant_presTortuosity.png)

- 2 Graphing of binarization
![Graphing of binarized vasculature](https://github.com/labhstats/lbhs_graph_tortuosity/blob/master/screenshot_O_variant_skel_presTortuosity.png)

(Images from FSLeyes https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FSLeyes)





















