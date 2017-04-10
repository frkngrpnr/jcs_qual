% clear all

load('scores_final_elm_trval')
load('scores_final_elm_test')
load('scores_elm_trval_ff_lgbptop_vggfer33')
load('scores_elm_test_ff_lgbptop_vggfer33')
load('gender_labels_test') % these are predicted using models trained on 4000 annotated videos

load('dimensions')

trait_ids=[1 2 3 5 6];
pers_feats_tr=[scores_final_elm_trval(:,trait_ids)]; % 
pers_feats_test=[scores_final_elm_test(:,trait_ids)]; % 

pers_feats_mean_face=mean(scores_elm_trval_ff_lgbptop_vggfer33(:,trait_ids));
pers_feats_test_face= scores_elm_test_ff_lgbptop_vggfer33(:,trait_ids);
clear scores_elm_trval_ff_lgbptop_vggfer33 scores_elm_test_ff_lgbptop_vggfer33

pers_feats_mean=mean(pers_feats_tr);
predictors={'AGRE','CONS','EXTR','NEUR','OPEN'};% 

pers_feats_cat2_tr=zeros(size(pers_feats_tr));
pers_feats_cat2_test=zeros(size(pers_feats_test));
pers_feats_cat2_test_face=zeros(size(pers_feats_test_face));

for i=1:size(pers_feats_tr,2)
    pers_feats_cat2_tr(:,i)=1*(pers_feats_tr(:,i)>=pers_feats_mean(i));
    pers_feats_cat2_test(:,i)=1*(pers_feats_test(:,i)>=pers_feats_mean(i));
    pers_feats_cat2_test_face(:,i)=1*(pers_feats_test_face(:,i)>=pers_feats_mean_face(i));
end

load('gt_trval')

interview_train=gt_trval(:,4); %scores_final_elm_trval(:,4);
interview_test =scores_final_elm_test(:,4);

class_int_tr=(interview_train>=0.5)*1+1;
class_int_test=(interview_test>=0.5)*1+1;
class_cat_tr=cell(size(class_int_tr));
class_cat_test=cell(size(class_int_test));

for i=1:numel(class_int_tr)
    if (class_int_tr(i)==1)
        class_cat_tr{i}='NO';
    else
        class_cat_tr{i}='YES';
    end
end 
for i=1:numel(class_int_test)
    if (class_int_test(i)==1)
        class_cat_test{i}='NO';
    else
        class_cat_test{i}='YES';
    end
end 
tree_cat2=fitctree(pers_feats_cat2_tr,class_cat_tr,'CategoricalPredictors','all','PredictorNames',predictors);

yp=predict(tree_cat2,pers_feats_cat2_test);

view(tree_cat2)
view(tree_cat2,'mode','graph');


explanations_test  = exp_big5(scores_final_elm_test(:,trait_ids),scores_final_elm_test(:,4), pers_feats_mean,gender_labels_test,pers_feats_cat2_test_face);

