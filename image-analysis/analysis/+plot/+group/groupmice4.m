function [groups, names] = groupmice4(micedb, striosomality)
% Groups mice into 3 groups:
% 1) WT young <= 8 months old on start day
% 2) WT learned 16-18 months
% 3) WT not learned and not ran 18-22 months
% 4) HD not learned

names = {'Age <= 8', 'Learned >= 16', 'Not Learned', 'HD Not Learned'};
groups = {{}, {}, {}, {}};

if strcmp(striosomality, 'all')
    mice = micedb;
else
    mice = micedb(strcmp({micedb.intendedStriosomality}, striosomality));
end

for iMice=1:length(mice)
   mouse = mice(iMice);
   if isempty(mouse.perfusionDate) % Only count histology mice
       continue;
   end
   if mouse.histologyStriosomality == 0 % Only use good striosomality.
       continue;
   end

   age = mouse.firstSessionAge;
   if isempty(age)
       age = plot.group.getperfage(mouse);
   end
   learned = ~isempty(mouse.learnedFirstTask) && mouse.learnedFirstTask > 0;
   health = mouse.Health;

   group = 0;
   if strcmp(health, 'WT')
       if age <= 8 && learned
           group = 1;
       elseif age >= 16 && learned
           group = 2;
       elseif ~learned
           group = 3;
       end
   elseif strcmp(health, 'HD') && ~learned
       group = 4;
   end
   
   fprintf('ID %s, task age: %d, perf age: %d, grp: %d \n', ...
       mouse.ID, age, plot.group.getperfage(mouse), group);
   
   if group > 0
       groups{group}{end+1} = mouse;
   end
end
end
