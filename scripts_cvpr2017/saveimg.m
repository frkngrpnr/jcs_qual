%close all
%load('scores_final_elm_test')
%load('scores_final_elm_trval')
mean_scores=mean(scores_final_elm_trval);
mr_scores_test=bsxfun(@minus,scores_final_elm_test,mean_scores);
dims={'AGRE','CONS','EXTR','INTER','NEUR','OPEN'};
permute=[1 2 3 5 6 4];
base_path=opts.base_path;
list_img=dir([base_path opts.bss 'testfaces' opts.bss '*.JPG']);
fig=figure;
fig.InnerPosition=[400 240 355 200];
for i=1:numel(list_img)
    subplot(1,2,1)
    im=imread([base_path opts.bss 'testfaces' opts.bss list_img(i).name]);
    imshow(im)
    subplot(1,2,2)
    h=barh(mr_scores_test(i,permute)',0.5);
    set(gca,'YTickLabel',dims(permute))
    set(gca,'XLim',[-0.5,0.5])
    title('Mean Normalized Score')
    export_fig([base_path opts.bss 'testimages' opts.bss list_img(i).name],'-nocrop','-q100')
end
close all