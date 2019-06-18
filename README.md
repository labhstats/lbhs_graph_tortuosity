# Project: Graphing and Tortuosity estimation of central Cerebrovascularity.
This repository tries to serve as a guide and back-up of project code, potentially to be used for publication.

### Main issues, which stop it from being worthy of publication
The software is not perfect and may need substantial reworking before they are worth applying to real data in any research project. Issues include, but are not limited to:
- Inclusion of high intensity drainage vessels or noise in the outer part of the brain. [**Skullstrip and Segmentation issue.**]
- Varying intensities across an image, or just different brain vasculatures imply varying degree of the vasculature that is segmentet. And these varyingly segmented vasculatures are therefore not bijective to the tortuosity metrics, due to inhrently "random" biological structures, but also due to deterministic (and random if included) segmentation software choices. [**Bias Field and Segmentation issue.**]
- Both of the previous issues may manifest themselves together in the form of increased tortuosity metrics if many sufficiently small false links are found.
- Removing noise is not a trivial task, because too much filtering of the noise may remove the visibility of small arteries. This is also undesired.

## About the software
The software was created with the intent to try to segment out the "central" vascularity surrounding the Circle of Willis. This is done using each image's own intensity distribution for their own segmentation. The proof of concept was seen discussed in **Kollmannsberger (2017)** [https://doi.org/10.1088/1367-2630/aa764b] and the foundation of our software builds on his code as well [https://github.com/phi-max/skel2graph3d-matlab].

Our implementation is sought verified using different approaches the derivative used in the definition of curvature (in addition to SOAM and SOTM), with **numeric integration** approach based on the **analytic solution** [https://www.math24.net/curvature-radius/ & https://doi.org/10.1016/j.medengphy.2006.07.008] and by using **finite difference (FD)** [https://en.wikipedia.org/wiki/Finite_difference]. These special approaches (at least as implemented) work well for synthetic data, but not in more naturally occurring vessel segments.

### Pre processing
As the method is intensity based, we at least recommend:
1. Skullstripping. (A clean one, or else other parts of the brain with higher intensity may obscure the intensity distribution.)
2. Bias Field Correction. (Helps to find more of the vasculature.)

### Script specific comments
- alpha_graphing_protocol.m - Is the file that segments the cerebrovacularity. Less than preferably optimal.
- do_helix.m - Allows the user to draw a helix with corresponding DM, SOAM, SOTM, etc.
- do_sine.m - Allows the user to draw a helix with corresponding DM, SOAM, SOTM, etc.
- graph_debugging.m - 3D plotting of the graphed artery/vessel/vasculature to aid debugging implementation mistakes and sampling errors.
- helix_curvature.m - Finite difference approach of curvature, requiring parametrization along Z axis.
- sine_curvature.m - Finite difference approach of curvature, requiring only that the curve is in 2D.
- integral_curvature_sine.m - Numerical integration of the analytical solution for curvature; only for sine.
- measure_DM.m - Calculates the Distance Metric (DM), for a curve in 3D space. It also returns the arc length of a curve.
- measure_SOAM.m - Calculates the Sum of Angles Metric (SOAM), for a curve in 3D space.
- measure_SOTM.m - Calculates the Sum of Torsion Metric (SOTM), for a curve in 3D space.
- tortuosity_wrapper.m - A wrapper to calculate tortuosity measurements based on the graphs created by the graphing protocol.
- viz_helix_space_wrapper.m - A script that produces the example images under "/helix/*.jpg".
- viz_sine_space_wrapper.m - A script that produces the example images under "/sine/*.jpg".
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

(Images from FSLeyes' 3D Viewer https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FSLeyes)





















