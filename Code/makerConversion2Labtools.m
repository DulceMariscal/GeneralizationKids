%Past maker data from Kids data to a labtools format
function markersData=makerConversion2Labtools(OverGroundFlag,subjects)
global TrialTM TrialOG bOG bTM ConditionListTM ConditionListOG EventsOG EventsTM
global Trial b ConditionList Events

subj=subjects;
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

or=orientationInfo(0,'y','z','x');

for i=1:b
    
    makerDataTrial(i)=orientedLabTimeSeries.getOTSfromOrientedData([Trial(i).RAnklePos.Y Trial(i).RAnklePos.Z Trial(i).RAnklePos.X Trial(i).LAnklePos.Y Trial(i).LAnklePos.Z Trial(i).LAnklePos.X Trial(i).RHipPos.Y Trial(i).RHipPos.Z Trial(i).RHipPos.X Trial(i).LHipPos.Y Trial(i).LHipPos.Z Trial(i).LHipPos.X  ],0,.01,{'RANK','LANK', 'RHIP','LHIP'},or);
    
   
end

for i=1:b  
    
        RLimbAngle = calcangle([makerDataTrial(i).Data(:,3) makerDataTrial(i).Data(:,1)], [makerDataTrial(i).Data(:,9) makerDataTrial(i).Data(:,7)], [makerDataTrial(i).Data(:,9)+100 makerDataTrial(i).Data(:,7)])-90;
        LLimbAngle = calcangle([makerDataTrial(i).Data(:,6) makerDataTrial(i).Data(:,4)], [makerDataTrial(i).Data(:,12) makerDataTrial(i).Data(:,10)], [makerDataTrial(i).Data(:,12)+100 makerDataTrial(i).Data(:,10)])-90;
    
    % time info needed for labtimeseries object
    t0=makerDataTrial(i).Time(1);
    Ts=makerDataTrial(i).sampPeriod;
    
    angleData(i)=labTimeSeries([RLimbAngle LLimbAngle],t0,Ts,{'RLimb','LLimb'});
end
markersData.markerData= makerDataTrial;
markersData.angleData=angleData;

%  eval(['save ',name,' markersData -append'])

end