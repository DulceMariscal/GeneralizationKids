
%% Concatenar Matrixs
clc;
clear all;

% cd('C:\Users\dum5\Desktop\KidsStudy\Data\Kids_paper\SMatrix\OGSMatrix')
% cd('C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\SMatrix\OGSMatrix')
cd('/Users/dulcemariscal/OneDrive - University of Pittsburgh/aResearch_Studies/KidsStudy/Data/Kids_paper/SMatrix/OGSMAtrix/AddingCandence')
% cd('C:\Users\maris\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\SMatrix\OGSMatrix')
files=what('./'); 
fileListOG=files.mat;
OGSMatrix=load(fileListOG{end});
OGSMatrix=OGSMatrix.SMatrix;

% cd('C:\Users\dum5\Desktop\KidsStudy\Data\Kids_paper\SMatrix\TMSMAtrix')
% cd(['C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\SMatrix\TMSMAtrix'])
% cd(['C:\Users\maris\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\SMatrix\TMSMAtrix'])

cd('/Users/dulcemariscal/OneDrive - University of Pittsburgh/aResearch_Studies/KidsStudy/Data/Kids_paper/SMatrix/TMSMAtrix/AddingCandence')
files=what('./'); 
fileListTM=files.mat;
TMSMatrix=load(fileListTM{end});
TMSMatrix=TMSMatrix.SMatrix;

% cd('C:\Users\dum5\Desktop\KidsStudy\Data\Kids_paper\SMatrix')
% cd('C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\SMatrix\ConcSMatrixLineAll')
cd('/Users/dulcemariscal/OneDrive - University of Pittsburgh/aResearch_Studies/KidsStudy/Data/Kids_paper/SMatrix/ConcSMatrixLineAll')
% cd('C:\Users\maris\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\SMatrix\ConcSMatrixLineAll')

for g=1:6
      
    Groups=(['Group' num2str(g)]);
    OGFilesName=fieldnames(OGSMatrix.(Groups));
    OGFilesName=OGFilesName(4:end);
    cond=OGSMatrix.(Groups).Condition;
    labels=OGSMatrix.(Groups).labels;
    
    
    for s=1:length(OGFilesName)
       
      
        name=OGFilesName{s}(1:6);
        ConcMatrix.(Groups).Condition=cond;
        ConcMatrix.(Groups).IDs(s)={name};
        ConcMatrix.(Groups).labels=labels;
        ConcMatrix.(Groups).(name)=[OGSMatrix.(Groups).(name); TMSMatrix.(Groups).(name)];
        
    end
 %% Individual age groups 
% cd('C:\Users\dum5\Desktop\KidsStudy\Data\Kids_paper\SMatrix\ConcGRoups')
% cd('C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\SMatrix\ConcSMatrixLineAll\Groups')
% % % % cd('C:\Users\maris\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\SMatrix\ConcSMatrixLineAll')
% save(['ConcMatrixGroup' num2str(g) 'LineV2.mat'],'ConcMatrix')
% clear ConcMatrix
end
%%All ages groups 
% cd('C:\Users\dum5\Desktop\KidsStudy\Data\Kids_paper\SMatrix\')
% cd('C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\SMatrix\ConcSMatrixLineAll')
% cd('C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\SMatrix\ConcSMatrixLineAll')
cd('/Users/dulcemariscal/OneDrive - University of Pittsburgh/aResearch_Studies/KidsStudy/Data/Kids_paper/SMatrix/ConcSMatrixLineAll')
save('ConcMatrixV7.mat','ConcMatrix')
clear all
