%Script to get subjects hip position on time
function [stepLengthAsym2,stepLengthDiffr,stepLengthSlowr,stepLengthFastr]=HipPositionGTO(OverGroundFlag,subjects)
% Coordinate system in the main lab:
% x axis = vertical axis (from botton to top is ascendent)
% y axis = axis coming out of page  ( from in to out the page is ascendent)
% z axis = horizontal axis (from left to right is ascendent)
%
% by GTO October 10th 2011
global TrialTM TrialOG bOG bTM ConditionListTM ConditionListOG EventsOG EventsTM
global Trial b ConditionList Events
% global refx refz Lead Trail firststep HipTrail HipLead

for subj=subjects
    %load data
    stringname=num2str(subj);
    if length(stringname)<3
        if length(stringname)<2
            name=['LN000',stringname];
        else
            name=['LN00',stringname];
        end
    else
        name=['LN0',stringname];
    end
    
    eval(['load ',name]) %loading matrix
    
    % name
    
    if OverGroundFlag
        Trial=TrialOG;
        b=bOG;
        ConditionList=ConditionListOG;
        Events=EventsOG;
    else
        Trial=TrialTM;
        b=bTM;
        ConditionList=ConditionListTM;
        Events=EventsTM;
    end
    
    start=1;
%     StepSym=[];
%     allSteps=[];
%     stepAsymmetry=[];
    stepLengthAsym2=[];
    stepLengthDiffr=[];
    stepLengthSlowr=[];
    stepLengthFastr=[];
    for i=4
        
        if ConditionList(i,2)==0
            goodTrial=0;
        else
            goodTrial=1;
        end
        if goodTrial
            
            %Extract ankle position
            RX=Trial(i).RAnklePos.X;  %z is left to right, X is anterior posterior
            LX=Trial(i).LAnklePos.X;
            RZ=Trial(i).RAnklePos.Z;
            LZ=Trial(i).LAnklePos.Z;% Y coordinates are height
            
            %Hip position
            HipRX=Trial(i).RHipPos.X;
            HipRZ=Trial(i).RHipPos.Z;
            HipLX=Trial(i).LHipPos.X;
            HipLZ=Trial(i).LHipPos.Z;
            
            Time=Trial(i).KinTime.Abs;
            
            HipXavg=(HipRX+HipLX)./2;
            HipZavg=(HipRZ+HipLZ)./2;
            
            %Extract heel strikes
            RFootEvents=[];
            LFootEvents=[];
            RFootEvents=Events(find(Events(:,1)==i & Events(:,2)<100),3);
            LFootEvents=Events(find(Events(:,1)==i & Events(:,2)>100 & Events(:,2)<200),3);
            totEvents=min([length(RFootEvents);length(LFootEvents)]);
            
            % Classify events in toe offs and heel strikes
            indexEven=1:2:totEvents;
            indexOdd=2:2:totEvents;
            
            if RFootEvents(1)>LFootEvents(1) % 1st step with left heel strike
                % For over ground data the first step is with the left leg leading and the
                % last step is with the right leg leading  
                LHSall=LFootEvents(indexEven);
                RHSall=RFootEvents(indexOdd);
            else % 1st step with right heel strike
                LHSall=LFootEvents(indexOdd);
                RHSall=RFootEvents(indexEven);
                
            end
            
                LHS=LHSall(1:end-1);
                LHS2=LHSall(2:end);
                RHS=RHSall(1:end-1);
                RHS2=RHSall(2:end);
                
                if length(LHS)<=length(RHS)
                    loop=length(LHS);
                else
                    loop=length(RHS);
                end
                
                for e=1:loop
                    
%                     close all
                    
                    LHS1x=LX(LHS(e));
                    LHS1z=LZ(LHS(e));
                    HipLHS1x=HipXavg(LHS(e));
                    HipLHS1z=HipZavg(LHS(e));
                    RHS1x=RX(RHS(e));
                    RHS1z=RZ(RHS(e));
                    LHS2x=LX(LHS2(e));
                    LHS2z=LZ(LHS2(e));
                    HipLHS2x=HipXavg(LHS2(e));
                    HipLHS2z=HipZavg(LHS2(e));
                    
                    HipX=HipXavg(LHS(e):RHS2(e));
                    HipZ=HipZavg(LHS(e):RHS2(e));
                    LAnklePositionX=LX(LHS(e):RHS2(e));
                    LAnklePositionZ=LZ(LHS(e):RHS2(e));
                    RAnklePositionX=RX(LHS(e):RHS2(e));
                    RAnklePositionZ=RZ(LHS(e):RHS2(e));
                    
%                     LANKX0=
                                        
                    HipX0=HipLHS2x-HipLHS1x;
                    HipZ0=HipLHS2z-HipLHS1z;
                    
                    HipVector2=[HipLHS1z HipLHS1x;HipLHS2z HipLHS2x];
                    HipVector=[HipZ0 HipX0];
                    
                    reference=[0 HipX0];
%                     reference=[]
                    Theta=acos((dot(reference,HipVector))/(norm(HipVector)*norm(reference)));
                    
                    deg=Theta*(180/pi);
                    
                
                     if (reference(1,1)>HipVector(1,1))&&(HipVector(1,2)<0) || (reference(1,1)<HipVector(1,1))&&(HipVector(1,2)>0) 
                         Theta=Theta;
                     else
                         Theta=-Theta;
                     end                  
                    R=[cos(Theta) -sin(Theta);sin(Theta) cos(Theta)];
                    
                    
                    LHS1vec=[0 LHS1z;0 LHS1x];
                    RHS1vec=[0 RHS1z;0 RHS1x];
                    LHS2vec=[0 LHS2z;0 LHS2x];
                    LAnkleTra=[LAnklePositionZ'; LAnklePositionX'];
                    RAnkleTra=[RAnklePositionZ'; RAnklePositionX'];
                    HipTra=[HipZ';HipX'];
                    %
                    %                    rotHipvect=R*HipVector;
                    rotHipvect=R*[HipLHS1z HipLHS2z;HipLHS1x HipLHS2x];
                    rotLHS1=R*LHS1vec;
                    rotRHS1=R*RHS1vec;
                    rotLHS2=R*LHS2vec;
                    rotLAnkle=R*LAnkleTra;
                    rotRAnkle=R*RAnkleTra;
                    rotHipTra=R*HipTra;
                    
                    
                    % Cheking
                    figure
                    hold on
                    plot([0 HipVector(1)],[0 HipVector(2)],'--','Displayname','HipVector') %HipVector
                    plot([0 0],[0 HipX0],'m','Displayname','reference') %reference
                    
                    plot(HipVector2(:,1),HipVector2(:,2),'g','Displayname','HipVectorNormal') %HipVector no refrence substracted
                    plot(LHS1z,LHS1x,'<k','Displayname','LHS1')
                    plot(RHS1z,RHS1x,'<r','Displayname','RHS1')
                    plot(LHS2z,LHS2x,'<b','Displayname','LHS2')
                    plot(LAnklePositionZ', LAnklePositionX','--b','Displayname','Left angle trayectory')
                    plot(RAnklePositionZ', RAnklePositionX','--b','Displayname','Right angle trayectory')
                   
                    
                    plot(rotHipvect(1,:),rotHipvect(2,:),'b','Displayname','RotatedHipVector')
                    plot(rotHipTra(1,:),rotHipTra(2,:),'--k','Displayname','Hip Rotated Trayectory')
                    
                    
                    plot(rotLHS1(1,2),rotLHS1(2,2),'ok','Displayname','rotLHS1')
                    plot(rotRHS1(1,2),rotRHS1(2,2),'or','Displayname','rotRHS1')
                    plot(rotLHS2(1,2),rotLHS2(2,2),'ob','Displayname','rotLHS2')
                    plot(rotRAnkle(1,end),rotRAnkle(2,end),'or','Displayname','rotRHS2')
                    
                    plot(rotHipTra(1,end),rotHipTra(2,end),'*r','Displayname','Hip rotRHS2')
                    
                    plot(rotHipTra(1,RHS(e)-LHS(e)),rotHipTra(2,RHS(e)-LHS(e)),'*r','Displayname','Hip rotRHS1')
                    plot(rotHipvect(1,1),rotHipvect(2,1),'*b','Displayname','HipRotLHS1') %rotHip position LHS1
                    plot(rotHipvect(1,2),rotHipvect(2,2),'*m','Displayname','HipRotLHS2') %rotHip position LHS2
                    
                    plot(rotLAnkle(1,:),rotLAnkle(2,:),'Displayname','LAnkleRot')
                    plot(rotRAnkle(1,:),rotRAnkle(2,:),'Displayname','RAnkleRot')  
                    
                    
                    legend show
                    axis equal
                    %%Everything have been rotated, we don't need to use the Z-axis
                    %for further calculations
                    
                    %In order to make a code similar to the labtools we are
                    %going to assumed that L is the slow leg and R is the
                    %fast belt
%                     
                    SHS=1;
                    FHS=RHS(e)-LHS(e);
                    FHS2=RHS2(e)-LHS(e);
                    SHS2=LHS2(e)-LHS(e);
%                     
                    

%                     STO=LTO(e)-LHS(e);
%                     STO2=LTO(e+1)-LHS(e);
%                     FTO=RTO(e)-LHS(e);
%                     FTO2=RTO(e+1)-LHS(e);
                    
                    %Asumming R as the slow leg
%                     SHS=RHS(e)-LHS(e);
%                     SHS2=RHS2(e)-LHS(e);
%                     FHS=1;
%                     FHS2=LHS2(e)-LHS(e);
    
                    rotLAnkle=[rotLAnkle(2,:)-rotHipTra(2,:)]';
                    rotRAnkle=[rotRAnkle(2,:)-rotHipTra(2,:)]';
                    
                    figure()
                    hold on
                    plot(rotLAnkle)
                    plot(rotRAnkle)
                    plot(SHS2,rotLAnkle(SHS2),'*k')
                    plot(SHS,rotLAnkle(SHS),'*k')
                    plot(FHS,rotRAnkle(FHS),'*r')
                    plot(FHS2,rotRAnkle(FHS2),'*r')
%                     plot(STO,rotLAnkle(STO),'<k')
%                     plot(FTO,rotRAnkle(FTO),'<r')
%                     plot(FTO2,rotRAnkle(FTO2),'<r')
                    legend('Slow leg','Fast leg')
                    
                   
                    stepLengthSlow(e,1)=abs(rotLAnkle(SHS2)-rotRAnkle(SHS2));
                    stepLengthFast(e,1)=abs(rotRAnkle(FHS)-rotLAnkle(FHS));
                    
                    stepLengthDiff(e,1)=stepLengthFast(e,1)-stepLengthSlow(e,1);
                    stepLengthAsym(e,1)=stepLengthDiff(e,1)./(stepLengthFast(e,1)+stepLengthSlow(e,1));
                    
                    spatialFast(e)=abs(rotRAnkle(FHS)-rotLAnkle(SHS));
                    spatialSlow(e)=abs(rotLAnkle(SHS2)-rotRAnkle(FHS));
                    
                    dispSlow(e)=abs(rotLAnkle(FHS)-rotLAnkle(SHS)); 
                    dispFast(e)=abs(rotRAnkle(SHS2)-rotRAnkle(FHS));
                    
                    ts(e)=Time(RHS(e))-Time(LHS(e));
                    tf(e)=Time(LHS2(e))-Time(RHS(e));
                    
                    difft(e)=ts(e)-tf(e); 
                    
                    velocitySlow(e)=dispSlow(e)/ts(e);
                    velocityFast(e)=dispFast(e)/tf(e);
                    avgVel(e)=mean([velocitySlow(e) velocityFast(e)],2);
                    avgStepTime(e)=mean([ts(e) tf(e)],2); %This is half strideTimeSlow!
                    
                    spatialContribution(e)=spatialFast(e)-spatialSlow(e);
                    stepTimeContribution(e)=avgVel(e).*difft(e);
                    velocityContribution(e)=avgStepTime(e).*(velocitySlow(e)-velocityFast(e));
                    netContribution(e)=spatialContribution(e)+stepTimeContribution(e)+velocityContribution(e);
                    
                    Dist(e)=stepLengthFast(e)+stepLengthSlow(e);
                    spatialContributionNorm2(e)=spatialContribution(e)/Dist(e);
                    stepTimeContributionNorm2(e)=stepTimeContribution(e)/Dist(e);
                    velocityContributionNorm2(e)=velocityContribution(e)/Dist(e);
                    netContributionNorm2(e)=netContribution(e)/Dist(e);
                    
                     cond=ConditionList(find(ConditionList(:,1)==i),2);
                end
                
            stepLengthAsym2=[stepLengthAsym2; i*ones(length(stepLengthAsym),1) cond*ones(length(stepLengthAsym),1) stepLengthAsym];
            stepLengthDiffr=[stepLengthDiffr; i*ones(length(stepLengthDiff),1) cond*ones(length(stepLengthDiff),1) stepLengthDiff];
            stepLengthSlowr=[stepLengthSlowr; i*ones(length(stepLengthSlow),1) cond*ones(length(stepLengthSlow),1) stepLengthSlow];
            stepLengthFastr=[stepLengthFastr; i*ones(length(stepLengthSlow),1) cond*ones(length(stepLengthSlow),1) stepLengthFast];
        end
        
    end
end



end






