% load and prepare score matrices
load('scores_elm_trcv_ff_audio_vd19.mat')
load('scores_elm_trcv_ff_lgbptop_vggfer33')
load('scores_elm_val_ff_lgbptop_vggfer33.mat')
load('scores_elm_val_ff_audio_vd19.mat')
load('gt_trcv')
load('fusion_systems_val')
alpha=0.75;
beta=0.7;
% the best overall alpha for weighted fusion is 0.75
% we overrife these scores using RF fusion
scores_final_elm_val=scores_elm_val_ff_lgbptop_vggfer33*alpha+scores_elm_val_ff_audio_vd19*(1-alpha);
% for agreebaleness dimension the best fusion weight is 0.75
scores_final_elm_val(:,1)=scores_elm_val_ff_lgbptop_vggfer33(:,1)*beta+scores_elm_val_ff_audio_vd19(:,1)*(1-beta);

scores_final_elm_trcv=scores_elm_trcv_ff_lgbptop_vggfer33*alpha+scores_elm_trcv_ff_audio_vd19*(1-alpha);
scores_final_elm_trcv(:,1)=scores_elm_trcv_ff_lgbptop_vggfer33(:,1)*beta+scores_elm_trcv_ff_audio_vd19(:,1)*(1-beta);

% Fusion with Random Forests (Ensemble of Decision Trees)
rng(2)
%fusion_systems_val=cell(6,1);

stacked_scores_trn=[scores_elm_trcv_ff_lgbptop_vggfer33 scores_elm_trcv_ff_audio_vd19];
stacked_scores_val=[scores_elm_val_ff_lgbptop_vggfer33 scores_elm_val_ff_audio_vd19];
% the first dimension (agreeableness) doesn't seem to improve with stacking
for i=1:6
    % comment out the line below to learn new RFs for fusion  
    %fusion_systems_val{i}.tb_ff_x2=TreeBagger(200,stacked_scores_trn,gt_trcv(:,i),'method','regression','OOBPred','on');
    
    %update trcv predictions
%    scores_elm_trcv_ind=oobPredict(fusion_systems_val{i}.tb_ff_x2);
    scores_elm_trcv_ind=predict(fusion_systems_val{i}.tb_ff_x2,stacked_scores_trn);
    scores_final_elm_trcv(:,i)=scores_elm_trcv_ind;
    %update val predictions
    scores_elm_val_ind=predict(fusion_systems_val{i}.tb_ff_x2,stacked_scores_val);
    scores_final_elm_val(:,i)=scores_elm_val_ind;
    
end

savepath=[opts.output_path opts.bss 'scores_final_elm_trcv.mat'];
save(savepath,'scores_final_elm_trcv')
 
savepath=[opts.output_path opts.bss 'scores_final_elm_val.mat'];
save(savepath,'scores_final_elm_val')

disp('RF Fusion completed')