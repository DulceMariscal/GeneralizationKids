

clear all;
clc;
Type={'OG'};

for g=1
    
cd(['C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\Group' num2str(g) '\' Type{1} 'RotatedData'])

b=[];
files=what('./'); 
fileList{g}=files.mat;
for l=1:length(fileList{g})
a=find(size(fileList{g}{l},2)<28);
 if a==1
 b(l)=1;
 else
 b(l)=0;    
 end
end

fileList{g}(b==0)=[];
b=[];


cd(['C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\Group' num2str(g)])
bGTO=[];
filesGTO=what('./'); 
fileListGTO{g}=filesGTO.mat;
for lGTO=1:length(fileListGTO{g})
aGTO=find(size(fileListGTO{g}{lGTO},2)<28);
 if aGTO==1
 bGTO(lGTO)=1;
 else
 bGTO(lGTO)=0;    
 end
end

fileListGTO{g}(b==0)=[];
b=[];


for s=1:length(fileList{g})

    cd(['C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\Group' num2str(g) '\' Type{1} 'RotatedData'])
    a=load(fileList{g}{s});
    cd(['C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\Group' num2str(g)])
    GTO=load(fileListGTO{g}{s});
  
    
figure
plot(a.RotatedResults.Parameters(:,27),'b')
   hold on 
   plot(GTO.DATAOG(:,34),'--k')
   legend('Us','GTO')
   title(['Group' num2str(g)  fileListGTO{g}{s}])    
end



end

%%
COOGDataSlow=(-abs(DATAOG(:,25))+abs(DATAOG(:,47)))/2;
COOGDataFast=(-abs(DATAOG(:,26))+abs(DATAOG(:,48)))/2;
CO=COOGDataFast-COOGDataSlow;



figure;hold on
plot(DATAOG(:,25))
plot(abs(DATAOG(:,25)),'.-m')
plot(RotatedResults.Parameters(:,21),'--b')
title('Alpha Slow')
legend('GTO','GTOabs','Pitt')

figure;hold on
plot(DATAOG(:,26))
plot(abs(DATAOG(:,26)),'.-m')
plot(RotatedResults.Parameters(:,22),'--b')
title('Alpha Fast')
legend('GTO','GTOabs','Pitt')


figure;hold on
plot(DATAOG(:,47))
plot(-abs(DATAOG(:,47)),'.-m')
plot(RotatedResults.Parameters(:,23),'--b')
title('Beta Slow')
legend('GTO','GTOabs','Pitt')

figure;hold on
plot(DATAOG(:,48))
plot(-abs(DATAOG(:,48)),'.-m')
plot(RotatedResults.Parameters(:,24),'--b')
title('Beta Fast')
legend('GTO','GTOabs','Pitt')

figure()
plot(DATAOG(:,34))
hold on
plot(CO,'.-m')
plot(RotatedResults.Parameters(:,27),'--b')
title('center of oscillation')
legend('GTO','CO','Pitt')