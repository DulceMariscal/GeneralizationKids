%Scatter plots 
close all
clear all
clc

% cd('C:\Users\DUM5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\SMatrix\ConcSMatrixLineAll\FDR')

cd('/Users/dulcemariscal/Box/11_Research_Projects/KidsStudy/Data/Kids_paper/SMatrix/ConcSMatrixLineAll/FDR')
%You need to pick which set of data do you want to plot
% load('unBiasWithIndexContributions.mat') %SLA 
% load('CenterOScillationNobiasWithAdaptationIndex.mat') %CO

load('PS_NobiasWITHAdaptIndex.mat') %PS
% load('Controbutions_Nobias_Late-Early.mat') %SLA
% load('CenterOScillationNobias_Late-Early.mat') %CO
load('varianceGelsy')

% load('Age')

poster_colors;
colorOrder=[p_red; p_orange; p_fade_green; p_fade_blue; p_plum; p_green; p_blue; p_fade_red; p_lime; p_yellow; p_gray; p_black;[1 1 1]; [0 0.5 0.6]];     

%getting data 
epochs={'OGbase','TMbase','Pert','LateAdaptBeforeCatch','AdaptIndexBeforeCatch','Catch','LateAdaptReAdapt','AdaptIndex','OGafter','OGafterLate20','TMafter','TMafterLate'};
parameters={'spatialContribution','stepTimeContribution','velocityContribution','netContribution'};     
% parameters={'angleOfOscillationAsym'};
% parameters={'phaseShift'};

epochInteres={'AdaptIndexBeforeCatch','AdaptIndex','Catch','OGafter','TMafter','OGafterLate20','TMafterLate'};
% epochInteres={'OGafter','OGafterLate20','TMafterLate'};
paramVar=2;%SLA=1, PS=2, CO=3

for e=4%1:length(epochInteres) %epoch that you want to plot 
i= find(strcmp(epochInteres{e},epochs'));
    
for param=[2] %SLA=5, PS=2, CO=2
   
 figure 
for g=1:5

% scatter(Age(Age(:,2)==g),results.(epochs{i}).indiv(results.(epochs{i}).indiv(:,1)==g,param),[],colorOrder(g,:),'filled')
Age=variance(:,5); 
scatter(variance(variance(:,4)==g,paramVar),results.(epochs{i}).indiv(results.(epochs{i}).indiv(:,1)==g,param),[],colorOrder(g,:),'filled')

hold on 
end


if mean(results.(epochs{i}).indiv(results.(epochs{i}).indiv(:,1)==1,param))>mean(results.(epochs{i}).indiv(results.(epochs{i}).indiv(:,1)==5,param))

% LINEAR MODEL 
mdlLinear= fitlm(variance(:,paramVar),  results.(epochs{i}).indiv(1:35,param), 'linear')
plot(0:.0001:max(variance(:,paramVar)), (mdlLinear.predict([0:.0001:max(variance(:,paramVar))]')),'k')


%Linear Transformation 
% offset=abs(min(results.(epochs{i}).indiv(:,param)))+.0001;
% mdlTrasnform= fitlm(Age(:,1), log(results.(epochs{i}).indiv(:,param)+offset), 'linear');
% plot([1:.1:35], exp(mdlTrasnform.predict([1:.1:35]'))-offset,'g')


%NON LINEAR MODEL 
% beta2 = [0];
% modelfun = 'y ~ exp(-b1*x)';
% mdlnon3=fitnlm(Age(:,1), results.(epochs{i}).indiv(:,param),modelfun,beta2);
% plot([1:.1:35], (mdlnon3.predict([1:.1:35]')),'b')

beta2 = [0 mean(results.(epochs{i}).indiv(results.(epochs{i}).indiv(:,1)==1,param))];
modelfun = 'y ~b2*exp(-b1*x)';
mdlnon5=fitnlm(variance(:,paramVar), results.(epochs{i}).indiv(1:35,param),modelfun,beta2)
plot(0:.0001:max(variance(:,paramVar)), (mdlLinear.predict([0:.0001:max(variance(:,paramVar))]')),'--m')

% beta2 = [0 mean(variance(variance(:,4)==1,param))];
% modelfun = 'y ~b2*exp(-b1*x)';
% mdlnon5=fitnlm(variance(:,5), variance(:,param),modelfun,beta2)
% plot([1:.1:19], (mdlnon5.predict([1:.1:19]')),'--k')

% beta2 = [0 0];
% modelfun = 'y ~ exp(-b1*x+b2)';
% mdlnon2=fitnlm(Age(:,1), results.(epochs{i}).indiv(:,param),modelfun,beta2);
% plot([1:.1:35], (mdlnon2.predict([1:.1:35]')),'--m')
% 
% 
% beta0 = [0 0 0];
% modelfun = 'y ~ exp(-b1*x+b2)+b3';
% mdlnon=fitnlm(Age(:,1), results.(epochs{i}).indiv(:,param),modelfun,beta0);
% plot([1:.1:35], (mdlnon.predict([1:.1:35]')),'b')



% DeltaBIC=mdlnon5.ModelCriterion.BIC-mdlLinear.ModelCriterion.BIC;
DeltaBIC=mdlLinear.ModelCriterion.BIC-mdlnon5.ModelCriterion.BIC;
BF=exp(DeltaBIC/2);

groupslabels=strvcat('3-5','6-8','9-11','12-14','15-17',...
    ['Linear Model R^2=', num2str((mdlLinear.Rsquared.Ordinary)), '; RMSE=' num2str(mdlLinear.RMSE),' p-value=', num2str(coefTest(mdlLinear))],...
    ['NonLinear Model 2 (y=b2*exp(-b1*x)) R^2=', num2str((mdlnon5.Rsquared.Ordinary)), '; RMSE=' num2str(mdlnon5.RMSE)]);%,...
%     ['Linear Transformation R^2=', num2str((mdlTrasnform.Rsquared.Ordinary)), '; RMSE=' num2str(mdlTrasnform.RMSE),' p-value=', num2str(coefTest(mdlTrasnform))],...
%     ['NonLinear Model 1 (y=exp(-b1*x)) R^2=', num2str((mdlnon3.Rsquared.Ordinary)), '; RMSE=' num2str(mdlnon3.RMSE)],...
    

%     ['NonLinear Model 2 (y=exp(-b1*x+b2)) R^2=', num2str((mdlnon2.Rsquared.Ordinary))],...
%     ['NonLinear Model 3 (y=exp(-b1*x+b2)+b3) R^2=', num2str((mdlnon.Rsquared.Ordinary))]);
legend(groupslabels)


else   
    
%Linear model 
%display('Linear model')
% mdlLinear= fitlm(Age(:,1), results.(epochs{i}).indiv(:,param), 'linear');

mdlLinear= fitlm(variance(:,paramVar),  results.(epochs{i}).indiv(1:35,param), 'linear')
plot(0:.0001:max(variance(:,paramVar)), (mdlLinear.predict([0:.0001:max(variance(:,paramVar))]')),'k')


%Linear Transformation  
% steadystate=abs(mean(results.(epochs{i}).indiv(results.(epochs{i}).indiv(:,1)==6,param)))+abs(max(results.(epochs{i}).indiv(:,param)));
% mdlTrasnform= fitlm(Age(:,1), log(steadystate-results.(epochs{i}).indiv(:,param)), 'linear');
% plot([1:.1:35], steadystate-exp(mdlTrasnform.predict([1:.1:35]')),'g')  

%NON LINEAR MODEL 

%display('2 coeficientes model')
% beta0 = [mean(results.(epochs{i}).indiv(results.(epochs{i}).indiv(:,1)==6,param)) 0];
% modelfun = 'y ~ b1-exp(-b2*x)';
% mdl4=fitnlm(Age(:,1), results.(epochs{i}).indiv(:,param),modelfun,beta0);
% plot([1:.1:35], (mdl4.predict([1:.1:35]')),'Color',colorOrder(1,:))  

%display('2 coeficientes model')
offset=abs(min(results.(epochs{i}).indiv(1:35,param)))+.001;
% offset=0;
beta0 = [mean(results.(epochs{i}).indiv(results.(epochs{i}).indiv(:,1)==5,param))+offset 0];
% beta0 = [0 0];
modelfun = 'y ~ b1-b1*exp(-b2*x)';
data=results.(epochs{i}).indiv(1:35,param)+offset;
mdl3=fitnlm(variance(:,paramVar), data,modelfun,beta0)
% mdl3=fitnlm(variance(:,5), data,modelfun,beta0)
plot(0:.0001:max(variance(:,paramVar)), (mdlLinear.predict([0:.0001:max(variance(:,paramVar))]')),'--m')
% plot([1:.1:19], (mdl3.predict([1:.1:19]'))-offset,'--k')  

%display('3 Coeficients model')
% beta0 = [mean(results.(epochs{i}).indiv(results.(epochs{i}).indiv(:,1)==6,param)) 0 0];
% modelfun = 'y ~ b1 -b3*exp(-b2*x)';
% mdlNon=fitnlm(Age(:,1), results.(epochs{i}).indiv(:,param),modelfun,beta0);
% plot([1:.1:35], (mdlNon.predict([1:.1:35]')),'b')

% display('3 coeficientes model')
% beta0 = [0 0 0];
% modelfun = 'y ~ b1-exp(-b2*x+b3)';
% mdl2=fitnlm(Age(:,1), results.(epochs{i}).indiv(:,param),modelfun,beta0);
% plot([1:.1:35], (mdl2.predict([1:.1:35]')),'--m')


% DeltaBIC=mdl3.ModelCriterion.BIC-mdlLinear.ModelCriterion.BIC;
DeltaBIC=mdlLinear.ModelCriterion.BIC-mdl3.ModelCriterion.BIC;
BF=exp(DeltaBIC/2);

groupslabels=strvcat('3-5','6-8','9-11','12-14','15-17',...
    ['Linear Model R^2=', num2str(mdlLinear.Rsquared.Ordinary), '; RMSE=' num2str(mdlLinear.RMSE),' p-value=', num2str(coefTest(mdlLinear))],...
     ['NonLinear Model (', modelfun ,'); R^2=', num2str(mdl3.Rsquared.Ordinary), '; RMSE=' num2str(mdl3.RMSE)]);
%     ['Linear Transformation R^2=', num2str((mdlTrasnform.Rsquared.Ordinary)), '; RMSE=' num2str(mdlTrasnform.RMSE),' p-value=', num2str(coefTest(mdlTrasnform))],...
%     ['NonLinear Model 1 (y=b1-exp(-b2*x)) R^2=', num2str(mdl4.Rsquared.Ordinary), '; RMSE=' num2str(mdl4.RMSE)],...
   
%     ['NonLinear Model 3 (y=b1-b3*exp(-b2*x)) R^2=', num2str(mdlNon.Rsquared.Ordinary), '; RMSE=' num2str(mdlNon.RMSE)]);%,...
%     ['NonLinear Model 4 (y=b1-exp(-b2*x+b3)) R^2=', num2str(mdl2.Rsquared.Ordinary)]);
legend(groupslabels)

end


% title(parameters{param-1})
title([parameters{param-1}, '        \Delta=', num2str(DeltaBIC), '     BF=', num2str(BF)])
ylabel(epochInteres{e})
end
end

