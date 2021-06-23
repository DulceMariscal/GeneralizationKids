%ttest Kids data 

%Across epochs 
%Bias Data
clear all
cd('C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\SMatrix\ConcSMatrixLineAll\FDR')

load('BiasResults.mat')
% load('BiasResults_WOLN0331.mat')

for g=1:6
    Groups=(['Group' num2str(g)]); 
   
    %Get Data OG 
    baselineOG.(Groups)=results.OGbase.indiv((results.OGbase.indiv(:,1)==g),2:end);
    EarlyAFOG.(Groups)=results.OGafter.indiv((results.OGafter.indiv(:,1)==g),2:end);
    LateAFOG.(Groups)= results.OGafterLate20.indiv(( results.OGafterLate20.indiv(:,1)==g),2:end);
    
    %Get data TM
    
    baselineTM.(Groups)=results.TMbase.indiv((results.TMbase.indiv(:,1)==g),2:end);
    Pert.(Groups)=results.Pert.indiv((results.Pert.indiv(:,1)==g),2:end);
    LateAdaptBeforeCatch.(Groups)=results.LateAdaptBeforeCatch.indiv((results.LateAdaptBeforeCatch.indiv(:,1)==g),2:end);
    Catch.(Groups)=results.Catch.indiv((results.Catch.indiv(:,1)==g),2:end);
    LateAdaptReAdapt.(Groups)=results.LateAdaptReAdapt.indiv((results.LateAdaptReAdapt.indiv(:,1)==g),2:end);
    TMafter.(Groups)=results.TMafter.indiv((results.TMafter.indiv(:,1)==g),2:end);
    
    
end
%     baseline.Group5=[ baseline.Group5; baseline.Group6];
%     EarlyAF.Group5=[EarlyAF.Group5; EarlyAF.Group6];
%     LateAF.Group5=[LateAF.Group5; LateAF.Group6];  

for g=1:6
    Groups=(['Group' num2str(g)]); 
    %OG t-test
    [hbaseEarlyAF(g,:),pbaseEarlyAF(g,:)]=ttest2(baselineOG.(Groups),EarlyAFOG.(Groups));
    [hbaseLateAF(g,:),pbaseLateAF(g,:)]=ttest2(baselineOG.(Groups),LateAFOG.(Groups));
    
    %TM t-test
    [hTMbaseCatch(g,:),pTMbaseCatch(g,:)]=ttest2(baselineTM.(Groups),Catch.(Groups));
    [hTMbaseAfter(g,:),pTMbaseAfter(g,:)]=ttest2(baselineTM.(Groups),TMafter.(Groups));
    [hPertLA(g,:),pPertLA(g,:)]=ttest2(Pert.(Groups),LateAdaptBeforeCatch.(Groups));
    [hPertLR(g,:),pPertLR(g,:)]=ttest2(Pert.(Groups),LateAdaptReAdapt.(Groups));
end 
%OG
group=[1:6]';
groupVector=[group; group; group; group; group; group; group; group]; 
pbaseEarlyAF=[pbaseEarlyAF(:,1) 1*ones(length(pbaseEarlyAF(:,1)),1) ;pbaseEarlyAF(:,2)  2*ones(length(pbaseEarlyAF(:,1)),1) ;pbaseEarlyAF(:,3)  3*ones(length(pbaseEarlyAF(:,1)),1) ; pbaseEarlyAF(:,4) 4*ones(length(pbaseEarlyAF(:,1)),1) ];
pbaseLateAF=[pbaseLateAF(:,1) 1*ones(length(pbaseLateAF(:,1)),1);pbaseLateAF(:,2) 2*ones(length(pbaseLateAF(:,1)),1);pbaseLateAF(:,3) 3*ones(length(pbaseLateAF(:,1)),1);pbaseLateAF(:,4) 4*ones(length(pbaseLateAF(:,1)),1)];
pOG=[pbaseEarlyAF 1*ones(length(pbaseEarlyAF),1);pbaseLateAF 2*ones(length(pbaseEarlyAF),1)];

[h,pThresholdOG, i1] = BenjaminiHochberg(pOG(:,1),0.05);
h=[h pOG(:,2) pOG(:,3) groupVector];
SignificantsOG=h(find(h(:,1)==1),:);
SignificantsLabels={'Sig','parameter','condition','group'};
display(['condition=1 Base-EarlyAF'; 'condition=2 Early-LateAF'])
display(['pameters: 1=spatial,2=temporal,3=velocity,4=SLA'])

%TM

pTMbaseCatch=[pTMbaseCatch(:,1) 1*ones(length(pTMbaseCatch(:,1)),1);pTMbaseCatch(:,2) 2*ones(length(pTMbaseCatch(:,1)),1);pTMbaseCatch(:,3) 3*ones(length(pTMbaseCatch(:,1)),1); pTMbaseCatch(:,4) 4*ones(length(pTMbaseCatch(:,1)),1) ];
pTMbaseAfter=[pTMbaseAfter(:,1) 1*ones(length(pTMbaseAfter(:,1)),1);pTMbaseAfter(:,2) 2*ones(length(pTMbaseAfter(:,1)),1);pTMbaseAfter(:,3) 3*ones(length(pTMbaseAfter(:,1)),1); pTMbaseAfter(:,4) 4*ones(length(pTMbaseAfter(:,1)),1) ];
pPertLA=[pPertLA(:,1) 1*ones(length(pPertLA(:,1)),1);pPertLA(:,2) 2*ones(length(pPertLA(:,1)),1);pPertLA(:,3) 3*ones(length(pPertLA(:,1)),1);pPertLA(:,4) 4*ones(length(pPertLA(:,1)),1) ];
pPertLR=[pPertLR(:,1) 1*ones(length(pPertLR(:,1)),1);pPertLR(:,2) 2*ones(length(pPertLR(:,1)),1);pPertLR(:,3) 3*ones(length(pPertLR(:,1)),1);pPertLR(:,4) 4*ones(length(pPertLR(:,1)),1) ];
pTM=[pTMbaseCatch 1*ones(length(pTMbaseCatch),1);pTMbaseAfter 2*ones(length(pTMbaseAfter),1); pPertLA 3*ones(length(pTMbaseAfter),1); pPertLR 4*ones(length(pTMbaseAfter),1) ];
[hTM,pThresholdTM, i1TM] = BenjaminiHochberg(pTM(:,1),0.05);
hTM=[hTM pTM(:,2) pTM(:,3) [groupVector;groupVector]];
SignificantsTM=hTM(find(hTM(:,1)==1),:);
SignificantsLabels={'Sig','parameter','condition','group'};
display(['condition=1 TMbase-Catch'; 'condition=2 TMbase-After';'condition=3 Pert-LatAdpt'; 'condition=4 Pert-ReAdapt'])


%%
%Unbias Data
%Between groups
clear all
 load('aUnBiasResults.mat')
%  load('aUnBiasResults_WOLN0331.mat')
 
 group=[];
 
for g=1:6
    Groups=(['Group' num2str(g)]);    
    EarlyAfter.(Groups)=results.OGafter.indiv(results.OGafter.indiv==g,2:end);
    LateAfter.(Groups)=results.OGafterLate20.indiv(results.OGafter.indiv==g,2:end);
    
    %TM get data
    Pert.(Groups)=results.Pert.indiv((results.Pert.indiv(:,1)==g),2:end);
    LateAdaptBeforeCatch.(Groups)=results.LateAdaptBeforeCatch.indiv((results.LateAdaptBeforeCatch.indiv(:,1)==g),2:end);
    Catch.(Groups)=results.Catch.indiv((results.Catch.indiv(:,1)==g),2:end);
    LateAdaptReAdapt.(Groups)=results.LateAdaptReAdapt.indiv((results.LateAdaptReAdapt.indiv(:,1)==g),2:end);
    TMafter.(Groups)=results.TMafter.indiv((results.TMafter.indiv(:,1)==g),2:end);
    
end 

%     EarlyAfter.Group5=[EarlyAfter.Group5; EarlyAfter.Group6];
%     LateAfter.Group5=[LateAfter.Group5;LateAfter.Group6];  


for g=1:6
    
    [hEarlyAfter1(g,:),pEarlyAfter1(g,:)]=ttest2(EarlyAfter.Group1,EarlyAfter.(['Group' num2str(g)]));
    [hEarlyAfter2(g,:),pEarlyAfter2(g,:)]=ttest2(EarlyAfter.Group2,EarlyAfter.(['Group' num2str(g)]));
    [hEarlyAfter3(g,:),pEarlyAfter3(g,:)]=ttest2(EarlyAfter.Group3,EarlyAfter.(['Group' num2str(g)]));
    [hEarlyAfter4(g,:),pEarlyAfter4(g,:)]=ttest2(EarlyAfter.Group4,EarlyAfter.(['Group' num2str(g)]));
    [hEarlyAfter5(g,:),pEarlyAfter5(g,:)]=ttest2(EarlyAfter.Group5,EarlyAfter.(['Group' num2str(g)]));
    
    [hLateAfter1(g,:),pLateAfter1(g,:)]=ttest2(LateAfter.Group1,LateAfter.(['Group' num2str(g)]));
    [hLateAfter2(g,:),pLateAfter2(g,:)]=ttest2(LateAfter.Group2,LateAfter.(['Group' num2str(g)]));
    [hLateAfter3(g,:),pLateAfter3(g,:)]=ttest2(LateAfter.Group3,LateAfter.(['Group' num2str(g)]));
    [hLateAfter4(g,:),pLateAfter4(g,:)]=ttest2(LateAfter.Group4,LateAfter.(['Group' num2str(g)]));
    [hLateAfter5(g,:),pLateAfter5(g,:)]=ttest2(LateAfter.Group5,LateAfter.(['Group' num2str(g)]));
    
    %TM t-test
     [hPert1(g,:),pPert1(g,:)]=ttest2(Pert.Group1,Pert.(['Group' num2str(g)]));
     [hPert2(g,:),pPert2(g,:)]=ttest2(Pert.Group2,Pert.(['Group' num2str(g)]));
     [hPert3(g,:),pPert3(g,:)]=ttest2(Pert.Group3,Pert.(['Group' num2str(g)]));
     [hPert4(g,:),pPert4(g,:)]=ttest2(Pert.Group4,Pert.(['Group' num2str(g)]));
     [hPert5(g,:),pPert5(g,:)]=ttest2(Pert.Group5,Pert.(['Group' num2str(g)]));
     
     [hLateAdaptBeforeCatch1(g,:),pLateAdaptBeforeCatch1(g,:)]=ttest2(LateAdaptBeforeCatch.Group1,LateAdaptBeforeCatch.(['Group' num2str(g)]));
     [hLateAdaptBeforeCatch2(g,:),pLateAdaptBeforeCatch2(g,:)]=ttest2(LateAdaptBeforeCatch.Group2,LateAdaptBeforeCatch.(['Group' num2str(g)]));
     [hLateAdaptBeforeCatch3(g,:),pLateAdaptBeforeCatch3(g,:)]=ttest2(LateAdaptBeforeCatch.Group3,LateAdaptBeforeCatch.(['Group' num2str(g)]));
     [hLateAdaptBeforeCatch4(g,:),pLateAdaptBeforeCatch4(g,:)]=ttest2(LateAdaptBeforeCatch.Group4,LateAdaptBeforeCatch.(['Group' num2str(g)]));
     [hLateAdaptBeforeCatch5(g,:),pLateAdaptBeforeCatch5(g,:)]=ttest2(LateAdaptBeforeCatch.Group5,LateAdaptBeforeCatch.(['Group' num2str(g)]));
     
     [hCatch1(g,:),pCatch1(g,:)]=ttest2(Catch.Group1,Catch.(['Group' num2str(g)]));
     [hCatch2(g,:),pCatch2(g,:)]=ttest2(Catch.Group2,Catch.(['Group' num2str(g)]));
     [hCatch3(g,:),pCatch3(g,:)]=ttest2(Catch.Group3,Catch.(['Group' num2str(g)]));
     [hCatch4(g,:),pCatch4(g,:)]=ttest2(Catch.Group4,Catch.(['Group' num2str(g)]));
     [hCatch5(g,:),pCatch5(g,:)]=ttest2(Catch.Group5,Catch.(['Group' num2str(g)]));
     
     [hLateAdaptReAdapt1(g,:),pLateAdaptReAdapt1(g,:)]=ttest2(LateAdaptReAdapt.Group1,LateAdaptReAdapt.(['Group' num2str(g)]));
     [hLateAdaptReAdapt2(g,:),pLateAdaptReAdapt2(g,:)]=ttest2(LateAdaptReAdapt.Group2,LateAdaptReAdapt.(['Group' num2str(g)]));
     [hLateAdaptReAdapt3(g,:),pLateAdaptReAdapt3(g,:)]=ttest2(LateAdaptReAdapt.Group3,LateAdaptReAdapt.(['Group' num2str(g)]));
     [hLateAdaptReAdapt4(g,:),pLateAdaptReAdapt4(g,:)]=ttest2(LateAdaptReAdapt.Group4,LateAdaptReAdapt.(['Group' num2str(g)]));
     [hLateAdaptReAdapt5(g,:),pLateAdaptReAdapt5(g,:)]=ttest2(LateAdaptReAdapt.Group5,LateAdaptReAdapt.(['Group' num2str(g)]));
     
      [hTMafter1(g,:),pTMafter1(g,:)]=ttest2(TMafter.Group1,TMafter.(['Group' num2str(g)]));
      [hTMafter2(g,:),pTMafter2(g,:)]=ttest2(TMafter.Group2,TMafter.(['Group' num2str(g)]));
      [hTMafter3(g,:),pTMafter3(g,:)]=ttest2(TMafter.Group3,TMafter.(['Group' num2str(g)]));
      [hTMafter4(g,:),pTMafter4(g,:)]=ttest2(TMafter.Group4,TMafter.(['Group' num2str(g)]));
      [hTMafter5(g,:),pTMafter5(g,:)]=ttest2(TMafter.Group5,TMafter.(['Group' num2str(g)]));
     
    
end
%OG 

    pEarly=[pEarlyAfter1(2:end,:);pEarlyAfter2(3:end,:);pEarlyAfter3(4:end,:);pEarlyAfter4(5:end,:);pEarlyAfter5(6:end,:)]; 
    pEarly=[pEarly(:,1) 1*ones(length(pEarly(:,1)),1); pEarly(:,2) 2*ones(length(pEarly(:,1)),1); pEarly(:,3) 3*ones(length(pEarly(:,1)),1); pEarly(:,4) 4*ones(length(pEarly(:,1)),1)];
    pLate=[pLateAfter1(2:end,:);pLateAfter2(3:end,:);pLateAfter3(4:end,:);pLateAfter4(5:end,:);pLateAfter5(6:end,:)];
    pLate=[pLate(:,1) 1*ones(length(pLate(:,1)),1);pLate(:,2) 2*ones(length(pLate(:,1)),1);pLate(:,3) 3*ones(length(pLate(:,1)),1);pLate(:,4) 4*ones(length(pLate(:,1)),1)];
    pAfterEffects=[pEarly 1*ones(length(pEarly),1)];%; pLate 2*ones(length(pEarly),1)];
    comparison=[1:15 1:15 1:15 1:15];
    comparison=[comparison]';
    
     [hAfter,pThresholdAfter,iAfter] = BenjaminiHochberg(pAfterEffects(:,1),0.05);
     hafter=[hAfter pAfterEffects(:,2) pAfterEffects(:,3) comparison];
     SignificantsLabels={'Sig','parameter','condition','comparison'};
     SignificantsAfter=hafter(find(hafter(:,1)==1),:);
     display(['1=group1 vs group2';'2=group1 vs group3';'3=group1 vs group4';'4=group1 vs group5';'5=group2 vs group3';'6=group2 vs group4';'7=group2 vs group5';'8=group3 vs group4';'9=group3 vs group5';'10=group4 v group5'])
     
%TM 
    pPert=[pPert1(2:end,:);pPert2(3:end,:);pPert3(4:end,:);pPert4(5:end,:);pPert5(6:end,:)]; 
    pPert=[pPert(:,1) 1*ones(length(pPert(:,1)),1); pPert(:,2) 2*ones(length(pPert(:,1)),1); pPert(:,3) 3*ones(length(pPert(:,1)),1); pPert(:,4) 4*ones(length(pPert(:,1)),1)];
    
    pLateAdaptBeforeCatch=[pLateAdaptBeforeCatch1(2:end,:);pLateAdaptBeforeCatch2(3:end,:);pLateAdaptBeforeCatch3(4:end,:);pLateAdaptBeforeCatch4(5:end,:);pLateAdaptBeforeCatch5(6:end,:)]; 
    pLateAdaptBeforeCatch=[pLateAdaptBeforeCatch(:,1) 1*ones(length(pLateAdaptBeforeCatch(:,1)),1); pLateAdaptBeforeCatch(:,2) 2*ones(length(pLateAdaptBeforeCatch(:,1)),1); pLateAdaptBeforeCatch(:,3) 3*ones(length(pLateAdaptBeforeCatch(:,1)),1); pLateAdaptBeforeCatch(:,4) 4*ones(length(pLateAdaptBeforeCatch(:,1)),1)];
    
    pCatch=[pCatch1(2:end,:);pCatch2(3:end,:);pCatch3(4:end,:);pCatch4(5:end,:);pCatch5(6:end,:)]; 
    pCatch=[pCatch(:,1) 1*ones(length(pCatch(:,1)),1); pCatch(:,2) 2*ones(length(pCatch(:,1)),1); pCatch(:,3) 3*ones(length(pCatch(:,1)),1); pCatch(:,4) 4*ones(length(pCatch(:,1)),1)]; 
    
    
    pLateAdaptReAdapt=[pLateAdaptReAdapt1(2:end,:);pLateAdaptReAdapt2(3:end,:);pLateAdaptReAdapt3(4:end,:);pLateAdaptReAdapt4(5:end,:);pLateAdaptReAdapt5(6:end,:)]; 
    pLateAdaptReAdapt=[pLateAdaptReAdapt(:,1) 1*ones(length(pLateAdaptReAdapt(:,1)),1); pLateAdaptReAdapt(:,2) 2*ones(length(pLateAdaptReAdapt(:,1)),1); pLateAdaptReAdapt(:,3) 3*ones(length(pLateAdaptReAdapt(:,1)),1); pLateAdaptReAdapt(:,4) 4*ones(length(pLateAdaptReAdapt(:,1)),1)];
    
    pTMafter=[pTMafter1(2:end,:);pTMafter2(3:end,:);pTMafter3(4:end,:);pTMafter4(5:end,:);pTMafter5(6:end,:)]; 
    pTMafter=[pTMafter(:,1) 1*ones(length(pTMafter(:,1)),1); pTMafter(:,2) 2*ones(length(pTMafter(:,1)),1); pTMafter(:,3) 3*ones(length(pTMafter(:,1)),1); pTMafter(:,4) 4*ones(length(pTMafter(:,1)),1)];
    
    pTMComp=[pPert 1*ones(length(pPert),1); pLateAdaptBeforeCatch  2*ones(length(pLateAdaptBeforeCatch),1);pCatch  3*ones(length(pCatch),1) ; pLateAdaptReAdapt 4*ones(length(pLateAdaptReAdapt),1); pTMafter 5*ones(length(pTMafter),1) ];
    
    comparison=[1:15 1:15 1:15 1:15];
    comparison=[comparison comparison comparison comparison comparison]';
    
    [hTMAfter,pThresholdTMAfter,iTMAfter] = BenjaminiHochberg(pTMComp(:,1),0.05);
    
    hTMafter=[hTMAfter pTMComp(:,2) pTMComp(:,3) comparison];
    SignificantsTM=hTMafter(find(hTMafter(:,1)==1),:);
    display(['1=group1 vs group2';'2=group1 vs group3';'3=group1 vs group4';'4=group1 vs group5';'5=group1 vs group6';'6=group2 vs group3';'7=group2 vs group4';'8=group2 vs group5';'9=group2 vs group6';'10=group3 v group4'])
    display(['11=group3 v group5';'12=group3 v group6';'13=group4 v group5';'14=group4 v group6';'15=group5 v group6'])
     
    
    
    
    
    
    
    
   
    
    





