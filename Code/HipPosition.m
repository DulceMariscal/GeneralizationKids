%Script to get subjects hip position on time
function RotatedResults=HipPosition(OverGroundFlag,subjects,g)

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
    
    
    stepLengthAsym2=[];
    stepLengthDiffr=[];
    stepLengthSlowr=[];
    stepLengthFastr=[];
    spatialContribution2=[];
    stepTimeContribution2=[];
    velocityContribution2=[];
    netContribution2=[];
    spatialContributionNorm=[];
    stepTimeContributionNorm=[];
    velocityContributionNorm=[];
    netContributionNorm=[];
    alphaSlow2=[];
    alphaTemp2=[];
    alphaFast2=[];
    Xslow2=[];
    Xfast2=[];
    alphaAngSlow2=[];
    alphaAngTemp2=[];
    alphaAngFast2=[];
    betaAngSlow2=[];
    betaAngFast2=[];
    centerSlow2=[];
    centerFast2=[];
    angleOfOscillationAsym2=[];
    phaseShift2=[];
    phaseShiftGTO2=[];
    
    %     equivalentSpeed2=[];
    extendedEventTimes=[];
    
     % Find FootEvents
    s = 'L';
    f = 'R';
    Lleg=1;
    Rleg=0;
    FootEvents = getallFootEvents(1,Rleg,Lleg); % for all files processed after Sept12 2009
    
    % Remove bad strides
    temp=diff(FootEvents,1,2);
    thresh=100;
   FootEvents(find( (abs(temp(:,4))>thresh) | (abs(temp(:,5))>thresh) | (abs(temp(:,6))>thresh) | (abs(temp(:,7))>thresh) | (abs(temp(:,8))>thresh) ),:)=[];
%     z=FootEvents(find( (abs(temp(:,4))>thresh) | (abs(temp(:,5))>thresh) | (abs(temp(:,6))>thresh) | (abs(temp(:,7))>thresh) | (abs(temp(:,8))>thresh) ),:)=[];

    temp=[];
%     temp=isnan(FootEvents);
%     temp=isnan(z);
    [rr,cc]=find(temp);
    rows=unique(rr);
    FootEvents(rows,:)=[];
    
    for i=1:b
        
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
            
            %Angle Position
            RLimbAng= Trial(i).Angle.RLimb;
            LLimbAng= Trial(i).Angle.LLimb;
            
            Ankle=labTimeSeries([RX LX],0,0.01,{'RX','LX'});
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
%             indexEven=2:2:totEvents;
%             indexOdd=1:2:totEvents;
%             
%             if RFootEvents(1)>LFootEvents(1) % 1st step with left heel strike
%                 % For over ground data the first step is with the left leg leading and the
%                 % last step is with the right leg leading
%                 LHSall=LFootEvents(indexOdd);
%                 LTOall=LFootEvents(indexEven);
%                 RHSall=RFootEvents(indexEven);
%                 RTOall=RFootEvents(indexOdd);
%                 %                 RHSall=RHSall(2:end);
%             else % 1st step with right heel strike
%                 LHSall=LFootEvents(indexEven);
%                 LTOall=LFootEvents(indexOdd);
%                 RHSall=RFootEvents(indexOdd);
%                 RTOall=RFootEvents(indexEven);
%                 RHSall=RHSall(2:end);
%                 
%                 
%             end
%             
%             LHS=LHSall(1:end-1);
%             LTO=LTOall(1:end);
%             LHS2=LHSall(2:end);
%             RHS=RHSall(1:end);
%             RTO=RTOall(1:end-1);
%             RTO2=RTOall(2:end);

           trial=find(FootEvents(:,1)==i);
%             shs = FootEvents(trial,4);
%             fto = FootEvents(trial,5);
%             fhs = FootEvents(trial,6);
%             sto = FootEvents(trial,7);
%             shs2 = FootEvents(trial,8);
%             fto2 = FootEvents(trial,9);
            LHS = FootEvents(trial,4);
            RTO = FootEvents(trial,5);
            RHS = FootEvents(trial,6);
            LTO = FootEvents(trial,7);
            LHS2 = FootEvents(trial,8);
            RTO2 = FootEvents(trial,9);
%             
            
            tSHS=Ankle.Time(LHS);
            tFTO=Ankle.Time(RTO);
            tFHS=Ankle.Time(RHS);
            tSTO=Ankle.Time(LTO);
            tSHS2=Ankle.Time(LHS2);
            tFTO2=Ankle.Time(RTO2);
            
            
            
            if length(LHS)<=length(RHS)
                loop=length(LHS);
            else
                loop=length(RHS);
            end
            
            stepLengthSlow=[];
            stepLengthFast=[];
            
            stepLengthDiff=[];
            stepLengthAsym=[];
            
            alphaSlow=[];
            alphaTemp=[];
            alphaFast=[];
            Xslow=[];
            Xfast=[];
            
            spatialFast=[];
            spatialSlow=[];
            
            dispSlow=[];
            dispFast=[];
            
            ts=[];
            tf=[];
            
            difft=[];
            
            velocitySlow=[];
            velocityFast=[];
            avgVel=[];
            avgStepTime=[]; %This is half strideTimeSlow!
            
            spatialContribution=[];
            stepTimeContribution=[];
            velocityContribution=[];
            netContribution=[];
            
            Dist=[];
            spatialContributionNorm2=[];
            stepTimeContributionNorm2=[];
            velocityContributionNorm2=[];
            netContributionNorm2=[];
            equivalentSpeed=[];
            cond=[];
            alphaAngSlow=[];
            alphaAngTemp=[];
            alphaAngFast=[];
            betaAngSlow=[];
            betaAngFast=[];
            centerSlow=[];
            centerFast=[];
            angleOfOscillationAsym=[];
            phaseShift=[];
            phaseshiftGTO=[];
            
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
                
                HipX=HipXavg(LHS(e):LHS2(e));
                HipZ=HipZavg(LHS(e):LHS2(e));
                LAnklePositionX=LX(LHS(e):LHS2(e));
                LAnklePositionZ=LZ(LHS(e):LHS2(e));
                RAnklePositionX=RX(LHS(e):LHS2(e));
                RAnklePositionZ=RZ(LHS(e):LHS2(e));
                
                HipX0=HipLHS2x-HipLHS1x;
                HipZ0=HipLHS2z-HipLHS1z;
                %                     HipX0=HipLHS1x;
                %                     HipZ0=HipLHS1z;
                
                HipVector2=[HipLHS1z-HipLHS1z HipLHS1x-HipLHS1x;HipLHS2z-HipLHS1z HipLHS2x-HipLHS1x];
                HipVector=[HipZ0 HipX0];
                
                reference=[0 HipX0];
                
                if OverGroundFlag
                    Theta=acos((dot(reference,HipVector))/(norm(HipVector)*norm(reference)));
                    
                    
                    deg=Theta*(180/pi);
                    
                    
                    if (reference(1,1)>HipVector(1,1))&&(HipVector(1,2)<0) || (reference(1,1)<HipVector(1,1))&&(HipVector(1,2)>0)
                        Theta=Theta;
                    else
                        Theta=-Theta;
                    end
                    
                    
                    
                    
                    R=[cos(Theta) -sin(Theta);sin(Theta) cos(Theta)];
                    
                    
                    %                 LHS1vec=[0 LHS1z-HipLHS1z;0 LHS1x-HipLHS1x];
                    %                 RHS1vec=[0 RHS1z-HipLHS1z;0 RHS1x-HipLHS1x];
                    %                 LHS2vec=[0 LHS2z-HipLHS1z;0 LHS2x-HipLHS1x];
                    LAnkleTra=[LAnklePositionZ'-HipLHS1z; LAnklePositionX'-HipLHS1x];
                    RAnkleTra=[RAnklePositionZ'-HipLHS1z; RAnklePositionX'-HipLHS1x];
                    HipTra=[HipZ'-HipLHS1z;HipX'-HipLHS1x];
                    %
                    %                    rotHipvect=R*HipVector;
                    rotHipvect=R*[HipLHS1z-HipLHS1z HipLHS2z-HipLHS1z;HipLHS1x-HipLHS1x HipLHS2x-HipLHS1x];
                    %                 rotLHS1=R*LHS1vec;
                    %                 rotRHS1=R*RHS1vec;
                    %                 rotLHS2=R*LHS2vec;
                    rotLAnkle=R*LAnkleTra;
                    rotRAnkle=R*RAnkleTra;
                    rotHipTra=R*HipTra;
                    
                else
                    LAnkleTra=[LAnklePositionZ'-HipLHS1z; LAnklePositionX'-HipLHS1x];
                    RAnkleTra=[RAnklePositionZ'-HipLHS1z; RAnklePositionX'-HipLHS1x];
                    HipTra=[HipZ'-HipLHS1z;HipX'-HipLHS1x];
                    rotLAnkle=LAnkleTra;
                    rotRAnkle=RAnkleTra;
                    rotHipTra=HipTra;
                    
                end
                
                
                if HipVector(1,2)<0 || OverGroundFlag==0
                    
                    rotLAnkle=-rotLAnkle;
                    rotRAnkle=-rotRAnkle;
                    rotHipTra=-rotHipTra;
                    
                end
                
                SHS=1;
                FHS=RHS(e)-LHS(e)+1;
                SHS2=LHS2(e)-LHS(e)+1;
                STO=LTO(e)-LHS(e)+1;
                FTO=RTO(e)-LHS(e)+1;
                FTO2=RTO2(e)-LHS(e)+1;
                
                % Cheking
                %                 figure
                %                 hold on
                %                 plot([0 HipVector(1)],[0 HipVector(2)],'--','Displayname','HipVector') %HipVector
                %                 plot([0 0],[0 HipX0],'m','Displayname','reference') %reference
                %
                %                 plot(HipVector2(:,1),HipVector2(:,2),'g','Displayname','HipVectorNormal') %HipVector no refrence substracted
                %                 plot(LHS1z-HipLHS1z,LHS1x-HipLHS1x,'<k','Displayname','LHS1')
                %                 plot(RHS1z-HipLHS1z,RHS1x-HipLHS1x,'<r','Displayname','RHS1')
                %                 plot(LHS2z-HipLHS1z,LHS2x-HipLHS1x,'<b','Displayname','LHS2')
                %                 plot(LAnklePositionZ'-HipLHS1z, LAnklePositionX'-HipLHS1x,'--b','Displayname','Left angle trayectory')
                %                 plot(RAnklePositionZ'-HipLHS1z, RAnklePositionX'-HipLHS1x,'--b','Displayname','Right angle trayectory')
                %                 plot(HipZ'-HipLHS1z,HipX'-HipLHS1x,'--g','Displayname','Avg Hip TRayectory')
                %
                %                 %
                %                 plot(rotHipvect(1,:),rotHipvect(2,:),'b','Displayname','RotatedHipVector')
                %                 plot(rotHipTra(1,:),rotHipTra(2,:),'k','Displayname','Hip Rotated Trayectory')
                %
                %
                %                 %                     plot(rotLHS1(1,2),rotLHS1(2,2),'ok','Displayname','rotLHS1')
                %                 %                     plot(rotRHS1(1,2),rotRHS1(2,2),'or','Displayname','rotRHS1')
                %                 %                     plot(rotLHS2(1,2),rotLHS2(2,2),'ob','Displayname','rotLHS2')
                %
                %                 plot(rotLAnkle(1,SHS),rotLAnkle(2,SHS),'ok','Displayname','rotLHS1')
                %                 plot(rotRAnkle(1,FHS),rotRAnkle(2,FHS),'or','Displayname','rotRHS1')
                %                 plot(rotLAnkle(1,SHS2),rotLAnkle(2,SHS2),'ob','Displayname','rotLHS2')
                %
                %                 %                     plot(rotRAnkle(1,end),rotRAnkle(2,end),'or','Displayname','rotRHS2')
                %
                %                 %                     plot(rotHipTra(1,end),rotHipTra(2,end),'*r','Displayname','Hip rotRHS2')
                %
                %                 plot(rotHipTra(1,FHS),rotHipTra(2,FHS),'*r','Displayname','Hip rotRHS1')
                %                 plot(rotHipTra(1,SHS),rotHipTra(2,SHS),'*b','Displayname','HipRotLHS1') %rotHip position LHS1
                %                 plot(rotHipTra(1,SHS2),rotHipTra(2,SHS2),'*m','Displayname','HipRotLHS2') %rotHip position LHS2
                %
                % %                 plot(rotHipvect(1,SHS),rotHipvect(2,SHS),'*b','Displayname','HipRotLHS1') %rotHip position LHS1
                % %                 plot(rotHipvect(1,SHS2),rotHipvect(2,SHS2),'*m','Displayname','HipRotLHS2') %rotHip position LHS2
                %
                %                 plot(rotLAnkle(1,:),rotLAnkle(2,:),'k','Displayname','LAnkleRot')
                %                 plot(rotRAnkle(1,:),rotRAnkle(2,:),'k','Displayname','RAnkleRot')
                %
                %                 title([name ' Trial ' num2str(i) ' Step '  num2str(e)])
                %                 legend show
                %                                     axis equal
                
                %Everything have been rotated, we don't need to use the Z-axis
                %                     for further calculations
                
                %                     figure()
                %                     plot(rotHipTra(2,:))
                %                     hold on;plot(rotRAnkle(2,:))
                %                     hold on;plot(rotLAnkle(2,:))
                %                     legend('Avg Hip Position','Right Ankle','Left Ankle')
                %                     title('Hip position on time')
                
                %In order to make a code similar to the labtools we are
                %going to assumed that L is the slow leg and R is the
                %fast belt
                
                                SHS=1;
                                FHS=RHS(e)-LHS(e)+1;
                                %                     FHS2=RHS2(e)-LHS(e);
                                SHS2=LHS2(e)-LHS(e)+1;
                
                rotLAnkle=[rotLAnkle(2,:)-rotHipTra(2,:)]';
                rotRAnkle=[rotRAnkle(2,:)-rotHipTra(2,:)]';
                
                extendedEventTimes=[tSHS(e) tFTO(e) tFHS(e) tSTO(e) tSHS2(e) tFTO2(e)];
                
                diffHS(e)=((tFHS(e)-tSHS(e)))-((tSHS2(e)-tFHS(e)));
                strideDuration=diff(extendedEventTimes(:,[1,5]),1,2);
                
                bad=any(isnan(extendedEventTimes),2) | any(diff(extendedEventTimes,1,2)<0,2) | (strideDuration >1.5*nanmedian(strideDuration)) | (strideDuration<.4)...
                    | (strideDuration>2.5) | diffHS(e)< -0.4;
                
                
%                 if FHS>length(rotLAnkle) || SHS>length(rotLAnkle) || bad==1 || (rotRAnkle(FHS)-rotRAnkle(SHS2)<0) || rotRAnkle(SHS)>rotRAnkle(FHS)||...
%                         rotLAnkle(SHS2)>(1.5*(mean([rotLAnkle(SHS) rotRAnkle(FHS)],2))) || rotLAnkle(SHS2)<(.5*(mean([rotLAnkle(SHS) rotRAnkle(FHS)],2)))
%                     
%                     
%                     display(['warnning bad stride subject' name ' Trial ' num2str(i) ' Step '  num2str(e)])
%                     
%                     %                     figure()
%                     %                     hold on
%                     %                     plot(rotLAnkle)
%                     %                     plot(rotRAnkle)
%                     % %                     plot(SHS,rotLAnkle(SHS),'*k')
%                     % %                     plot(FHS,rotRAnkle(FHS),'*r')
%                     % %                     plot(SHS2,rotLAnkle(SHS2),'*k')
%                     % %                     plot(FHS,rotLAnkle(FHS),'<g')
%                     % %                     plot(SHS2,rotRAnkle(SHS2),'<m')
%                     % %                     plot(SHS,rotRAnkle(SHS),'<m')
%                     %                     title([name ' Trial ' num2str(i) ' Step '  num2str(e) ' BAD STRIDE'])
%                     
%                     
%                     stepLengthAsym(e)=nan;
%                     stepLengthDiff(e)=nan;
%                     stepLengthSlow(e)=nan;
%                     stepLengthFast(e)=nan;
%                     spatialContribution(e)=nan;
%                     stepTimeContribution(e)=nan;
%                     velocityContribution(e)=nan;
%                     netContribution(e)=nan;
%                     spatialContributionNorm2(e)=nan;
%                     stepTimeContributionNorm2(e)=nan;
%                     velocityContributionNorm2(e)=nan;
%                     netContributionNorm2(e)=nan;
%                     alphaSlow(e)=nan;
%                     alphaTemp(e)=nan;
%                     alphaFast(e)=nan;
%                     Xslow(e)=nan;
%                     Xfast(e)=nan;
%                     equivalentSpeed(e)=nan;
%                     cond(e)=0;
%                     %angle data
%                     alphaAngSlow(e)=nan;
%                     alphaAngTemp(e)=nan;
%                     alphaAngFast(e)=nan;
%                     betaAngSlow(e)=nan;
%                     betaAngFast(e)=nan;
%                     centerSlow(e)=nan;
%                     centerFast(e)=nan;
%                     angleOfOscillationAsym(e)=nan;
%                     
%                     %phase shift (using angles)
%                     slowlimb(e)=nan;
%                     fastlimb(e)=nan;
%                     % Circular correlation
%                     phaseShift(e)=nan;
%                     
%                     %                     ConditionList(find(ConditionList(:,1)==i),2);
%                     
%                 else
                    %                     STO=LTO(e)-LHS(e);
                    %                     STO2=LTO(e+1)-LHS(e);
                    %                     FTO=RTO(e)-LHS(e);
                    %                     FTO2=RTO(e+1)-LHS(e);
                    
                    %Asumming R as the slow leg
%                                         SHS=RHS(e)-LHS(e);
%                                         SHS2=RHS2(e)-LHS(e);
%                                         FHS=1;
%                                         FHS2=LHS2(e)-LHS(e);
%                     
%                     
                    
                    
                    %                                         figure()
                    %                                         hold on
                    %                                         plot(rotLAnkle)
                    %                                         plot(rotRAnkle)
                    % %                                         plot(rotHipTra(2,:))
                    %                                         plot(SHS,rotLAnkle(SHS),'*k')
                    %                                         plot(FHS,rotRAnkle(FHS),'*r')
                    %                                         plot(SHS2,rotLAnkle(SHS2),'*k')
                    %                                         plot(FHS,rotLAnkle(FHS),'<g')
                    %                                         plot(SHS2,rotRAnkle(SHS2),'<m')
                    %                                         plot(SHS,rotRAnkle(SHS),'<m')
                    %                                         title([name ' Trial ' num2str(i) ' Step '  num2str(e)])
                    %
                    % %                                         plot(FHS2,rotRAnkle(FHS2),'*r')
                    % %                                         plot(STO,rotLAnkle(STO),'<k')
                    % %                                         plot(FTO,rotRAnkle(FTO),'<r')
                    % %                                         plot(FTO2,rotRAnkle(FTO2),'<r')
                    %                                         legend('Slow leg','Fast leg','SHS','FHS','SHS2','Slow leg at FHS','Fast leg at SHS2')
                    %                                         title([name ' Trial ' num2str(i) ' Step '  num2str(e)])
                    %                                         axis equal
                    %
                    
                    
                    
                    %alpha (positive portion of interlimb angle at HS)
                    alphaAngSlow(e)=LLimbAng(LHS2(e));
                    alphaAngTemp(e)=LLimbAng(LHS(e));
                    alphaAngFast(e)=RLimbAng(RHS(e));
                    %beta (negative portion of interlimb angle at TO)
                    betaAngSlow(e)=LLimbAng(LTO(e));
                    betaAngFast(e)=RLimbAng(RTO2(e));
                    
                    centerSlow(e)=(alphaAngTemp(e)+betaAngSlow(e))./2;
                    centerFast(e)=(alphaAngFast(e)+betaAngFast(e))./2;
                    angleOfOscillationAsym(e)=(centerFast(e)-centerSlow(e));
                    
                    %phase shift (using angles)
                    slowlimb=LLimbAng(LHS(e):LHS2(e));
                    fastlimb=RLimbAng(LHS(e):LHS2(e));
%                     slowlimb=slowlimb-mean(slowlimb);
%                     fastlimb=fastlimb-mean(fastlimb);
                    % Circular correlation
                    phaseShiftDM(e)=circCorr(slowlimb,fastlimb);
                    
                    slowlimb = slowlimb - mean(slowlimb);
                    fastlimb = fastlimb - mean(fastlimb);
                    % Circular correlation
                    s1=std(slowlimb);
                    s2=std(fastlimb);
                    
                    
                    n=length(slowlimb);
                    for t=1:n
                        c(t)=(slowlimb'*fastlimb)./((n-1)*s1*s2);
                        fastlimb=circshift(fastlimb,1);
                    end
                    
                    [cmax,lag]=max(c);
                    lag=lag/n;
                    
                    if lag>0.7
                        lag;
                    end
                    
                    if cmax<0.5
                        lag=NaN;
                    end
                    
                    try
                        phaseShift(e)=lag;
                    catch
                        phaseShift(e) = NaN;
                    end
                    
                    
                    stepLengthSlow(e)=abs(rotLAnkle(SHS2)-rotRAnkle(SHS2));
                    stepLengthFast(e)=abs(rotRAnkle(FHS)-rotLAnkle(FHS));
                    
                    stepLengthDiff(e)=stepLengthFast(e)-stepLengthSlow(e);
                    stepLengthAsym(e)=stepLengthDiff(e)./(stepLengthFast(e)+stepLengthSlow(e));
                    
                    alphaSlow(e)=rotLAnkle(SHS2);
                    alphaTemp(e)=rotLAnkle(SHS);
                    alphaFast(e)=rotRAnkle(FHS);
                    Xslow(e)=rotLAnkle(FHS);
                    Xfast(e)=rotRAnkle(SHS2);
                    
                    spatialFast(e)=rotRAnkle(FHS)-rotLAnkle(SHS);
                    spatialSlow(e)=rotLAnkle(SHS2)-rotRAnkle(FHS);
                    
                    dispSlow(e)=rotLAnkle(SHS)-rotLAnkle(FHS);
                    dispFast(e)=rotRAnkle(FHS)-rotRAnkle(SHS2);
                    
                    ts(e)=(tFHS(e)-tSHS(e));
                    tf(e)=(tSHS2(e)-tFHS(e));
                    
                    difft(e)=ts(e)-tf(e);
                    
                    velocitySlow(e)=dispSlow(e)/ts(e);
                    velocityFast(e)=dispFast(e)/tf(e);
                    avgVel(e)=mean([velocitySlow(e) velocityFast(e)],2);
                    avgStepTime(e)=mean([ts(e) tf(e)],2); %This is half strideTimeSlow!
                    
                    spatialContribution(e)=spatialFast(e)-spatialSlow(e);
                    stepTimeContribution(e)=avgVel(e)*difft(e);
                    velocityContribution(e)=avgStepTime(e)*(velocitySlow(e)-velocityFast(e));
                    netContribution(e)=spatialContribution(e)+stepTimeContribution(e)+velocityContribution(e);
                    
                    Dist(e)=stepLengthFast(e)+stepLengthSlow(e);
                    spatialContributionNorm2(e)=spatialContribution(e)/Dist(e);
                    stepTimeContributionNorm2(e)=stepTimeContribution(e)/Dist(e);
                    velocityContributionNorm2(e)=velocityContribution(e)/Dist(e);
                    netContributionNorm2(e)=netContribution(e)/Dist(e);
                    %                     equivalentSpeed(e)=(dispSlow(e)+dispFast(e))/(ts(e)+tf(e));
                    
                    cond(e)=ConditionList(find(ConditionList(:,1)==i),2);
%                 end
            end
            
            stepLengthAsym2=[stepLengthAsym2; i*ones(length(stepLengthAsym),1) cond' stepLengthAsym'];
            stepLengthDiffr=[stepLengthDiffr;  stepLengthDiff'];
            stepLengthSlowr=[stepLengthSlowr;  stepLengthSlow'];
            stepLengthFastr=[stepLengthFastr;  stepLengthFast'];
            spatialContribution2=[spatialContribution2; spatialContribution'];
            stepTimeContribution2=[stepTimeContribution2; stepTimeContribution'];
            velocityContribution2=[velocityContribution2; velocityContribution'];
            netContribution2=[netContribution2; netContribution'];
            spatialContributionNorm=[spatialContributionNorm; spatialContributionNorm2'];
            stepTimeContributionNorm=[stepTimeContributionNorm; stepTimeContributionNorm2'];
            velocityContributionNorm=[velocityContributionNorm; velocityContributionNorm2'];
            netContributionNorm=[netContributionNorm;netContributionNorm2'];
            alphaSlow2=[alphaSlow2; alphaSlow'];
            alphaTemp2=[ alphaTemp2; alphaTemp'];
            alphaFast2=[alphaFast2; alphaFast'];
            Xfast2=[Xfast2;Xfast'];
            Xslow2=[Xslow2;Xslow'];
            alphaAngSlow2=[alphaAngSlow2;alphaAngSlow'];
            alphaAngTemp2=[alphaAngTemp2;alphaAngTemp'];
            alphaAngFast2=[alphaAngFast2;alphaAngFast'];
            betaAngSlow2=[betaAngSlow2;betaAngSlow'];
            betaAngFast2=[betaAngFast2;betaAngFast'];
            centerSlow2=[centerSlow2;centerSlow'];
            centerFast2=[centerFast2;centerFast'];
            angleOfOscillationAsym2=[angleOfOscillationAsym2;angleOfOscillationAsym'];
            phaseShift2=[phaseShift2;phaseShift'];
            phaseShiftGTO2=[phaseShiftGTO2;phaseshiftGTO'];
            %             equivalentSpeed2=[equivalentSpeed2; equivalentSpeed'];
            
            RotatedResults.Parameters=[stepLengthAsym2 stepLengthDiffr stepLengthSlowr stepLengthFastr...
                spatialContribution2 stepTimeContribution2 velocityContribution2 netContribution2...
                spatialContributionNorm stepTimeContributionNorm velocityContributionNorm netContributionNorm...
                alphaSlow2 alphaTemp2 alphaFast2  Xfast2 Xslow2 alphaAngSlow2 alphaAngTemp2 alphaAngFast2 ...
                betaAngSlow2 betaAngFast2 centerSlow2 centerFast2 angleOfOscillationAsym2 ...
                phaseShift2];
            
            RotatedResults.labels={'Trial' 'Condition' 'stepLengthAsym' 'stepLengthDiff' 'stepLengthSlow' 'stepLengthFast'...
                'spatialContribution' 'stepTimeContribution' 'velocityContribution' 'netContribution'...
                'spatialContributionNorm' 'stepTimeContributionNorm' 'velocityContributionNorm' 'netContributionNorm'...
                'alphaSlow' 'alphaTemp' 'alphaFast' 'Xfast' 'Xslow' 'alphaAngSlow' 'alphaAngTemp' 'alphaAngFast' ...
                'betaAngSlow' 'betaAngFast' 'centerSlow' 'centerFast' 'angleOfOscillationAsym' ...
                'phaseShift'};
            
        end
        
    end
    %% Section to save the data on a location turn off or personalize as need it
    if OverGroundFlag
        %         cd(['C:\Users\dum5\Desktop\KidsStudy\Data\Kids_paper\Group' num2str(g) '\OGRotatedData'])
        cd(['C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\Group'  num2str(g) '\OGRotatedData'])
        save([name 'OGContributions.mat'],'RotatedResults')
    else
        %         cd(['C:\Users\dum5\Desktop\KidsStudy\Data\Kids_paper\Group' num2str(g) '\TMRotatedData'])
        cd(['C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\Group'  num2str(g) '\TMRotatedData'])
        save([name 'TMContributionsV2.mat'],'RotatedResults')
    end
    %     cd(['C:\Users\dum5\Desktop\KidsStudy\Data\Kids_paper\Group' num2str(g)])
    cd(['C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\Group' num2str(g)])
    
    
end

end






