%Belts speed 

for g=1:6
    
     cd(['C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\Group' num2str(g)])
       ogflag=0; %OG data 1; TM data     
    
    b=[];
    files=what('./');
    fileList=files.mat;
    
    for l=1:length(fileList)
        a=find(size(fileList{l},2)>12);
        if a==1
            b(l)=1;
        else
            b(l)=0;
        end
    end
    
    fileList(b==1)=[];
    b=[];
    for i=1:length(fileList)
        
      subj=num2str(fileList{i}(4:end-4));
       
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
    
      BeltSpeed.R(i,g)=nanmean(TrialTM(16).Belt.R);
      BeltSpeed.L(i,g)=nanmean(TrialTM(16).Belt.L);
    
        
    end
    
end 
