function [mycel_trval]=prepare_train_val()

mycel_trval=cell(1,1);

all_labels_train=[];
all_labels_val=[];
load('anotations_train')
load('anotations_val')
for i=1:6
    all_labels_train=[all_labels_train anotations_train{1, i}.scores];
    all_labels_val =[all_labels_val anotations_val{1, i}.scores];
end



mycel_trval{1}.trainlabels=all_labels_train;
mycel_trval{1}.testlabels=all_labels_val;

end