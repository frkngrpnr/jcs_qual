% clear all
load('vggfer37fun.mat')
load('scores_final_elm_trcv')
load('scores_final_elm_val')
load('qual_video_info')
load('gender_labels_tr_val')

load('dimensions')
mean_emo=vggfer37fun.data(:,1:7);
mean_emo_tr=mean_emo(vggfer37fun.fold==1,:);
mean_emo_val=mean_emo(vggfer37fun.fold==2,:);
clear vggfer37fun
mean_emo_tr=logsig(mean_emo_tr);
mean_emo_val=logsig(mean_emo_val);
% the emotions strongly correlated with interview variable (descending absolute order):
%  happiness(+0.372), surprise(+0.358), angry(-0.328), sad(-0.297), fear(-0.274)
pos_emo_tr=[mean_emo_tr(:,4)-mean_emo_tr(:,5)];
pos_emo_val=[mean_emo_val(:,4)-mean_emo_val(:,5)];
trait_ids=[1 2 3 5 6];
pers_emo_feats_tr=[scores_final_elm_trcv(:,trait_ids)]; % 
pers_emo_feats_val=[scores_final_elm_val(:,trait_ids)]; % 

pers_emo_feats_mean=mean(pers_emo_feats_tr);
predictors={'AGRE','CONS','EXTR','NEUR','OPEN'};% 

pers_emo_feats_cat2_tr=zeros(size(pers_emo_feats_tr));
pers_emo_feats_cat2_val=zeros(size(pers_emo_feats_val));

for i=1:size(pers_emo_feats_tr,2)
    pers_emo_feats_cat2_tr(:,i)=1*(pers_emo_feats_tr(:,i)>=pers_emo_feats_mean(i));
    pers_emo_feats_cat2_val(:,i)=1*(pers_emo_feats_val(:,i)>=pers_emo_feats_mean(i));
    
end

load('anotations_train')
%load('anotations_val')

interview_train=anotations_train{4}.scores; %scores_final_elm_trcv(:,4);
interview_val =scores_final_elm_val(:,4);

class_int_tr=(interview_train>=0.5)*1+1;
class_int_val=(interview_val>=0.5)*1+1;
class_cat_tr=cell(size(class_int_tr));
class_cat_val=cell(size(class_int_val));

for i=1:numel(class_int_tr)
    if (class_int_tr(i)==1)
        class_cat_tr{i}='NO';
    else
        class_cat_tr{i}='YES';
    end
end 
for i=1:numel(class_int_val)
    if (class_int_val(i)==1)
        class_cat_val{i}='NO';
    else
        class_cat_val{i}='YES';
    end
end 
tree_cat2=fitctree(pers_emo_feats_cat2_tr,class_cat_tr,'CategoricalPredictors','all','PredictorNames',predictors);

yp=predict(tree_cat2,pers_emo_feats_cat2_val);

view(tree_cat2)
view(tree_cat2,'mode','graph');
accuracy_traits_to_interview=sum(strcmp(class_cat_val,yp))/2000

qual_scores_final_elm_val=scores_final_elm_val(qual_val_ids,:);
gender_pred=gender_labels_val(qual_val_ids);

explanations  = exp_big5(qual_scores_final_elm_val(:,trait_ids),qual_scores_final_elm_val(:,4), pers_emo_feats_mean,gender_pred);

