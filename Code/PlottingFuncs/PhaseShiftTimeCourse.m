
cd('C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\Group5')
load('LN0360.mat')
cd('C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\SMatrix\OGSMatrix\Line')
load('Group5OGConcMarixV3.mat')
figure
plot(SMatrix.Group5.LN0360(:,28),'k')
hold on 
plot(DATAOG(:,17),'--r')
legend('GTO_PS','DM_PS')
legend('GTO-PS','DM-PS')
title('Group5 LN0360')
ylabel('Phase Shift')
xlabel('Number strides OG')


cd('C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\Group5')
load('LN0374.mat')
cd('C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\SMatrix\OGSMatrix\Line')
load('Group5OGConcMarixV3.mat')
figure
plot(SMatrix.Group5.LN0374(:,28),'k')
hold on 
plot(DATAOG(:,17),'--r')
legend('DM-PS','GTO-PS')
title('Group5 LN0374')
ylabel('Phase Shift')
xlabel('Number strides OG')

cd('C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\Group5')
load('LN0361.mat')
cd('C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\SMatrix\OGSMatrix\Line')
load('Group5OGConcMarixV3.mat')
figure
plot(SMatrix.Group5.LN0361(:,28),'k')
hold on 
plot(DATAOG(:,17),'--r')
legend('DM-PS','GTO-PS')
title('Group5 LN0374')
ylabel('Phase Shift')
xlabel('Number strides OG')


cd('C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\Group5')
load('LN0361.mat')
cd('C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\SMatrix\OGSMatrix\Line')
load('Group5OGConcMarixV3.mat')
figure
plot(SMatrix.Group5.LN0361(:,28),'k')
hold on 
plot(DATAOG(:,17),'--r')
legend('DM-PS','GTO-PS')
title('Group5 LN0361')
ylabel('Phase Shift')
xlabel('Number strides OG')

cd('C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\Group1')
load('LN0319.mat')
cd('C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\SMatrix\OGSMatrix\Line')
figure
load('Group1OGConcMarixV3.mat')
plot(SMatrix.Group1.LN0319(:,28),'k')
hold on 
plot(DATAOG(:,17),'--r')
legend('DM-PS','GTO-PS')
title('Group1 LN0369')
ylabel('Phase Shift')
xlabel('Number strides OG')

cd('C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\Group2')
load('LN0341.mat')
cd('C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\SMatrix\OGSMatrix\Line')
figure
load('Group2OGConcMarixV3.mat')
plot(SMatrix.Group2.LN0341(:,28),'k')
hold on 
plot(DATAOG(:,17),'--r')
legend('DM_PS','GTO_PS')
title('Group2 LN0341')
ylabel('Phase Shift')
xlabel('Number strides OG')


%% CENTER OF OSCILLATION 

%Group 2
cd('C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\Group2')
load('LN0364.mat')
cd('C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\SMatrix\OGSMatrix\Line')
load('Group2OGConcMarixV3.mat')
figure
plot(SMatrix.Group2.LN0364(:,27),'k')
hold on 
plot(DATAOG(:,34),'--r')
legend('DM_PS','GTO_PS')
title('Group2 LN0364')
ylabel('Center of Oscillation')
xlabel('Number strides OG')

cd('C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\Group2')
load('LN0342.mat')
cd('C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\SMatrix\OGSMatrix\Line')
load('Group2OGConcMarixV3.mat')
figure
plot(SMatrix.Group2.LN0342(:,27),'k')
hold on 
plot(DATAOG(:,34),'--r')
legend('DM_PS','GTO_PS')
title('Group2 LN0342')
ylabel('Center of Oscillation')
xlabel('Number strides OG')

% cd('C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\Group1')
cd('C:\Users\maris\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\Group1')
load('LN0331.mat')
cd('C:\Users\maris\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\SMatrix\OGSMatrix\Line')
% cd('C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\SMatrix\OGSMatrix\Line')
load('Group1OGConcMarixV3.mat')
figure
plot(SMatrix.Group1.LN0331(:,27),'k')
hold on 
DATAOG(DATAOG(:,2)==0,:)=[];
plot(DATAOG(:,34),'--r')
legend('DM_PS','GTO_PS')
title('Group1 LN0331')
ylabel('Center of Oscillation')
xlabel('Number strides OG')


cd('C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\Group1')
load('LN0351.mat')
cd('C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\SMatrix\OGSMatrix\Line')
load('Group1OGConcMarixV3.mat')
figure
plot(SMatrix.Group1.LN0351(:,27),'k')
hold on 
DATAOG(DATAOG(:,2)==0,:)=[];
plot(DATAOG(:,34),'--r')
legend('DM_PS','GTO_PS')
title('Group1 LN0351')
ylabel('Center of Oscillation')
xlabel('Number strides OG')


cd('C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\Group1')
load('LN0319.mat')
cd('C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\SMatrix\OGSMatrix\Line')
load('Group1OGConcMarixV3.mat')
figure
plot(SMatrix.Group1.LN0319(:,27),'k')
hold on 
DATAOG(DATAOG(:,2)==0,:)=[];
plot(DATAOG(:,34),'--r')
legend('DM_PS','GTO_PS')
title('Group1 LN0319')
ylabel('Center of Oscillation')
xlabel('Number strides OG')

%Group3 
cd('C:\Users\maris\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\Group3')
load('LN0336.mat')
cd('C:\Users\maris\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\SMatrix\OGSMatrix\Line')
load('Group3OGConcMarixV3.mat')
figure
plot(SMatrix.Group3.LN0336(:,27),'k')
hold on 
DATAOG(DATAOG(:,2)==0,:)=[];
plot(DATAOG(:,34),'--r')
legend('DM_PS','GTO_PS')
title('Group3 LN0336')
ylabel('Center of Oscillation')
xlabel('Number strides OG')


cd('C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\Group5')
load('LN0361.mat')
cd('C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\SMatrix\OGSMatrix\Line')
load('Group5OGConcMarixV3.mat')
figure
plot(SMatrix.Group5.LN0361(:,27),'k')
hold on 
plot(DATAOG(:,34),'--r')
legend('DM_PS','GTO_PS')
title('Group5 LN0361')
ylabel('Center of Oscillation')
xlabel('Number strides OG')



%%
%%ALPHAS
cd('C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\Group2')
load('LN0364.mat')
cd('C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\SMatrix\OGSMatrix\Line')
load('Group2OGConcMarixV3.mat')
figure
plot(SMatrix.Group2.LN0364(:,15),'k')
hold on 
plot(DATAOG(:,25),'--r')
legend('DM_PS','GTO_PS')
title('Group2 LN0364')
ylabel('Alpha Slow')
xlabel('Number strides OG')


cd('C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\Group2')
load('LN0364.mat')
cd('C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\SMatrix\OGSMatrix\Line')
load('Group2OGConcMarixV3.mat')
figure
hold on
plot(SMatrix.Group2.LN0364(:,21),'k')
plot(SMatrix.Group2.LN0364(:,23),'*b')
 
plot(abs(DATAOG(:,25)),'--r')
plot(-abs(DATAOG(:,47)),'--m')

% legend('DM_PS','GTO_PS')1
title('Group2 LN0341')
ylabel('Alpha Slow')
xlabel('Number strides OG')

%%
%Step length asymmetry 
cd('C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\Group2')
load('LN0364.mat')
cd('C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\SMatrix\OGSMatrix\Line')
load('Group2OGConcMarixV3.mat')
figure
plot(SMatrix.Group2.LN0364(:,15),'k')
hold on 
plot(DATAOG(:,25),'--r')
legend('DM_PS','GTO_PS')
title('Group2 LN0364')
ylabel('Alpha Slow')
