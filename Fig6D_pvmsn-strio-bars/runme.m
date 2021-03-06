% Load files: analysisdb.mat, micedb.mat
COLORS = cbrewer('qual', 'Set2', 10);
CELLS_MOUSE63 = [0 0 1 2 1 1 2 0 0 1 1 0 0 2 1 2 0 0 0 1 1 2 2 0 1];

[groupsStrio, namesStrio] = groupmice4(micedb, 'Strio');
[datStrio, nStrioAnimals] = ...
    cellfun(@(group) getgroupdata(analysisdb, group), groupsStrio, 'UniformOutput', false);
% We include a manually counted CTYNL mouse here (ID = 63)
datStrio{3} = [datStrio{3} CELLS_MOUSE63];
nStrioAnimals{3} = nStrioAnimals{3} + 1;

figure;
plotbars(datStrio, namesStrio, COLORS, 'nodots');
title('Bars - Cell Level');
xlabel('Groups');
ylabel('# Putative Terminals');
title(['PVMSN - STRIO - CELLS - ' newline ...
    mktitle(namesStrio, nStrioAnimals, datStrio)]);

n = length(namesStrio);
pairs = nchoosek(1:n,2);
for i=1:size(pairs,1)
    a = pairs(i,1);
    b = pairs(i,2);
    
    x = datStrio{a};
    y = datStrio{b};
    if isempty(x) || isempty(y)
        continue;
    end
    
    [~,ttestp] = ttest2(x,y);
    signrankp = ranksum(x,y);
    fprintf(['ttest: ' namesStrio{a} ' v ' namesStrio{b} ' p=%.3f \n'], ttestp);
    fprintf(['signrank: ' namesStrio{a} ' v ' namesStrio{b} ' p=%.3f \n'], signrankp);
end

function [data, nAnimals] = getgroupdata(analysisdb, group)
data = [];
nAnimals = 0;
for i=1:length(group)
    mouse = group{i};
    blobs = getblobs(analysisdb, mouse.ID);
    if isempty(blobs)
        continue;
    end
        
    getperfage(mouse)
    data = [data blobs(~isnan(blobs))];
    nAnimals = nAnimals + 1;
end

fprintf("--------------------\n");
end

function ttle = mktitle(names, nAnimals, dat)
n = length(names);
nCells = cellfun(@length, dat);

ttlCells = ['CELLS'];
for i=1:n
    ttlCells = [ttlCells  '    ' ...
        sprintf(['# ' names{i} ' = %d'], nCells(i))];
end

ttlAnimals = ['ANIMALS'];
for i=1:n
    ttlAnimals = [ttlAnimals  '    ' ...
        sprintf(['# ' names{i} ' = %d'], nAnimals{i})];
end
ttle = [ttlCells newline ttlAnimals];
end
