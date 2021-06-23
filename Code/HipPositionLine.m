%Script to get subjects hip position on time
function RotatedResults=HipPositionLine(OverGroundFlag,subjects,g)
%Using the equation for the distance between a line and a point
%Calculate perpendicular distance between hip marker and  ankle position

global TrialTM TrialOG bOG bTM ConditionListTM ConditionListOG EventsOG EventsTM
global Trial b ConditionList Events DATATM DATAOG
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
    
    
    if OverGroundFlag %Choosing type of data
        Trial=TrialOG;
        b=bOG;
        ConditionList=ConditionListOG;
        Events=EventsOG;
        Data=DATAOG;
    else
        Trial=TrialTM;
        b=bTM;
        ConditionList=ConditionListTM;
        Events=EventsTM;
        Data=DATATM;
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
    cadenceSlow2=[];
    cadenceFast2=[];
    stepCadenceSlow2=[];
    stepCadenceFast2=[];
    
    
    
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
    
    
     for i=1:b %number of trials
        
        if ConditionList(i,2)==0 %good trial
            goodTrial=0;
        else
            goodTrial=1;
        end
        if goodTrial
            
            %Z is left to righ
            %X is anterior posterior
            %Y coordinate is height
            

            
% %         Extract ankle position
            RX=Trial(i).RAnklePos.X;
            LX=Trial(i).LAnklePos.X;
            RZ=Trial(i).RAnklePos.Z;
            LZ=Trial(i).LAnklePos.Z;
            
% %         Hip position
            HipRX=Trial(i).RHipPos.X;
            HipRZ=Trial(i).RHipPos.Z;
            HipLX=Trial(i).LHipPos.X;
            HipLZ=Trial(i).LHipPos.Z;
            
% %         Angle Position
            RLimbAng = Trial(i).Angle.RLimb;
            LLimbAng = Trial(i).Angle.LLimb;

            
            
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

     
            
%             % Classify events in toe offs and heel strikes
%             indexEven=2:2:totEvents;
%             indexOdd=1:2:totEvents;
%             
%             if RFootEvents(1)>LFootEvents(1)
%                 % 1st step with left heel strike
%                 LHSall=LFootEvents(indexOdd);
%                 LTOall=LFootEvents(indexEven);
%                 RHSall=RFootEvents(indexEven);
%                 RTOall=RFootEvents(indexOdd);
%                 %RHSall=RHSall(2:end);
%                 
%             else % 1st step with right heel strike
%                 LHSall=LFootEvents(indexEven);
%                 LTOall=LFootEvents(indexOdd);
%                 RHSall=RFootEvents(indexOdd);
%                 RTOall=RFootEvents(indexEven);
%                 RHSall=RHSall(2:end);
%                 
%                 
%             end
            
%             %Organizing events
%             LHS=LHSall(1:end-1);
%             LTO=LTOall(1:end);
%             LHS2=LHSall(2:end);
%             RHS=RHSall(1:end);
%             RTO=RTOall(1:end-1);
%             RTO2=RTOall(2:end);
%             
            %Time vectors
            tSHS=Ankle.Time(LHS);
            tFTO=Ankle.Time(RTO);
            tFHS=Ankle.Time(RHS);
            tSTO=Ankle.Time(LTO);
            tSHS2=Ankle.Time(LHS2);
            tFTO2=Ankle.Time(RTO2);
            
            
            
            if length(LHS)<=length(RHS) %Right number of events
                loop=length(LHS);
            else
                loop=length(RHS);
            end
            
            stepLengthSlow=[];
            stepLengthFast=[];
            stepLengthDiff=[];
            stepLengthAsym=[];
            alphaTemp=[];
            alphaSlow=[];
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
            cadenceSlow=[];
            cadenceFast=[];
            stepCadenceSlow=[];
            stepCadenceFast=[];
            stepTimeSlow=[];
            stepTimeFast=[];
            strideTimeSlow=[];
            strideTimeFast=[];
           
            for e=1:loop %loop to get contributions
                
                
                
                %Heel strikes event
                SHS=LHS(e);
                FHS=RHS(e);
                SHS2=LHS2(e);
                STO=LTO(e);
                FTO=RTO(e);
                FTO2=RTO2(e);
                
                %Ankle Position from SHS to SHS2
                LAnklePositionX=LX;
                LAnklePositionZ=LZ;
                LAnklePosition=[LAnklePositionZ,LAnklePositionX];
                RAnklePositionX=RX;
                RAnklePositionZ=RZ;
                RAnklePosition=[RAnklePositionZ,RAnklePositionX];
                
                %                 LAnklePositionX=LX(SHS:SHS2);
                %                 LAnklePositionZ=LZ(SHS:SHS2);
                %                 RAnklePositionX=RX(SHS:SHS2);
                %                 RAnklePositionZ=RZ(SHS:SHS2);
                
                
                
                
                %Hip position SHS
                HipRX_SHS=HipRX(SHS);
                HipRZ_SHS=HipRZ(SHS);
                RHip_SHS=[HipRZ(SHS),HipRX(SHS)];
                
                HipLX_SHS=HipLX(SHS);
                HipLZ_SHS=HipLZ(SHS);
                LHip_SHS=[HipLZ(SHS),HipLX(SHS)];
                
                
                %Hip Position FHS
                HipRX_FHS=HipRX(FHS);
                HipRZ_FHS=HipRZ(FHS);
                
                HipLX_FHS=HipLX(FHS);
                HipLZ_FHS=HipLZ(FHS);
                
                
                %Hip position SHS2
                HipRX_SHS2=HipRX(SHS2);
                HipRZ_SHS2=HipRZ(SHS2);
                
                HipLX_SHS2=HipLX(SHS2);
                HipLZ_SHS2=HipLZ(SHS2);
                
                
                
                %
                %                 figure
                %                 hold on
                %                 %Hip Trayectory
                %                 plot(HipRZ(SHS:SHS2),HipRX(SHS:SHS2),'-k',HipLZ(SHS:SHS2),HipLX(SHS:SHS2),'-k','DisplayName','Hip Trayectory')
                %                 plot(HipZavg(SHS:SHS2),HipXavg(SHS:SHS2),'-k','DisplayName','AvgHip Trayectory')
                %                 plot(HipRZ(SHS), HipRX(SHS), '*m',HipLZ(SHS), HipLX(SHS), '*m','DisplayName','HipSHS')
                %                 plot([HipRZ(SHS) HipLZ(SHS)],[HipRX(SHS) HipLX(SHS)],'c','DisplayName','Hip Line SHS')
                %                 plot(HipRZ(FHS), HipRX(FHS), '*g',HipLZ(FHS), HipLX(FHS), '*g','DisplayName','HipFHS')
                %                 plot([HipRZ(FHS) HipLZ(FHS)],[HipRX(FHS) HipLX(FHS)],'c','DisplayName','Hip Line FHS')
                %                 plot(HipRZ(SHS2), HipRX(SHS2), '*r',HipLZ(SHS2), HipLX(SHS2), '*r','DisplayName','HipSHS2')
                %                 plot([HipRZ(SHS2) HipLZ(SHS2)],[HipRX(SHS2) HipLX(SHS2)],'c','DisplayName','Hip Line SHS2')
                %
                % %
                %                 %Ankle Trayectory
                %                 plot(RAnklePositionZ(SHS:SHS2), RAnklePositionX(SHS:SHS2),'-k','DisplayName','RANK Trayectory')
                %                 plot(LAnklePositionZ(SHS:SHS2),LAnklePositionX(SHS:SHS2),'-k','DisplayName','LANK Trayectory')
                %                 plot(RAnklePositionZ(SHS), RAnklePositionX(SHS),'<m',LAnklePositionZ(SHS),LAnklePositionX(SHS),'<m','DisplayName','ANK-SHS ')
                %                 plot(RAnklePositionZ(FHS), RAnklePositionX(FHS),'<g',LAnklePositionZ(FHS),LAnklePositionX(FHS),'<g','DisplayName','ANK-FHS ')
                %                 plot(RAnklePositionZ(SHS2), RAnklePositionX(SHS2),'<r',LAnklePositionZ(SHS2),LAnklePositionX(SHS2),'<r','DisplayName','ANK-SHS2')
                %
                %                legend show
                %
                %Line to point equation
                if OverGroundFlag 
                alphaTemp(e)=abs((HipRX_SHS-HipLX_SHS)*LAnklePositionZ(SHS)-(HipRZ_SHS-HipLZ_SHS)*LAnklePositionX(SHS)-(HipRX_SHS*HipLZ_SHS)+(HipRZ_SHS*HipLX_SHS))/sqrt((HipRX_SHS-HipLX_SHS)^2+(HipRZ_SHS-HipLZ_SHS)^2);
                alphaFast(e)=abs((HipRX_FHS-HipLX_FHS)*RAnklePositionZ(FHS)-(HipRZ_FHS-HipLZ_FHS)*RAnklePositionX(FHS)-(HipRX_FHS*HipLZ_FHS)+(HipRZ_FHS*HipLX_FHS))/sqrt((HipRX_FHS-HipLX_FHS)^2+(HipRZ_FHS-HipLZ_FHS)^2);
                alphaSlow(e)=abs((HipRX_SHS2-HipLX_SHS2)*LAnklePositionZ(SHS2)-(HipRZ_SHS2-HipLZ_SHS2)*LAnklePositionX(SHS2)-(HipRX_SHS2*HipLZ_SHS2)+(HipRZ_SHS2*HipLX_SHS2))/sqrt((HipRX_SHS2-HipLX_SHS2)^2+(HipRZ_SHS2-HipLZ_SHS2)^2);
                
                Xslow(e)=abs((HipRX_FHS-HipLX_FHS)*LAnklePositionZ(FHS)-(HipRZ_FHS-HipLZ_FHS)*LAnklePositionX(FHS)-(HipRX_FHS*HipLZ_FHS)+(HipRZ_FHS*HipLX_FHS))/sqrt((HipRX_FHS-HipLX_FHS)^2+(HipRZ_FHS-HipLZ_FHS)^2);
                Xfast(e)=abs((HipRX_SHS2-HipLX_SHS2)*RAnklePositionZ(SHS2)-(HipRZ_SHS2-HipLZ_SHS2)*RAnklePositionX(SHS2)-(HipRX_SHS2*HipLZ_SHS2)+(HipRZ_SHS2*HipLX_SHS2))/sqrt((HipRX_SHS2-HipLX_SHS2)^2+(HipRZ_SHS2-HipLZ_SHS2)^2);
                %
                %                 figure()
                %                 hold on
                %                 plot(tSHS(e),alphaTemp(e),'*m')
                %                 plot(tFHS(e),-Xslow(e),'<m')
                %                 plot([tSHS(e) tFHS(e)],[alphaTemp(e) -Xslow(e)],'k')
                %                 plot([tFHS(e) tSHS2(e)],[-Xslow(e) alphaSlow(e)],'k')
                %
                %                 plot(tFHS(e),alphaFast(e),'*g')
                %                 plot(tSHS2(e),-Xfast(e),'<g')
                %                 plot([tFHS(e) tSHS2(e)],[alphaFast(e) -Xfast(e)],'--c')
                %
                %                 plot(tSHS2(e),alphaSlow(e),'*r')
                else
                    LHipAnkPos=LAnklePositionX-HipLX;
                    RHipAnkPos=RAnklePositionX-HipRX;
                    alphaSlow(e)=abs(LHipAnkPos(SHS2));
                    alphaTemp(e)=abs(LHipAnkPos(SHS));
                    alphaFast(e)=abs(RHipAnkPos(FHS));
                    Xslow(e)=abs(LHipAnkPos(FHS));
                    Xfast(e)=abs(RHipAnkPos(SHS2));
                    
                    
                end
                
                extendedEventTimes=[tSHS(e) tFTO(e) tFHS(e) tSTO(e) tSHS2(e) tFTO2(e)];
                
                diffHS(e)=((tFHS(e)-tSHS(e)))-((tSHS2(e)-tFHS(e)));
                strideDuration=diff(extendedEventTimes(:,[1,5]),1,2);
                
                
                %Marking bad strides
                                bad=any(isnan(extendedEventTimes),2) | any(diff(extendedEventTimes,1,2)<0,2) | (strideDuration >1.5*nanmedian(strideDuration)) | (strideDuration<.4)...
                                    | (strideDuration>2.5) | diffHS(e)< -0.4 |  Xslow(e)<50 |  Xslow(e)>400 | Xfast(e)<50 | Xfast(e)>400 | alphaFast(e)<50| alphaSlow(e)<50;
                
%                                 if bad==1   %In case of bad strides fill with NaN
%                                     display(['warnning bad stride subject' name ' Trial ' num2str(i) ' Step '  num2str(e)])
%                 
%                 
%                                     stepLengthAsym(e)=nan;
%                                     stepLengthDiff(e)=nan;
%                                     stepLengthSlow(e)=nan;
%                                     stepLengthFast(e)=nan;
%                                     spatialContribution(e)=nan;
%                                     stepTimeContribution(e)=nan;
%                                     velocityContribution(e)=nan;
%                                     netContribution(e)=nan;
%                                     spatialContributionNorm2(e)=nan;
%                                     stepTimeContributionNorm2(e)=nan;
%                                     velocityContributionNorm2(e)=nan;
%                                     netContributionNorm2(e)=nan;
%                                     alphaSlow(e)=nan;
%                                     alphaTemp(e)=nan;
%                                     alphaFast(e)=nan;
%                                     Xslow(e)=nan;
%                                     Xfast(e)=nan;
%                                     equivalentSpeed(e)=nan;
%                                     cond(e)=0;
%                 
%                                     %angle data
%                                     alphaAngSlow(e)=nan;
%                                     alphaAngTemp(e)=nan;
%                                     alphaAngFast(e)=nan;
%                                     betaAngSlow(e)=nan;
%                                     betaAngFast(e)=nan;
%                                     centerSlow(e)=nan;
%                                     centerFast(e)=nan;
%                                     angleOfOscillationAsym(e)=nan;
%                 
%                                     %phase shift (using angles)
%                                     slowlimb(e)=nan;
%                                     fastlimb(e)=nan;
%                                     % Circular correlation
%                                     phaseShift(e)=nan;
%                 
%                                 else % Calculating Contributions
                
                
                %alpha (positive portion of interlimb angle at HS)
                alphaAngSlow(e)=LLimbAng(LHS2(e));
                alphaAngTemp(e)=LLimbAng(LHS(e));
                alphaAngFast(e)=RLimbAng(RHS(e));
                %beta (negative portion of interlimb angle at TO)
                betaAngSlow(e)=LLimbAng(LTO(e));
                betaAngFast(e)=RLimbAng(RTO(e));
                

                    alphaAngSlow(e)=abs(alphaAngSlow(e));
                    alphaAngTemp(e)=abs(alphaAngTemp(e));
                    alphaAngFast(e)=abs(alphaAngFast(e));
                    betaAngSlow(e)=-abs(betaAngSlow(e));
                    betaAngFast(e)=-abs(betaAngFast(e));
               

%                     alphaAngSlowC(e)=abs(alphaAngSlow(e));
%                     alphaAngTempC(e)=abs(alphaAngTemp(e));
%                     alphaAngFastC(e)=abs(alphaAngFast(e));
%                     betaAngSlowC(e)=-abs(betaAngSlow(e));
%                     betaAngFastC(e)=-abs(betaAngFast(e));
                
                centerSlow(e)=(alphaAngTemp(e)+betaAngSlow(e))/2;
                centerFast(e)=(alphaAngFast(e)+betaAngFast(e))/2;
                angleOfOscillationAsym(e)=centerFast(e)-centerSlow(e);
                
                %phase shift (using angles)
                slowlimb=LLimbAng(SHS:FTO2);
                fastlimb=RLimbAng(SHS:FTO2);
%                 slowlimb=slowlimb-mean(slowlimb);
%                 fastlimb=fastlimb-mean(fastlimb);
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
                
                Xfast(e)=-Xfast(e);
                Xslow(e)=-Xslow(e);
                
                stepLengthSlow(e)=alphaSlow(e)-Xfast(e);
                stepLengthFast(e)=alphaFast(e)-Xslow(e);
                
                stepLengthDiff(e)=stepLengthFast(e)-stepLengthSlow(e);
                stepLengthAsym(e)=stepLengthDiff(e)./(stepLengthFast(e)+stepLengthSlow(e));
                
                ts(e)=(tFHS(e)-tSHS(e));
                tf(e)=(tSHS2(e)-tFHS(e));
                difft(e)=ts(e)-tf(e);
                
                velocitySlow(e)=(alphaTemp(e)-Xslow(e))/ts(e);
                velocityFast(e)=(alphaFast(e)-Xfast(e))/tf(e);
                avgVel(e)=mean([velocitySlow(e) velocityFast(e)],2);
                avgStepTime(e)=mean([ts(e) tf(e)],2); %This is half strideTimeSlow!
                
                spatialContribution(e)=(alphaFast(e)-alphaTemp(e))-(alphaSlow(e)-alphaFast(e));
                stepTimeContribution(e)=avgVel(e)*difft(e);
                velocityContribution(e)=avgStepTime(e)*(velocitySlow(e)-velocityFast(e));
                netContribution(e)=spatialContribution(e)+stepTimeContribution(e)+velocityContribution(e);
                
                Dist(e)=stepLengthFast(e)+stepLengthSlow(e);
                spatialContributionNorm2(e)=spatialContribution(e)/Dist(e);
                stepTimeContributionNorm2(e)=stepTimeContribution(e)/Dist(e);
                velocityContributionNorm2(e)=velocityContribution(e)/Dist(e);
                netContributionNorm2(e)=netContribution(e)/Dist(e);
                
                %step times (time between heel strikes)
                stepTimeSlow(e)=tSHS2(e)-tFHS(e);
                stepTimeFast(e)=tFHS(e)-tSHS(e);
                
                %stride times
                strideTimeSlow(e)=tSHS2(e)-tSHS(e);
                strideTimeFast(e)=tFTO2(e)-tFTO(e);
                %cadence (stride cycles per s)
                cadenceSlow(e)=1./strideTimeSlow(e);
                cadenceFast(e)=1./strideTimeFast(e);
                %step cadence (steps per s)
                stepCadenceSlow(e)=1./stepTimeSlow(e);
                stepCadenceFast(e)=1./stepTimeFast(e);
                
                cond(e)=ConditionList(find(ConditionList(:,1)==i),2);
                
                
            end
%                         end
            %Saving results into vectors and matrix
            
            
% %          
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
            cadenceSlow2=[cadenceSlow2;cadenceSlow'];
            cadenceFast2=[cadenceFast2;cadenceFast'];
            stepCadenceSlow2=[stepCadenceSlow2;stepCadenceSlow'];
            stepCadenceFast2=[stepCadenceFast2;stepCadenceFast'];
            
            
            
            
            RotatedResults.Parameters=[stepLengthAsym2 stepLengthDiffr stepLengthSlowr stepLengthFastr...
                spatialContribution2 stepTimeContribution2 velocityContribution2 netContribution2...
                spatialContributionNorm stepTimeContributionNorm velocityContributionNorm netContributionNorm...
                alphaSlow2 alphaTemp2 alphaFast2 Xfast2 Xslow2 alphaAngSlow2 alphaAngTemp2 alphaAngFast2 ...
                betaAngSlow2 betaAngFast2 centerSlow2 centerFast2 angleOfOscillationAsym2 ...
                phaseShift2 cadenceSlow2 cadenceFast2 stepCadenceSlow2 stepCadenceFast2];
            
            RotatedResults.labels={'Trial' 'Condition' 'stepLengthAsym' 'stepLengthDiff' 'stepLengthSlow' 'stepLengthFast'...
                'spatialContribution' 'stepTimeContribution' 'velocityContribution' 'netContribution'...
                'spatialContributionNorm' 'stepTimeContributionNorm' 'velocityContributionNorm' 'netContributionNorm'...
                'alphaSlow' 'alphaTemp' 'alphaFast' 'Xfast' 'Xslow' 'alphaAngSlow' 'alphaAngTemp' 'alphaAngFast' ...
                'betaAngSlow' 'betaAngFast' 'centerSlow' 'centerFast' 'angleOfOscillationAsym' ...
                'phaseShift' 'cadenceSlow' 'cadenceFast' 'stepCadenceSlow' 'stepCadenceFast'};
            
        end
        
    end
    
    %% Section to save the data on a location turn off or personalize as need it
    
    if OverGroundFlag
        %         cd(['C:\Users\dum5\Desktop\KidsStudy\Data\Kids_paper\Group' num2str(g) '\OGRotatedData'])
        badstrides=find(Data(:,2)==0);
        RotatedResults.Parameters(badstrides,:)=[];
        cd(['/Users/dulcemariscal/OneDrive - University of Pittsburgh/aResearch_Studies/KidsStudy/Data/Kids_paper/Group' num2str(g) '/OGRotatedData'])
%         cd(['C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\Group'  num2str(g) '\OGRotatedData'])
        %         cd(['C:\Users\maris\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\Group'  num2str(g) '\OGRotatedData'])
        save([name 'OGContributionsV3.mat'],'RotatedResults')
% save([name 'OGContributionsLine.mat'],'RotatedResults')
    else
        %         cd(['C:\Users\dum5\Desktop\KidsStudy\Data\Kids_paper\Group' num2str(g) '\TMRotatedData'])
%         cd(['C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\Group'  num2str(g) '\TMRotatedData'])

        cd(['/Users/dulcemariscal/OneDrive - University of Pittsburgh/aResearch_Studies/KidsStudy/Data/Kids_paper/Group' num2str(g) '/TMRotatedData'])
        save([name 'TMContributionsV3.mat'],'RotatedResults')
    end
    % cd(['C:\Users\dum5\Desktop\KidsStudy\Data\Kids_paper\Group' num2str(g)])
%     cd(['C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\Group' num2str(g)])
    %     cd(['C:\Users\maris\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\Group' num2str(g)])
    
    cd(['/Users/dulcemariscal/OneDrive - University of Pittsburgh/aResearch_Studies/KidsStudy/Data/Kids_paper/Group' num2str(g)])
    
    
end

end











