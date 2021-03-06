function correlationsPerGroupBars(twdb,striosomality,engagement,normalized,xType)

miceIDs = get_mouse_ids(twdb,0,'WT','all',striosomality,'all','all',1,{});
[miceTrials,miceFluorTrials,rewardTones,costTones] = get_all_trials(twdb,miceIDs,0,0);
[WT_reward,WT_cost,WT_area] = correlationsPerGroup(twdb,miceTrials,miceFluorTrials,rewardTones,costTones,miceIDs,'','Strio WT ',engagement,'R',normalized,xType);

WT_sig = sum(abs([WT_reward,WT_cost,WT_area]) > 0.7,2);

WT_maxStrio = photometryRange(miceIDs,miceTrials,miceFluorTrials,rewardTones,costTones,engagement);


WT = WT_maxStrio(WT_sig>0);


miceIDs = get_mouse_ids(twdb,0,'HD','all',striosomality,'all','all',1,{});
[miceTrials,miceFluorTrials,rewardTones,costTones] = get_all_trials(twdb,miceIDs,0,0);
[HD_reward,HD_cost,HD_area] = correlationsPerGroup(twdb,miceTrials,miceFluorTrials,rewardTones,costTones,miceIDs,'','Strio HD ',engagement,'R',normalized,xType);

HD_sig = sum(abs([HD_reward,HD_cost,HD_area]) > 0.7,2);

HD_maxStrio = photometryRange(miceIDs,miceTrials,miceFluorTrials,rewardTones,costTones,engagement);

HD = HD_maxStrio(HD_sig>0);


[~,p] = ttest2(WT,HD,'Vartype','unequal');
[~,p_WT] = ttest(WT);
[~,p_HD] = ttest(HD);

figure
hold on
bar(1,nanmean(WT))
bar(2,nanmean(HD))
errorbar([nanmean(WT),nanmean(HD)],[std_error(WT),std_error(HD)],'.k')
legend('WT','HD')
title({['2 sample t-test (unequal variance) p = ' num2str(p)],['t-test: WT p = ' num2str(p_WT),'HD p = ' num2str(p_HD)]})
