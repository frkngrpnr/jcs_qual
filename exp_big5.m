function [ explanations ] = exp_big5(pred_big5,pred_interview, means_big5,gender_pred,pers_emo_feats_cat2_test_face)
% Explanation of predicted interview decision (based on score thresholded
% at 0.5) and binarized big5 scores using means_big5
% see tree_cat2.jpg for illustration of the decision tree implemented here

% predictors={'agreeableness','conscientousness','extroversion','neuroticism','openness'};
N=size(pred_interview,1);
explanations=cell(N,2);

pred_big5_cat2=zeros(size(pred_big5));

for i=1:size(pred_big5,2)
    pred_big5_cat2(:,i)=1*(pred_big5(:,i)>=means_big5(i));
end
class_int=(pred_interview>=0.5)*1+1;
gender={'gentleman','lady'};
accusative={'his','her'};
for i=1:N
    model_decision=1;
    if (class_int(i)==1)
       explanations{i,1}=['We are sorry so say that we could not find a suitable position for this ' gender{gender_pred(i)} '.'];
       explanations{i,2}='NO'; % decision of interview 
    else
       explanations{i,1}=['Congrats! This ' gender{gender_pred(i)} ' is up for an interview!'];
       explanations{i,2}='YES'; 
    end
    desc='';  
    p_agre= pred_big5_cat2(i,1);
    p_cons= pred_big5_cat2(i,2);
    p_extr= pred_big5_cat2(i,3);
    p_neur= pred_big5_cat2(i,4);
    p_open= pred_big5_cat2(i,5);
    
    p_agre_face= pers_emo_feats_cat2_test_face(i,1);
    p_cons_face= pers_emo_feats_cat2_test_face(i,2);
    p_extr_face= pers_emo_feats_cat2_test_face(i,3);
    p_neur_face= pers_emo_feats_cat2_test_face(i,4);
    p_open_face= pers_emo_feats_cat2_test_face(i,5);
    
    if (p_agre==p_agre_face) % if the score is the same this is primarily due to facial features
         desc_agre=' (the impression of which is gained primarily from facial expressions),';
       else
         desc_agre=' (the impression of which is modulated by voice),';
    end
    
    if (p_cons==p_cons_face) % if the score is the same this is primarily due to facial features
        desc_cons=' (the impression of which is influenced by facial features)';
      else
        desc_cons=' (the impression of which is gained from vocal features)';
    end
    
    if (p_neur==p_neur_face) % if the score is the same this is primarily due to facial features
      desc_neur=' (the impression of which is modulated by facial features)';
    else
      desc_neur=' (the impression of which is influenced by vocal features)';
    end
    
    
    if (p_extr==p_extr_face) % if the score is the same this is primarily due to facial features
      desc_extr=' (the impression of which is observed from facial expressions)';
    else
      desc_extr=' (the impression of which is influenced by vocal features)';
    end
        
    if (p_open==p_open_face) % if the score is the same this is primarily due to facial features
      desc_open=' (the impression of which is modulated by facial features)';
    else
      desc_open=' (the impression of which is influenced by vocal features)';
    end
            
    if (p_agre)
        if (p_neur)
            
            model_decision=2;
            desc= ['This ' gender{gender_pred(i)} ' is invited for an interview due to ' accusative{gender_pred(i)} ' high apparent agreeableness' desc_agre ' and neuroticism impression.'];
            
        elseif (p_cons)
           
            model_decision=2;
            desc= ['This ' gender{gender_pred(i)} ' is invited for an interview due to ' accusative{gender_pred(i)} ' high apparent agreeableness' desc_agre ' and conscientiousness impression.'];
        elseif (p_extr)
            model_decision=2;
            desc= ['This ' gender{gender_pred(i)} ' is invited for an interview due to ' accusative{gender_pred(i)} ' high apparent agreeableness' desc_agre ' and extroversion impression.'];
        else
            desc= ['This ' gender{gender_pred(i)} ' is not invited due to ' accusative{gender_pred(i)} ' low apparent  neuroticism' desc_neur ', conscientiousness, and extroversion, although the vlog exhibits high agreeableness.'];
        end
    else % low p_agre
        if (p_neur)
           if (p_cons) 
               if (p_extr)
                   model_decision=2;
                   desc= ['This ' gender{gender_pred(i)} ' is invited for an interview due to ' accusative{gender_pred(i)} ' high apparent neuroticism ' desc_neur ' conscientiousness and extroversion, despite low agreeableness impression.'];
               else
                   if (p_open)
                       desc= ['This ' gender{gender_pred(i)} ' is not invited for an interview due to ' accusative{gender_pred(i)} ' low apparent  agreeableness ' desc_agre ' and extroversion impression, although predicted scores for neuroticism, conscientiousness and openness were high. ' ...
                       'It is likely that this trait combination (with low agreeableness, low extroversion, and high openness scores) does not leave a genuine impression for job candidacy.']; 
                   else
                       model_decision=2;
                       desc= ['This ' gender{gender_pred(i)} ' is invited for an interview due to ' accusative{gender_pred(i)} ' high apparent neuroticism ' desc_neur ', conscientiousness,  despite low agreeableness, openness and extroversion.'];
                   end
               end
           else
                desc= ['This ' gender{gender_pred(i)} ' is not invited due to ' accusative{gender_pred(i)} ' low apparent agreeableness' desc_agre ' and conscientiousness, although high neuroticism is observed.'];
           end
        else
            if (p_cons && p_extr && p_open)
                 model_decision=2;
                 desc= ['This ' gender{gender_pred(i)} ' is invited for an interview due to ' accusative{gender_pred(i)} ' high apparent conscientiousness' desc_cons ', extroversion and openness, despite low agreeableness and neuroticism.'];
            else
                 desc= ['This ' gender{gender_pred(i)} ' is not invited due to ' accusative{gender_pred(i)} ' low apparent agreeableness' desc_agre ' neuroticism'];
                 if (~p_cons)
                     desc=[desc ', conscientiousness'];
                 end
                 if (~p_extr)
                     desc=[desc ', extroversion'];
                 end
                 if (~p_open)
                      desc=[desc ' and openness'];
                 end
                 
                 desc=[desc '.'];
            end
        end
    end
    
    if (model_decision~=class_int(i))
        desc=['The directly predicted interview score and the classification based on traits are not consistent, the ' gender{gender_pred(i)} ' may be re-evalauted. Following is explanation is based on predicted traits. ' desc ];
    end
    
    explanations{i,1}=desc;
end

end

