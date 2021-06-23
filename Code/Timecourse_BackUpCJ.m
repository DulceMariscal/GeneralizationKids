function [Avg_DATA AllDATA]=TimecourseCJ(sub)

%get step length symmetry for cond 9 (first 30 steps) for each subject
% cols:
% 27=S_out
% 31=T_out
% 20=double Support
% 17=phase shift
% 22=step length
% 34=angle of oscillation

% Set colors
poster_colors;
% Set colors order
ColorOrder=[p_red; p_orange; p_fade_green; p_fade_blue; p_plum; p_green; p_blue; p_fade_red; p_lime; p_gray; p_black; p_yellow;p_blue; p_fade_red; p_lime; p_gray; p_black; p_yellow];

set(0,'DefaultAxesColorOrder',ColorOrder)

NumPts =5;


group=[1 2];
for g = group
    subjects=sub{g};
    index=1;
    
    
    for s = subjects %subjets
        NumSubjects = length(subjects);
        name=['OG',num2str(s)];
        
        %Load file's DATA matrix
        eval(['load ',name,' DATA conditionlist'])
        
        
        % Compute Sout and Sgoal
        %
        FastRange=DATA(:,36);
        SlowRange=DATA(:,35);
        FastAlfa=DATA(:,26);
        SlowAlfa=DATA(:,25);
        
        Sout=(FastAlfa-SlowAlfa)./(FastAlfa+SlowAlfa);
        Sgoal=(FastRange-SlowRange)./(FastRange+SlowRange);
        
        DATA(:,27)=Sout;
        DATA(:,29)=Sgoal;
        
        %         % Find trials for which labels need to change
        newDATA=DATA;
        start_index=max(conditionlist(:,2))+1;
        trialsA=unique(DATA(find(DATA(:,2)==6),1));
        trialsRA=unique(DATA(find(DATA(:,2)==8),1));
        trialsPA=unique(DATA(find(DATA(:,2)==10),1));
        
        newlabelsA=[6 11 12 13];
        newlabelsRA=[8 14];
        newlabelsPA=[10 16 17];
        if s==12
            s
        end
        %          newlabelsA=[6];
        %          newlabelsRA=[9];
        %          newlabelsPA=[10];
        %
        % Change labels
        
        if length(trialsA)==4
            for trl=2:length(trialsA)
                
                trial2change=trialsA(trl);
                newDATA(find(DATA(:,1)==trial2change),2)=newlabelsA(trl);
                
            end
        else
            newlabelsA(end)=[];
            for trl=2:length(trialsA)
                
                trial2change=trialsA(trl);
                newDATA(find(DATA(:,1)==trial2change),2)=newlabelsA(trl);
                
            end
        end
        
        % Change labels
        if length(trialsRA)>=2
            for trl=2:length(trialsRA)
                trial2change=trialsRA(trl);
                if trial2change==18
                    newDATA(find(DATA(:,1)==trial2change),2)=newlabelsRA(2);
                else
                    
                    newDATA(find(DATA(:,1)==trial2change),2)=newlabelsRA(trl);
                    %newlabelsRA=[newlabelsRA start_index];
                    
                    
                end
                %start_index=start_index+1;
            end
        else
            newlabelsRA(end)=[];
            for trl=2:length(trialsRA)
                trial2change=trialsRA(trl);
                
                newDATA(find(DATA(:,1)==trial2change),2)=newlabelsRA(trl);
                %newlabelsRA=[newlabelsRA start_index];
                
                
                %start_index=start_index+1;
            end
        end
        
        % Change labels
        if length(trialsPA)==3
            for trl=2:length(trialsPA)
                trial2change=trialsPA(trl);
                newDATA(find(DATA(:,1)==trial2change),2)=newlabelsPA(trl);
                %newlabelsPA=[newlabelsPA start_index];
                
                %start_index=start_index+1;
            end
        else
            newlabelsPA(end)=[];
            for trl=2:length(trialsPA)
                trial2change=trialsPA(trl);
                newDATA(find(DATA(:,1)==trial2change),2)=newlabelsPA(trl);
                %newlabelsPA=[newlabelsPA start_index];
                
                %start_index=start_index+1;
            end
        end
        
       % %          if g==2 || g==5
       % % plot_kin1DATAset(newDATA,[6 10],[name,' group',num2str(g)],5)
       % % plot subject
       % %if isempty(find(newDATA(:,2)==14))
       % %   plot_kin1DATAset(newDATA,[5 newlabelsA 8 newlabelsPA],[name,' group',num2str(g)],5)
       % %else
      %  plot_kin1DATAset(newDATA,[5 newlabelsA newlabelsRA newlabelsPA],[name,' group',num2str(g)],5)
        
       % % end
        
       % %elseif g==3
       % %  plot_kin1DATAset(newDATA,[6 7 8],[name,' group',num2str(g)],5)
       % %end
        %         % Identify number of steps per epoch
        %
        newlabelsA=[6 11 12 13];
        newlabelsRA=[8 14];
        newlabelsPA=[10 16 17];
        
        A1=newDATA(find(newDATA(:,2)==newlabelsA(1)),:);
        nsteps(1,index)=size(A1,1);
        A2=newDATA(find(newDATA(:,2)==newlabelsA(2)),:);
        nsteps(2,index)=size(A2,1);
        A3=newDATA(find(newDATA(:,2)==newlabelsA(3)),:);
        nsteps(3,index)=size(A3,1);
        A4=newDATA(find(newDATA(:,2)==newlabelsA(4)),:);
        nsteps(4,index)=size(A4,1);
        
        RA1=newDATA(find(newDATA(:,2)==newlabelsRA(1)),:);
        nsteps(5,index)=size(RA1,1);
        RA2=newDATA(find(newDATA(:,2)==newlabelsRA(2)),:);
        nsteps(6,index)=size(RA2,1);
        
        PA1=newDATA(find(newDATA(:,2)==newlabelsPA(1)),:);
        nsteps(7,index)=size(PA1,1);
        PA2=newDATA(find(newDATA(:,2)==newlabelsPA(2)),:);
        nsteps(8,index)=size(PA2,1);
        PA3=newDATA(find(newDATA(:,2)==newlabelsPA(3)),:);
        nsteps(9,index)=size(PA3,1);
        
        %store newDATA matrix
        
        subjData{g,index}=newDATA;
        
        index=index+1;
        
        
    end
    
    ALLabels=[newlabelsA newlabelsRA newlabelsPA];
    
    % Compute group averages
    
    % equalize steps across subjects in a group
    nsteps(find(nsteps==0))=NaN;
    nsteps(find(nsteps<=120))=NaN;
    MinSteps(:,g)=min(nsteps,[],2);
    average=[];
    bias=[];
    index=1;
    % calculate bias per subject
    for s = subjects %subjets
        newDATA=subjData{g,index};
        baseindex=find(newDATA(:,2)==5);
        baseline=newDATA(baseindex(10:end),:);
        basesteps(index)=size(baseline,1);
        basesteps(index)=length(baseindex);
        
        bias=[bias; nanmean(baseline)];
        clear newDATA baseindex baseline
        index=index+1;
    end
    
    BaseStep=min(basesteps);
    % select minimum number of steps per subject
    for e=1:10
        
        index=1;
        
        
        
        for s = subjects %subjets
            clear temp newDATA baseindex baseline allb
            newDATA=subjData{g,index};
            
            % select epoch of interest
            
            if e==10
                selectedlabel=5;
                steps=basesteps(index);
                stepsRef=BaseStep;
            else
                selectedlabel=ALLabels(e);
                steps=nsteps(e,index);
                stepsRef=MinSteps(e,g);
            end
            
            temp=newDATA(find(newDATA(:,2)==selectedlabel),:);
            
            % remove baseline bias
            if ~isnan(steps)
                allb=repmat(bias(index,:),steps,1);
                temp=temp-allb;
                temp(:,[1 2])=newDATA(find(newDATA(:,2)==selectedlabel),[1 2]);
            end
            if isnan(steps)
                temp2(:,:,index)=NaN*ones(stepsRef,size(newDATA,2));
            elseif stepsRef<steps
                steps2remove=steps-stepsRef;
                temp2(:,:,index)=temp(1:end-steps2remove,:);
                
            elseif stepsRef==steps
                temp2(:,:,index)=temp;
                
            end
            
            
            index=index+1;
        end
        Data{e}=temp2;
        
        
        % Compute group averages
        temp3=nanmean(temp2,3);
        temp3(:,[1 2])=temp2(:,[1 2]);
        average=[average; temp3];
        
        AllDATA{g}=average;
        Avg_DATA{g,e}=temp3;
        
        
        
        clear temp2 temp temp3;
        % newDATA(find(newDATA(:,2)==newlabelsA),17);
        %temp=newDATA(find(newDATA(:,2)==newlabelsA(1)|newDATA(:,2)==newlabelsA(2)|newDATA(:,2)==newlabelsA(3)|newDATA(:,2)==newlabelsA(4)),[2 17]);
        
    end
    
    % plot group averages
    
    plot_kinDATAV1(average,[5 newlabelsA],['adapt before catch group',num2str(g)])
    plot_kinDATAV1(average,[5 newlabelsRA],['re-adapt after catch group',num2str(g)])
    plot_kinDATAV1(average,[5 newlabelsPA],['deadapt group',num2str(g)])
end





