% Make SMATRIX
clear all;
clc;
Type={'OG'};

for g=1:6
    
% cd(['C:\Users\dum5\Desktop\KidsStudy\Data\Kids_paper\Group' num2str(g)])
% cd(['C:\Users\dum5\Desktop\KidsStudy\Data\Kids_paper\Group' num2str(g) '\' Type{1} 'RotatedData'])
% cd(['C:\Users\dum5\Desktop\KidsStudy\Data\Kids_paper\Group' num2str(g) '\' Type{1} 'RotatedData\Line'])
% cd(['C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\Group' num2str(g) '\' Type{1} 'RotatedData'])
% cd(['C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\Group' num2str(g) '\' Type{1} 'RotatedData'])
cd(['/Users/dulcemariscal/OneDrive - University of Pittsburgh/aResearch_Studies/KidsStudy/Data/Kids_paper/Group' num2str(g) '/' Type{1} 'RotatedData'])

b=[];
files=what('./'); 
fileList{g}=files.mat;
for l=1:length(fileList{g})
%  a=find(size(fileList{g}{l},2)<12); %Para las matrices normales 
%  a=find(size(fileList{g}{l},2)<26);
% a=find(size(fileList{g}{l},2)>50);
a=find(size(fileList{g}{l},2)<28);
 if a==1
 b(l)=1;
 else
 b(l)=0;    
 end
end

fileList{g}(b==0)=[];
b=[];
for s=1:length(fileList{g})
  
    a=load(fileList{g}{s});
    name=fileList{g}{s}(1:6);
%     Type=fileList{g}{s}(7:8);
    
%     a.RotatedResults.IDs=name;
    Groups=(['Group' num2str(g)]);
    Conditions={'OGBase', 'TMBase','Adaptation1','Catch','Readaptation','OGpost','TMpost','Adaptation2','SomeBaseline'};
    SMatrix.(Groups).Condition=Conditions;
    SMatrix.(Groups).IDs(s)={name};
    SMatrix.(Groups).labels=a.RotatedResults.labels'; 
    SMatrix.(Groups).(name)=a.RotatedResults.Parameters;
   
       
end
%% Individual Age groups SMatrix
% cd(['C:\Users\dum5\Desktop\KidsStudy\Data\Kids_paper\SMatrix\' Type{1} 'SMatrix\Groups\Line'])
% % cd(['C:\Users\dum5\Desktop\KidsStudy\Data\Kids_paper\SMatrix\' Type{1} 'SMatrix\Groups'])
% cd(['C:\Users\maris\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\SMatrix\' Type{1} 'SMAtrix\Line'])
% % % % % cd(['C:\Users\maris\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\SMatrix\' Type{1} 'SMAtrix\Line'])
% % % % % 
% cd(['C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\SMatrix\' Type{1} 'SMatrix\Groups'])
% cd(['C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\SMatrix\' Type{1} 'SMAtrix\Line'])
% save(['Group' num2str(g) Type{1} 'ConcMarixS1.mat'],'SMatrix')
% clear SMatrix

end
%%All ages SMatrix 
% % cd(['C:\Users\dum5\Desktop\KidsStudy\Data\Kids_paper\SMatrix\' Type{1} 'SMatrix'])
% cd(['C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\SMatrix\' Type{1} 'SMAtrix\Line'])
cd(['/Users/dulcemariscal/OneDrive - University of Pittsburgh/aResearch_Studies/KidsStudy/Data/Kids_paper/SMatrix/' Type{1} 'SMAtrix/AddingCandence'])
% % % % % % cd(['C:\Users\maris\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\SMatrix\' Type{1} 'SMAtrix\Line'])
save(['SMatrix' Type{1} 'V7.mat'],'SMatrix')
clear all
%%

%SUBJECTS LN0346 COND==8
% load('Group5TMLine2.mat')
% load('SMatrixTMLine2.mat')
% find(SMatrix.Group5.LN0346(:,1)>16 & SMatrix.Group5.LN0346(:,1)<27);
% SMatrix.Group5.LN0346(ans(:),2)=8;
% Save manually 
