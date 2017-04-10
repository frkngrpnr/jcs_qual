% load and prepare score matrices
load('scores_elm_trval_ff_audio_vd19.mat')
load('scores_elm_trval_ff_lgbptop_vggfer33')
load('scores_elm_test_ff_lgbptop_vggfer33.mat')
load('scores_elm_test_ff_audio_vd19.mat')
load('gt_trval')
load('fusion_systems_test')
alpha=0.75;
%beta=0.7;
% the best overall alpha for weighted fusion is 0.75
% we overrife these scores using RF fusion
scores_final_elm_test=scores_elm_test_ff_lgbptop_vggfer33*alpha+scores_elm_test_ff_audio_vd19*(1-alpha);
% for agreebaleness dimension the best fusion weight is 0.75
%scores_final_elm_test(:,1)=scores_elm_test_ff_lgbptop_vggfer33(:,1)*beta+scores_elm_test_ff_audio_vd19(:,1)*(1-beta);

scores_final_elm_trval=scores_elm_trval_ff_lgbptop_vggfer33*alpha+scores_elm_trval_ff_audio_vd19*(1-alpha);
%scores_final_elm_trval(:,1)=scores_elm_trval_ff_lgbptop_vggfer33(:,1)*beta+scores_elm_trval_ff_audio_vd19(:,1)*(1-beta);

% Fusion with Random Forests (Ensemble of Decision Trees)
rng(2)
%fusion_systems=cell(6,1);

stacked_scores_trn=[scores_elm_trval_ff_lgbptop_vggfer33 scores_elm_trval_ff_audio_vd19];
stacked_scores_val=[scores_elm_test_ff_lgbptop_vggfer33 scores_elm_test_ff_audio_vd19];
% the first dimension (agreeableness) doesn't seem to improve with stacking
for i=1:6
    % comment out the line below to learn new RFs for fusion  
 %   fusion_systems{i}.tb_ff_x2=TreeBagger(200,stacked_scores_trn,gt_trval(:,i),'method','regression','OOBPred','on');
    
    %update trval predictions
    scores_elm_stacked_ind=predict(fusion_systems{i}.tb_ff_x2,stacked_scores_trn);
    scores_final_elm_trval(:,i)=scores_elm_stacked_ind;
    %update test predictions
    scores_elm_stacked=predict(fusion_systems{i}.tb_ff_x2,stacked_scores_val);
    scores_final_elm_test(:,i)=scores_elm_stacked;
    
end

savepath=[opts.output_path opts.bss 'scores_final_elm_trval.mat'];
save(savepath,'scores_final_elm_trval')
 
savepath=[opts.output_path opts.bss 'scores_final_elm_test.mat'];
save(savepath,'scores_final_elm_test')

disp('RF Fusion completed')