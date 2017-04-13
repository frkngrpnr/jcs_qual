function [r1]=prepare_submission_qual(scores_elm,explanations,dimensions,test_filenames)

writepd('predictions.csv',scores_elm,test_filenames,dimensions,explanations);
command='python readPickles_hk_v3.py > preds_and_descs.txt'; % works fine in Linux (Ubuntu)
r1=system(command);
if (r1==0)
    disp('Predictions and descriptions are written to prediction.pkl and description.pkl files, respectively');
end

end