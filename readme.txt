This folder contains the code for our entry in the Apparent Personality Analysis and Job Candidate Screening Coopetition Workshop @CVPR 2017.

%% Notes
0) To reproduce the test set results, run main_qual_test.m (you may wish to un/set some options for feature extraction/model learning/modality fusion and writing the predictions).

1) This code runs in MATLAB, and tested in a Linux system, if you want to run it on a Windows-based system instead, please change line 12 of main_qual_*.m accordingly, i.e. bss = '\';

2) Since the features are too big to upload to GitHub, they are placed in a separate folder. You can find them on the following  link:
 https://drive.google.com/open?id=1RUN5CKh9-jCdjo9yJ1L4BaTpYs7VA4sG
Please make sure that the .mat files are placed under the path ./data/features/.
If you use the features in your work, please cite:
F. Gürpınar, H. Kaya, A.A. Salah, "Multimodal Fusion of Audio, Scene, and Face Features for First Impression Estimation", ChaLearn Joint Contest and Workshop on Multimedia Challenges Beyond Visual Analysis -Collocated with ICPR2016, 2016 

3) The code produces the test set estimations and explanations using the development (training+validation) set. Note that the features extracted contain both training, validation and test set instances. In the given features, the test set instances are separated to ease memory/computations. In addition to the quantitative stage, here we provide gender annotations/predictions for training, validation and test sets. We manually annotated 4000 development set videos, using the first frames of each video. Then trained classifiers using the video features extracted for this challenge (see item 2). The predictions on the remaining 4000 devel and 2000 test sets are casted by equal weight score fusion of models trained on VGGFER37FUN (DCNN features from video) and OS_IS13 (audio) features.

4) To avoid conflict of interest, we didn't include third party tools and pre-trained models used for face detection and (partly) in feature extraction. We, however, indicated the necessary pointers and links for these external resources
For face alignment, you need the IntraFace library. For feature extraction, you need VLFeat (available at http://www.vlfeat.org/download.html), MatConvNet (available at http://www.vlfeat.org/matconvnet/) and OpenSmile (available at http://audeering.com/research/opensmile/) libraries installed. For audio feature extraction, we use the IS13_ComParE.conf file.

5) Our FER 2013 fine-tuned VGG-Face network model can be accessed from: https://drive.google.com/open?id=0B2KpGwIOmPOieURkZE5aX3VIaFE
If you use this fine-tuned network, please also cite:
H. Kaya, F. Gürpınar, A. A. Salah, "Video-Based Emotion Recognition in the Wild using Deep Transfer Learning and Score Fusion", Image and Vision Computing, Available online 4 February 2017, http://dx.doi.org/10.1016/j.imavis.2017.01.012.

6) If the corresponding flag is set, the test set predictions will be written to prediction.pkl and the explanations will be written to description.pkl, both of which are read from predictions.csv that we create from final predicitons. 

7) The descriptive images that show the faces and the mean normalized (pedicted) scores can be reproduced using the given codes (using saveimg routine) or alternatively they can be accessed from https://www.dropbox.com/s/e4wkwudijuyjy81/testimages.zip?dl=0 


For any queries email: kaya.heysem@gmail.com
Happy hacking!
Heysem, Furkan & Albert
