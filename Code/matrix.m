%concataneted data 

% cd('C:\Users\dum5\Desktop\KidsStudy\Data\Kids_paper\Group1')
% load('LN0319.mat')

% cd('C:\Users\dum5\Desktop\KidsStudy\Data\Kids_paper\Group6')
% load('LN0412.mat')



LHipMarkerZall=[];
LHipMarkerXall=[];
RHipMarkerZall=[];
RHipMarkerXall=[];
HipAvgAllZ=[];
HipAvgAllX=[];

LHipMarkerZTrials=[];
LHipMarkerXTrials=[];
RHipMarkerZTrials=[];
RHipMarkerXTrials=[];

Trial=TrialTM;

% figure() 
for i=1:1
LHipMarkerZ=Trial(i).LHipPos.Z;
LHipMarkerX=Trial(i).LHipPos.X;
RHipMarkerZ=Trial(i).RHipPos.Z;
RHipMarkerX=Trial(i).RHipPos.X;

% BADrhip=[find(diff(RHipMarkerZ)<-2); find(diff(RHipMarkerZ)>2)];
% BADlhip=[find(diff(LHipMarkerZ)<-2); find(diff(LHipMarkerZ)>2)];
% Bad=unique([BADrhip; BADlhip]);
% 
% 
% 
% LHipMarkerZ(Bad)=[];
% LHipMarkerX(Bad)=[];
% RHipMarkerZ(Bad)=[];
% RHipMarkerX(Bad)=[];
% figure; subplot(1, 2, 1); plot(diff(LHipMarkerZ));subplot(1, 2, 2); plot(diff(RHipMarkerZ))
LHipMarkerZall=[LHipMarkerZall; LHipMarkerZ];
LHipMarkerXall=[LHipMarkerXall; LHipMarkerX];
RHipMarkerXall=[RHipMarkerXall; RHipMarkerX];
RHipMarkerZall=[RHipMarkerZall; RHipMarkerZ];

BADrhip=[find(diff(RHipMarkerZall)<-2); find(diff(RHipMarkerZall)>2)];
BADlhip=[find(diff(LHipMarkerZall)<-2); find(diff(LHipMarkerZall)>2)];
Bad=unique([BADrhip; BADlhip]);



LHipMarkerZall(Bad)=[];
LHipMarkerXall(Bad)=[];
RHipMarkerZall(Bad)=[];
RHipMarkerXall(Bad)=[];
% figure; subplot(1, 2, 1); plot(diff(LHipMarkerZ));subplot(1, 2, 2); plot(diff(RHipMarkerZ))
LHipMarkerZall(end)=[];
LHipMarkerXall(end)=[];
RHipMarkerZall(end)=[];
RHipMarkerXall(end)=[];



LHipMarkerZ=[];
LHipMarkerX=[];
RHipMarkerZ=[];
RHipMarkerX=[];
Bad=[];
% 
LHipMarkerZTrials=[LHipMarkerZTrials;i*ones(length(LHipMarkerZall),1) LHipMarkerZall];
LHipMarkerXTrials=[LHipMarkerXTrials;i*ones(length(LHipMarkerXall),1) LHipMarkerXall];
RHipMarkerZTrials=[RHipMarkerZTrials;i*ones(length(RHipMarkerZall),1) RHipMarkerZall];
RHipMarkerXTrials=[RHipMarkerXTrials;i*ones(length(RHipMarkerXall),1) RHipMarkerXall];
HipAvgAllZ=[HipAvgAllZ;i*ones(length(LHipMarkerZall),1) (LHipMarkerZall+RHipMarkerZall)./2];
HipAvgAllX=[HipAvgAllX;i*ones(length(LHipMarkerZall),1) (LHipMarkerXall+RHipMarkerXall)./2];

end

figure()
plot(LHipMarkerZTrials(:,2),LHipMarkerXTrials(:,2),'r','DisplayName','Left Hip Marker')
hold on
plot(RHipMarkerZTrials(:,2),RHipMarkerXTrials(:,2),'k','DisplayName','Right Hip Marker')
plot(HipAvgAllZ(:,2),HipAvgAllX(:,2),'b','DisplayName','Avg Hip Markers')
a=cd;
group=a(end-5:end);
title([group])
% title([group ' Age 18<' ])
legend show
% axis([-200 500 -800 300])
% axis([-500 500 -1000 200])

% figure; 
% plot(LHipMarkerZTrials,LHipMarkerXTrials)
% hold on
% plot(RHipMarkerZTrials,RHipMarkerXTrials)



