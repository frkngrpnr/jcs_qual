function [ explanations ] = exp_big5_v2(pred_big5,pred_interview, means_big5,gender_pred,pers_emo_feats_cat2_test_face)
% Explanation of predicted interview decision (based on score thresholded
% at 0.5) and binarized big5 scores using means_big5
% see tree_cat2.jpg for illustration of the decision tree implemented here


N=size(pred_interview,1);
explanations=cell(N,2);

pred_big5_cat2=zeros(size(pred_big5));

for i=1:size(pred_big5,2)
    pred_big5_cat2(:,i)=1*(pred_big5(:,i)>=means_big5(i));
end
class_int=(pred_interview>=0.5)*1+1;
gender={'gentleman','lady'};
accusative={'his','her'};
 predictors={'agreeableness','conscientousness','extroversion','neuroticism','openness'};
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
           
    list_audio={};
    list_face={};
    
    for d=1:5
        if (pred_big5_cat2(i,d)==pers_emo_feats_cat2_test_face(i,d)) % if the score is the same this is primarily due to facial features
           list_face=[list_face predictors{d}];
        else
           list_audio=[list_audio predictors{d}]; % if not, it is due to audio modality scores
        end
    end

            
    if (p_agre)
        if (p_neur)
            
            model_decision=2;
            desc= ['This ' gender{gender_pred(i)} ' is invited for an interview due to ' accusative{gender_pred(i)} ' high apparent agreeableness and neuroticism impression.'];
            
        elseif (p_cons)
           
            model_decision=2;
            desc= ['This ' gender{gender_pred(i)} ' is invited for an interview due to ' accusative{gender_pred(i)} ' high apparent agreeableness and conscientiousness impression.'];
        elseif (p_extr)
            model_decision=2;
            desc= ['This ' gender{gender_pred(i)} ' is invited for an interview due to ' accusative{gender_pred(i)} ' high apparent agreeableness and extroversion impression.'];
        else
            desc= ['This ' gender{gender_pred(i)} ' is not invited due to ' accusative{gender_pred(i)} ' low apparent  neuroticism, conscientiousness, and extroversion, although the vlog exhibits high agreeableness.'];
        end
    else % low p_agre
        if (p_neur)
           if (p_cons) 
               if (p_extr)
                   model_decision=2;
                   desc= ['This ' gender{gender_pred(i)} ' is invited for an interview due to ' accusative{gender_pred(i)} ' high apparent neuroticism conscientiousness and extroversion, despite low agreeableness impression.'];
               else
                   if (p_open)
                       desc= ['This ' gender{gender_pred(i)} ' is not invited for an interview due to ' accusative{gender_pred(i)} ' low apparent  agreeableness and extroversion impressions, although predicted scores for neuroticism, conscientiousness and openness were high. ' ...
                       'It is likely that this trait combination (with low agreeableness, low extroversion, and high openness scores) does not leave a genuine impression for job candidacy.']; 
                   else
                       model_decision=2;
                       desc= ['This ' gender{gender_pred(i)} ' is invited for an interview due to ' accusative{gender_pred(i)} ' high apparent neuroticism, conscientiousness,  despite low agreeableness, openness and extroversion.'];
                   end
               end
           else
                desc= ['This ' gender{gender_pred(i)} ' is not invited due to ' accusative{gender_pred(i)} ' low apparent agreeableness and conscientiousness, although high neuroticism is observed.'];
           end
        else
            if (p_cons && p_extr && p_open)
                 model_decision=2;
                 desc= ['This ' gender{gender_pred(i)} ' is invited for an interview due to ' accusative{gender_pred(i)} ' high apparent conscientiousness, extroversion and openness, despite low agreeableness and neuroticism.'];
            else
                 desc= ['This ' gender{gender_pred(i)} ' is not invited due to ' accusative{gender_pred(i)} ' low apparent agreeableness, neuroticism'];
                 if (~p_cons)
                     desc=[desc ', conscientiousness'];
                 end
                 if (~p_extr)
                     desc=[desc ', extroversion'];
                 end
                 if (~p_open)
                      desc=[desc ' and openness'];
                 end
                 
                 desc=[desc ' scores.'];
            end
        end
    end
    nv=numel(list_face);
    na=numel(list_audio);
    if (nv>0)
        desc_vid='';
        if (nv==1)
            desc=[desc ' The impression of ' list_face{1} ' is modulated by facial expressions.'];
        else
            desc_vid=list_face{1};
            for v=2:nv-1
                desc_vid=[desc_vid ', ' list_face{v} ];
            end
             desc_vid=[desc_vid ' and ' list_face{nv}];
             desc=[desc ' The impressions of ' desc_vid ' are primarily gained from facial features.'];
        end     
    end
    
    if (na>0)
        desc_aud='';
        
        if (na==1)
            desc=[desc ' Furthermore, the impression of ' list_audio{1} ' is predominantly modulated by voice.'];
        else
            desc_aud=list_audio{1};
            for v=2:na-1
                desc_aud=[desc_aud ', ' list_audio{v}];
            end
             desc_aud=[desc_aud ' and ' list_audio{na}];
             desc=[desc ' Furthermore, the impressions of ' desc_aud ' are gained particularly through vocal features.'];
        end
        
        
    end
    
    if (model_decision~=class_int(i))
        desc=['The directly predicted interview score and the classification based on traits are not consistent, the ' gender{gender_pred(i)} ' may be re-evalauted. Following explanation is based on predicted traits. ' desc ];
    end
    
    explanations{i,1}=desc;
end

end

