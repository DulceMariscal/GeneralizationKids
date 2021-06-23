function results = getResultsDM(SMatrix,params,groups,maxPerturb,plotFlag,indivFlag,removeBias,cond,maxParam,outlier,mergeG)

% define number of points to use for calculating values
catchNumPts = 5; %catch
steadyNumPts = 20; %end of adaptation
transientNumPts = 5; %OG and Washout

nParams=length(params);

if mergeG==1
    SMatrix.Group5.IDs=[SMatrix.Group5.IDs SMatrix.Group6.IDs];
    names=fieldnames(SMatrix.Group6);
    for xx=4:10
        [SMatrix.Group5(:).(names{xx})]=SMatrix.Group6.(names{xx});
    end

    SMatrix=rmfield(SMatrix,'Group6');
    
end

if nargin<3 || isempty(groups)
    groups=fields(SMatrix);  %default
end
nGroups=length(groups);
groupsID=fieldnames(SMatrix);



Ogroupslabels=groupsID;
labels= SMatrix.(Ogroupslabels{1}).labels';
conditions=SMatrix.(Ogroupslabels{1}).Condition;

if nargin<5 || isempty(plotFlag)
    plotFlag=1;
end

for p=1:length(params)
paramsIdx(p)=find(strcmp(params{p},labels'));
end

StpLngAsym= find(strcmp('stepLengthAsym',labels'));
VelocityCon=find(strcmp('velocityContributionNorm',labels'));
StepTime=find(strcmp('stepTimeContributionNorm',labels'));
CO=find(strcmp('angleOfOscillationAsym',labels'));
PS=find(strcmp('phaseShift',labels'));

OGBaseidx=find(strcmp('OGBase',conditions));
OGPostidx=find(strcmp('OGpost',conditions));
TMBaseidx=find(strcmp('TMBase',conditions));
Adaptation1idx=find(strcmp('Adaptation1',conditions));
Adaptation2idx=find(strcmp('Adaptation2',conditions));
Catchidx=find(strcmp('Catch',conditions));
Readaptationidx=find(strcmp('Readaptation',conditions));
TMpostidx=find(strcmp('TMpost',conditions));


if strcmp('stepLengthAsym',maxParam) || strcmp('SLA',maxParam)
    max=StpLngAsym;
elseif strcmp('phaseShift',maxParam) || strcmp('PS',maxParam)
    max=PS;
elseif strcmp('angleOfOscillationAsym',maxParam) || strcmp('CO',maxParam)
    %        max=StepTime;
    max=CO;   
end

% Initialize outcome measures to compute
outcomeMeasures =...
    {'OGbase',...
    'TMbase',...
    'AvgAdaptBeforeCatch',...
    'AvgAdaptAll',...
    'ErrorsOut',...
    'Pert',...
    'LateAdaptBeforeCatch',...
    'AdaptIndexBeforeCatch',...
    'Catch',...
    'LateAdaptReAdapt',...
    'AdaptIndex',...
    'OGafter',... %First 5 strides
    'OGafterEarly',... %From 6 to 20
    'OGafterLate40',...
    'OGafterLate20',...
    'OGafterLate10',...
    'AvgOGafter'...
    'TMafter',...
    'TMafterEarly',...
    'TMafterLate',...
    'Transfer',...
    'Washout',...
    'Washout2',...
    'Transfer2',...
    };




for i =1:length(outcomeMeasures)
    results.(outcomeMeasures{i}).avg=NaN(nGroups,nParams);
    results.(outcomeMeasures{i}).se=NaN(nGroups,nParams);
end

if outlier==1
    index=find(strcmp(SMatrix.Group1.IDs,'LN0375'));
%     index=find(strcmp(SMatrix.Group1.IDs,'LN0331'));
    SMatrix.Group1.IDs(:,index)=[];
%     SMatrix.Group1=rmfield(SMatrix.Group1,'LN0331');
    SMatrix.Group1=rmfield(SMatrix.Group1,'LN0375');
   
end


%     SMatrix
    

for g=1:nGroups
    
    % get number of subjects in group
%     if g==1
%         SMatrix.Group1=rmfield(SMatrix.Group1,'LN0331')
%     end

    nSubs=length(SMatrix.(groupsID{g}).IDs);
    subjectsID=SMatrix.(groupsID{g}).IDs;
    
    
    % clear/initialize measures
    for i=1:length(outcomeMeasures)
        eval([outcomeMeasures{i} '=NaN(nSubs,nParams);'])
    end
    
    AdaptExtent=[];
    
    for s=1:nSubs
        
         % remove baseline bias
        if removeBias 
            for sub=1:nSubs
                subject=SMatrix.(groupsID{g}).IDs(sub);
                Data=SMatrix.(groupsID{g}).(subject{1});
                               
                OGIndex=find(Data(:,2)==OGBaseidx | Data(:, 2)==OGPostidx);
                TMIndex=find(Data(:,2)==TMBaseidx | Data(:, 2)==Adaptation1idx | Data(:, 2)==Adaptation2idx | Data(:, 2)==Catchidx | Data(:, 2)==Readaptationidx | Data(:, 2)==TMpostidx);
                
                OGData=Data(OGIndex,:);
                TMData=Data(TMIndex,:);
                
                baseindexOG=find(OGData(:,2)==OGBaseidx);
                baseindexTM=find(TMData(:,2)==TMBaseidx);
                
                %OG            
                if ~isempty(baseindexOG)
                    if strcmp(subjectsID{sub},'LN0319')
                     BaseOG(sub,:)=nanmean(OGData(baseindexOG(1:end),:));   
                        
                    elseif strcmp(subjectsID{sub},'LN0341')
                        BaseOG(sub,:)=nanmean(OGData(baseindexOG(end-4:end),:));
                    else
                    BaseOG(sub,:)=nanmean(OGData(baseindexOG(1:end),:)); %Last 5 strides of the baseline condition
                    end
                elseif isempty(baseindexOG)
                    BaseOG(sub,:)=nan;
                end
                
                %TM
                if ~isempty(baseindexTM)
                    BaseTM(sub,:)=nanmean(TMData(baseindexTM(1:end),:)); %Last 5 strides of the baseline condition
                elseif isempty(baseindexTM)
                    BaseTM(sub,:)=nan;
                end
                
                NewDataOG=bsxfun(@minus,OGData(:,3:end),BaseOG(sub,3:end));
                NewDataTM=bsxfun(@minus,TMData(:,3:end),BaseTM(sub,3:end));
                
                NewData=[OGData(:,1:2) NewDataOG; TMData(:,1:2) NewDataTM];
                
                SMatrix.(groupsID{g}).(subject{1})=NewData;
                
            end
        end
        
        clear BaseOG BaseTM NewDataOG NewDataTM NewData
        % load subject
          subject=SMatrix.(groupsID{g}).IDs(s);
          adaptData=SMatrix.(groupsID{g}).(subject{1});
        
        if nargin>3 && maxPerturb==1
            
%              max=StepTime;
%              max=StpLngAsym;
%              max=PS;
%                max=CO;
                
            % compute TM and OG base in same manner as calculating OG after and TM after
            if nansum(cellfun(@(x) strcmp(x, 'OGBase'), cond))==1   
                MaxData=adaptData(adaptData(:,2)==OGBaseidx,max);
                OGbaseData=adaptData(adaptData(:,2)==OGBaseidx,paramsIdx);

                 if strcmp(subjectsID{s},'LN0319')
                    OGbase(s,:)= nanmean(OGbaseData(1:end,:));
                 elseif strcmp(subjectsID{s},'LN0341')
                    OGbase(s,:)= nanmean(OGbaseData(end-4:end,:)); 
                 else
                 OGbase(s,:)= nanmean(OGbaseData(1:end,:));
                 end 
            end
            
            
            % compute OG after as mean values during strides which cause a
            % maximum deviation from zero in STEP LENGTH ASYMMETRY during
            % 'transientNumPts' consecutive strides within first 10 strides
            if nansum(cellfun(@(x) strcmp(x, 'OGpost'), cond))==1
                MaxData=adaptData(adaptData(:,2)==OGPostidx,max);
                ogafterData=adaptData(adaptData(:,2)==OGPostidx, paramsIdx);
                OGafter(s,:)= smoothedMax(ogafterData,transientNumPts,MaxData);
%                 OGafter=-(OGafter);
%                 OGafter(s,:)= smoothedMax(ogafterData(1:10,:),transientNumPts,MaxData(1:10));
%                 OGafter(s,:)= smoothedMax(ogafterData(1:10,:),transientNumPts,MaxData(1:10));
                OGafterLate20(s,:)=nanmean(ogafterData((end-5)-20+1:(end-5),:));
                OGafterLate10(s,:)=nanmean(ogafterData((end-5)-10+1:(end-5),:));
            end
            
            
            
            MaxData=adaptData(adaptData(:,2)==TMBaseidx,max);
            TMbaseData=adaptData(adaptData(:,2)==TMBaseidx,paramsIdx);
            TMbase(s,:)=nanmean(TMbaseData(1:end,:)); 
%             TMbase(s,:)=smoothedMax(TMbaseData,transientNumPts,MaxData);
            
            % compute catch as mean value during strides which caused a
            % maximum deviation from zero during 'catchNumPts' consecutive
            % strides
            if nansum(cellfun(@(x) strcmp(x, 'Catch'), cond))==1
                MaxData=adaptData(adaptData(:,2)==Catchidx,max);
                tmcatchData=adaptData(adaptData(:,2)==Catchidx,paramsIdx);
                Catch(s,:)=smoothedMax(tmcatchData,catchNumPts,MaxData);
            end
            
            
            % compute TM after-effects same as OG after-effect
            MaxData=adaptData(adaptData(:,2)==TMpostidx,max);
            tmafterData=adaptData(adaptData(:,2)==TMpostidx,paramsIdx);
            TMafter(s,:)= smoothedMax(tmafterData,transientNumPts,MaxData);
            TMafterEarly(s,:)=nanmean(tmafterData(transientNumPts+1:transientNumPts+20,:));
           TMafterLate(s,:)=nanmean(tmafterData((end-5)-steadyNumPts+1:(end-5),:));
            
        else
            
            % calculate TM and OG base in same manner as calculating OG after and TM after
            if nansum(cellfun(@(x) strcmp(x, 'OGBase'), cond))==1
                OGbaseData=adaptData(adaptData(:,2)==OGBaseidx,paramsIdx);
                OGbase(s,:)= nanmean(OGbaseData(1:end,:)); %Average all strides 
                
%                 OGbase(s,:)= nanmean(OGbaseData(1:transientNumPts,:));
%                 if length(OGbaseData)>40
%                 OGbase(s,:)= nanmean(OGbaseData((end-5)-steadyNumPts+1:(end-5),:));
%                 elseif length(OGbaseData)>5
%                  OGbase(s,:)= nanmean(OGbaseData((end-5),:)); 
%                 elseif length(OGbaseData)<5
%                  OGbase(s,:)= nanmean(OGbaseData((end-4),:)); 
%                 end
            end
            
            if nansum(cellfun(@(x) strcmp(x, 'TMBase'), cond))==1
                TMbaseData=adaptData(adaptData(:,2)==TMBaseidx,paramsIdx);
                TMbase(s,:)=nanmean(TMbaseData(1:end,:));  %Average all strides 
%                 TMbase(s,:)=nanmean(TMbaseData(1:transientNumPts,:));
%                 TMbase(s,:)=nanmean(TMbaseData((end-5)-steadyNumPts+1:(end-5),:));
            end
            
            % compute catch
            if nansum(cellfun(@(x) strcmp(x, 'catch'), lower(cond)))==1
                tmcatchData=adaptData(adaptData(:,2)==Catchidx,paramsIdx);
                if isempty(tmcatchData)
                    newtmcatchData=NaN(1,nParams);
                elseif size(tmcatchData,1)<3
                    newtmcatchData=nanmean(tmcatchData);
                else
                    if length(tmcatchData)<5
                    newtmcatchData=nanmean(tmcatchData(1:end,:));
                    else
                        newtmcatchData=nanmean(tmcatchData(1:catchNumPts,:));
                    end
                    %newtmcatchData=nanmean(tmcatchData);
                end
                Catch(s,:)=newtmcatchData;
            end
             
            % compute OG post
            if nansum(cellfun(@(x) strcmp(x, 'OGpost'), cond))==1
                ogafterData=adaptData(adaptData(:,2)==OGPostidx,paramsIdx);
                OGafter(s,:)=nanmean(ogafterData(1:transientNumPts,:));
                OGafterEarly(s,:)=nanmean(ogafterData(transientNumPts+1:transientNumPts+20,:));
%                 OGafterLate40(s,:)=nanmean(ogafterData((end-5)-40+1:(end-5),:));
                OGafterLate20(s,:)=nanmean(ogafterData((end-5)-20+1:(end-5),:));
                OGafterLate10(s,:)=nanmean(ogafterData((end-5)-10+1:(end-5),:));
                
%                 if length(ogafterData)<50
%                 OGafterLate(s,:)=nanmean(ogafterData((end-5)-20+1:(end-5),:)); %Last strides
%                 else
%                 OGafterLate(s,:)=nanmean(ogafterData((end-5)-steadyNumPts+1:(end-5),:));
%                 end
                
                %Sum of OG after-effects
                AvgOGafter(s,:)=mean(ogafterData(1:min([end 50])));
            end
            
            % compute TM post
            if nansum(cellfun(@(x) strcmp(x, 'TMpost'), cond))==1
                tmafterData=adaptData(adaptData(:,2)==TMpostidx, paramsIdx);
                TMafter(s,:)=nanmean(tmafterData(1:transientNumPts,:));
                TMafterEarly(s,:)=nanmean(tmafterData(transientNumPts+1:transientNumPts+20,:));
                TMafterLate(s,:)=nanmean(tmafterData((end-5)-steadyNumPts+1:(end-5),:));
            end
        end
        
        
        if nansum(cellfun(@(x) strcmp(x, 'catch'), lower(cond)))==1
            % compute TM steady state before catch (mean of first transinetNumPts of last transinetNumPts+5 strides)
            adapt1Data=adaptData(adaptData(:,2)==Adaptation1idx,paramsIdx);
            adapt2Data=adaptData(adaptData(:,2)==Adaptation2idx,paramsIdx);
            adapt2Velocity=adaptData(adaptData(:,2)==Adaptation2idx,VelocityCon);
            
            if isempty(adapt2Data)
             adapt2Data=adaptData(adaptData(:,2)==Adaptation2idx,paramsIdx);
            adapt2Velocity=adaptData(adaptData(:,2)==Adaptation2idx,VelocityCon);
            end
            
            Pert(s,:)=nanmean(adapt1Data(1:transientNumPts,:));
            if length(adapt2Data)>20
            LateAdaptBeforeCatch(s,:)=nanmean(adapt2Data((end-5)-steadyNumPts+1:(end-5),:)); %20 strides before catch execpt the very last 5
            else
            LateAdaptBeforeCatch(s,:)=nanmean(adapt2Data(1:end)); %20 strides before catch execpt the very last 5    
            end
            %start of step length = end of velocityCont
%             idx = find(strcmpi(params, 'stepLengthAsym'));
%             if isempty(idx)
%                 idx = find(strcmpi(params, 'netContributionNorm'));
%             end
%             if ~isempty(idx)
                AdaptIndexBeforeCatch(s,:)=nanmean(adapt2Data((end-5)-steadyNumPts+1:(end-5),:))-Pert(s,:);
%             end
            
            % compute average adaptation value before the catch
            AvgAdaptBeforeCatch(s,:)= nanmean(adapt1Data);
        end
        
        %
        
        % compute TM steady state before OG walking (mean of first steadyNumPts of last steadyNumPts+5 strides)
        adapt2Data=[];
        if nansum(cellfun(@(x) strcmp(x, 'readaptation'), lower(cond)))==1
            adapt2Data=adaptData(adaptData(:,2)==Readaptationidx, paramsIdx);
            adapt2Sasym=adaptData(adaptData(:,2)==Readaptationidx,StpLngAsym);
            adapt2Velocity=adaptData(adaptData(:,2)==Readaptationidx,VelocityCon);
        elseif isempty(adapt2Data)
            adapt2Data=adaptData(adaptData(:,2)==Adaptation2idx,paramsIdx);
            adapt2Sasym=adaptData(adaptData(:,2)==Adaptation2idx,StpLngAsym);
           adapt2Velocity=adaptData(adaptData(:,2)==Adaptation2idx,VelocityCon);
        end
        
        
%         LateAdaptReAdapt(s,:)= nanmean(adapt2Data((end-5)-steadyNumPts+1:(end-5),:)); %last 20 straides of adaptation
          LateAdaptReAdapt(s,:)= nanmean(adapt2Data(end-steadyNumPts+1:end,:));
%         idx = find(strcmpi(params, 'stepLengthAsym'));
%         if isempty(idx)
%             idx = find(strcmpi(params, 'netContributionNorm'));
%         end
%         if ~isempty(idx)
%             AdaptIndex(s,idx)=nanmean(adapt2Sasym((end-5)-steadyNumPts+1:(end-5),:)-adapt2Velocity((end-5)-steadyNumPts+1:(end-5),:));
           AdaptIndex(s,:)=nanmean(adapt2Data((end-5)-steadyNumPts+1:(end-5),:))-Pert(s,:);
%         end
        
        AdaptExtent(s,:)=nanmean(adapt2Sasym((end-5)-steadyNumPts+1:(end-5),:)-adapt2Velocity((end-5)-steadyNumPts+1:(end-5),:));
        
        
        
        
        % compute average adaptation of all adaptation walking (both
        % before and after catch)
        adaptAllData=adaptData(adaptData(:,2)==[Adaptation1idx],paramsIdx);
        AvgAdaptAll(s,:)= nanmean(adaptAllData);

     
    end
    


% compute extent of adaptation as difference between start and end
%     AdaptExtentBeforeCatch=TMsteadyBeforeCatch-StartAdapt;
%     AdaptExtent=TMsteady-StartAdapt;

% calculate relative after-effects
if nansum(cellfun(@(x) strcmp(x, 'OGpost'), cond))==1 && nansum(cellfun(@(x) strcmp(x, 'Adaptation2'), cond))==1 || nansum(cellfun(@(x) strcmp(x, 'Readaptation'), cond))==1
    idx = find(strcmpi(params, 'stepLengthAsym'));
    if isempty(idx)
        idx = find(strcmpi(params, 'netContributionNorm'));
    end
    if ~isempty(idx)
        Transfer= 100*(OGafter./(Catch(:,idx)*ones(1,nParams)));
    else
        Transfer= 100*(OGafter./Catch);
    end
    Transfer2= 100*(OGafter./(AdaptExtent*ones(1,nParams)));
end

if nansum(cellfun(@(x) strcmp(x, 'adaptation1'), lower(cond)))==1 || nansum(cellfun(@(x) strcmp(x, 'readaptation'), lower(cond)))==1
    idx = find(strcmpi(params, 'stepLengthAsym'));
    if isempty(idx)
        idx = find(strcmpi(params, 'netContributionNorm'));
    end
    if ~isempty(idx)
        Washout= 100*(1-(TMafter./(Catch(:,idx)*ones(1,nParams))));
    else
        Washout = 100*(1-(TMafter./Catch));
    end
    Washout2= 100-(100*(TMafter./(AdaptExtent*ones(1,nParams))));
end


for j=1:length(outcomeMeasures)
    eval(['results.(outcomeMeasures{j}).avg(g,:)=nanmean(' outcomeMeasures{j} ',1);']);
    eval(['results.(outcomeMeasures{j}).se(g,:)=nanstd(' outcomeMeasures{j} './sqrt(nSubs));']);
%     eval(['results.(outcomeMeasures{j}).var(g,:)=nanvar(' outcomeMeasures{j} './sqrt(nSubs));']);
end

if g==1 %This seems ridiculous, but I don't know of another way to do it without making MATLAB mad.
    
    if plotFlag
        for p=1:nParams
            for m = 1:length(outcomeMeasures)
                eval(['results.(outcomeMeasures{m}).indiv.(params{p}) = [g*ones(nSubs,1) ' outcomeMeasures{m} '(:,p)];'])
            end
        end
    else
        %for stats
        for m=1:length(outcomeMeasures)
            %The results.(whatever).indiv structure needs to be in this format to make life easier for using SPSS
            eval(['results.(outcomeMeasures{m}).indiv=[g*ones(nSubs,1) ' outcomeMeasures{m} '];'])
        end
    end
    
else
    if plotFlag
        for p=1:nParams
            for m = 1:length(outcomeMeasures)
                eval(['results.(outcomeMeasures{m}).indiv.(params{p})(end+1:end+nSubs,1:2) = [g*ones(nSubs,1) ' outcomeMeasures{m} '(:,p)];'])
            end
        end
    else
        %for stats
        for m=1:length(outcomeMeasures)
            eval(['results.(outcomeMeasures{m}).indiv(end+1:end+nSubs,:)=[g*ones(nSubs,1) ' outcomeMeasures{m} '];'])
        end
    end
    
end
end

%plot stuff
if plotFlag
    
    %     % FIRST: plot baseline values against catch and transfer
%         epochs={'OGbase','TMbase','Pert','LateAdaptBeforeCatch','Catch','LateAdaptReAdapt','OGafter','TMafter'};
         epochs={'TMbase','Pert','LateAdaptBeforeCatch','AdaptIndexBeforeCatch','Catch','LateAdaptReAdapt','AdaptIndex','TMafter'};
% % % %          
% % % %         epochs={'OGbase','TMbase','OGafter','TMafter'};
% % % % %         epochs={'OGbase','OGafter'};
        if nargin>5 %I imagine there has to be a better way to do this...
            barGroupsDM(SMatrix,results,groups,params,epochs,indivFlag)
%            
            if removeBias
                title('Bias Removed')
            end
         
        else
            barGroupsDM(SMatrix,results,groups,params,epochs)
            if removeBias
                title('Bias Removed')
            end
        end
    
% %       %  SECOND: plot average adaptation values?
%         epochs={'Transfer','Transfer2'};
%          epochs={'OGbase','OGafter','OGafterLate20','OGafterLate10'};
%           epochs={'OGbase','TMbase','Catch','OGafter','TMafter'};
%           epochs={'Catch','OGafter','TMafter'};
%         epochs={'OGbase','OGafter'};
            epochs={'OGbase','OGafter','OGafterLate20'};
            if nargin>5
            barGroupsDM(SMatrix,results,groups,params,epochs,indivFlag)
            if  removeBias==1 && maxPerturb==1
                title(['Bias removed'])
            elseif removeBias==1
                title('Bias Removed')
            end
            else
            barGroupsDM(SMatrix,results,groups,params,epochs)
            if  removeBias==1 && maxPerturb==1
                title(['Bias removed' ])
            elseif removeBias==1
                title('Bias Removed')
            end
%             
%             
        end
% %     
% %         % SECOND: plot average adaptation values?
% %         epochs={'Washout','Washout2'};
% %         if nargin>5
% %             barGroupsDM(SMatrix,results,groups,params,epochs,indivFlag,removeBias,maxPerturb)
% %         else
% %             barGroupsDM(SMatrix,results,groups,params,epochs,removeBias,maxPerturb)
% %         end
end



