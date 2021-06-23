% % Scatter plots 
close all
clear all
clc

% cd('C:\Users\dum5\OneDrive - University of Pittsburgh\KidsStudy\Data\Kids_paper\SMatrix\ConcSMatrixLineAll\FDR')
cd('/Users/dulcemariscal/Box/11_Research_Projects/KidsStudy/Data/Kids_paper/SMatrix/ConcSMatrixLineAll/FDR')
%You need to pick which set of data do you want to plot
% load('unBiasWithIndexContributions.mat') %SLA 
% load('CenterOScillationNobiasWithAdaptationIndex.mat') %CO

% load('PS_NobiasWITHAdaptIndex.mat') %PS
% load('Contributions_Nobias_Late-Early.mat') %SLA
load('CenterOScillationNobias_Late-Early.mat') %CO

load('Age')

%Without outlier on phase shift tm after late 
% load('PS_NobiasWO_LN0375.mat')
% load('Age_WOLN0375.mat')


poster_colors;
colorOrder=[p_red; p_orange; p_fade_green; p_fade_blue; p_plum; p_green; p_blue; p_fade_red; p_lime; p_yellow; p_gray; p_black;[1 1 1]; [0 0.5 0.6]];     

%getting data 
epochs={'OGbase','TMbase','Pert','LateAdaptBeforeCatch','AdaptIndexBeforeCatch','Catch','LateAdaptReAdapt','AdaptIndex','OGafter','OGafterLate20','TMafter','TMafterLate'};
% parameters={'spatialContribution','stepTimeContribution','velocityContribution','netContribution'};     
parameters={'angleOfOscillationAsym'};
% parameters={'phaseShift'};

epochInteres={'AdaptIndexBeforeCatch','AdaptIndex','Catch','OGafter','TMafter','OGafterLate20','TMafterLate','Pert'};
% epochInteres={'OGafter','OGafterLate20','TMafterLate'};

% xepoach={'Catch'};
% xepoach={'OGafter'};

for e=8%1:length(epochInteres) %epoch that you want to plot 
i= find(strcmp(epochInteres{e},epochs'));
% w=find(strcmp(xepoach{1},epochs'));
    
for param=[2] %SLA=5, PS=2, CO=2
   
 figure 
for g=1:6

scatter(Age(Age(:,2)==g),results.(epochs{i}).indiv(results.(epochs{i}).indiv(:,1)==g,param),[],colorOrder(g,:),'filled')
% scatter(results.(epochs{w}).indiv(results.(epochs{w}).indiv(:,1)==g,param),results.(epochs{i}).indiv(results.(epochs{i}).indiv(:,1)==g,param),[],colorOrder(g,:),'filled')

hold on 
end


if mean(results.(epochs{i}).indiv(results.(epochs{i}).indiv(:,1)==1,param))>mean(results.(epochs{i}).indiv(results.(epochs{i}).indiv(:,1)==6,param))

% LINEAR MODEL 
mdlLinear= fitlm(Age(:,1), results.(epochs{i}).indiv(:,param), 'linear')
 plot([1:.1:35], (mdlLinear.predict([1:.1:35]')),'k')
% mdlLinear= fitlm(results.(epochs{w}).indiv(:,param), results.(epochs{i}).indiv(:,param), 'linear');
% plot(min(results.(epochs{w}).indiv(:,param)):.0001:max(results.(epochs{w}).indiv(:,param)), (mdlLinear.predict([min(results.(epochs{w}).indiv(:,param)):.0001:max(results.(epochs{w}).indiv(:,param))]')),'k')
%  plot([1:.1:35], (mdlLinear.predict([1:.1:35]')),'k')


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
mdlnon5=fitnlm(Age(:,1), results.(epochs{i}).indiv(:,param),modelfun,beta2)
% mdlnon5=fitnlm(results.(epochs{w}).indiv(:,param), results.(epochs{i}).indiv(:,param),modelfun,beta2)
% plot(min(results.(epochs{w}).indiv(:,param)):.0001:max(results.(epochs{w}).indiv(:,param)), (mdlnon5.predict([min(results.(epochs{w}).indiv(:,param)):.0001:max(results.(epochs{w}).indiv(:,param))]')),'--k')
plot([1:.1:35], (mdlnon5.predict([1:.1:35]')),'--k') 


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

groupslabels=strvcat('3-5','6-8','9-11','12-14','15-17','>18',...
    ['Linear Model R^2=', num2str((mdlLinear.Rsquared.Ordinary)), '; RMSE=' num2str(mdlLinear.RMSE),' p-value=', num2str(coefTest(mdlLinear))],...
    ['NonLinear Model 2 (y=b2*exp(-b1*x)) R^2=', num2str((mdlnon5.Rsquared.Ordinary)), '; RMSE=' num2str(mdlnon5.RMSE)]);%,...
%     ['Linear Transformation R^2=', num2str((mdlTrasnform.Rsquared.Ordinary)), '; RMSE=' num2str(mdlTrasnform.RMSE),' p-value=', num2str(coefTest(mdlTrasnform))],...
%     ['NonLinear Model 1 (y=exp(-b1*x)) R^2=', num2str((mdlnon3.Rsquared.Ordinary)), '; RMSE=' num2str(mdlnon3.RMSE)],...
    

%     ['NonLinear Model 2 (y=exp(-b1*x+b2)) R^2=', num2str((mdlnon2.Rsquared.Ordinary))],...
%     ['NonLinear Model 3 (y=exp(-b1*x+b2)+b3) R^2=', num2str((mdlnon.Rsquared.Ordinary))]);
legend(groupslabels)
text(30,max((mdlnon5.predict([1:.1:35]'))),'y=b2*e^{-b1*x})','FontSize',14)

else   
    
%Linear model 
%display('Linear model')
mdlLinear= fitlm(Age(:,1), results.(epochs{i}).indiv(:,param), 'linear')
% mdlLinear= fitlm(results.(epochs{w}).indiv(:,param), results.(epochs{i}).indiv(:,param), 'linear');
% plot(min(results.(epochs{w}).indiv(:,param)):.0001:max(results.(epochs{w}).indiv(:,param)), (mdlLinear.predict([min(results.(epochs{w}).indiv(:,param)):.0001:max(results.(epochs{w}).indiv(:,param))]')),'k')
plot([1:.1:35], (mdlLinear.predict([1:.1:35]')),'k')


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
offset=(min(results.(epochs{i}).indiv(:,param)));
if offset>0
  offset=-offset+.001;
%   offset=offset+.001;
else
    offset=-offset+.001;
end
% offset=0; 
% beta0 = [mean(results.(epochs{i}).indiv(results.(epochs{i}).indiv(:,1)==6,param))+offset 0];
 beta0 = [max(results.(epochs{i}).indiv(:,param))+offset 0];
% beta0 = [0 0];
modelfun = 'y ~ b1-b1*exp(-b2*x)';
data=results.(epochs{i}).indiv(:,param)+offset;
mdl3=fitnlm(Age(:,1), data,modelfun,beta0)

% mdl3=fitnlm(results.(epochs{w}).indiv(:,param), data,modelfun,beta0)
% plot(min(results.(epochs{w}).indiv(:,param)):.0001:max(results.(epochs{w}).indiv(:,param)), (mdl3.predict([min(results.(epochs{w}).indiv(:,param)):.0001:max(results.(epochs{w}).indiv(:,param))]')),'--k')
plot([1:.1:35], (mdl3.predict([1:.1:35]'))-offset,'--k')  



% beta2 = [0 mean(results.(epochs{i}).indiv(results.(epochs{i}).indiv(:,1)==1,param))];
% beta2 = [0 min(results.(epochs{i}).indiv(:,param))];
% modelfun = 'y ~b2*exp(-b1*x)';
% mdlnon5=fitnlm(Age(:,1), results.(epochs{i}).indiv(:,param),modelfun,beta2)
% mdlnon5=fitnlm(results.(epochs{w}).indiv(:,param), results.(epochs{i}).indiv(:,param),modelfun,beta2)
% plot(min(results.(epochs{w}).indiv(:,param)):.0001:max(results.(epochs{w}).indiv(:,param)), (mdlnon5.predict([min(results.(epochs{w}).indiv(:,param)):.0001:max(results.(epochs{w}).indiv(:,param))]')),'--m')


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

groupslabels=strvcat('3-5','6-8','9-11','12-14','15-17','>18',...
    ['Linear Model R^2=', num2str(mdlLinear.Rsquared.Ordinary), '; RMSE=' num2str(mdlLinear.RMSE),' p-value=', num2str(coefTest(mdlLinear))],...
     ['NonLinear Model (', modelfun ,'); R^2=', num2str(mdl3.Rsquared.Ordinary), '; RMSE=' num2str(mdl3.RMSE)]);%,...
%        ['NonLinear Model 2 (y=b2*exp(-b1*x)) R^2=', num2str((mdlnon5.Rsquared.Ordinary)), '; RMSE=' num2str(mdlnon5.RMSE)]);
%     ['Linear Transformation R^2=', num2str((mdlTrasnform.Rsquared.Ordinary)), '; RMSE=' num2str(mdlTrasnform.RMSE),' p-value=', num2str(coefTest(mdlTrasnform))],...
%     ['NonLinear Model 1 (y=b1-exp(-b2*x)) R^2=', num2str(mdl4.Rsquared.Ordinary), '; RMSE=' num2str(mdl4.RMSE)],...
%     ['NonLinear Model 3 (y=b1-b3*exp(-b2*x)) R^2=', num2str(mdlNon.Rsquared.Ordinary), '; RMSE=' num2str(mdlNon.RMSE)]);%,...
%     ['NonLinear Model 4 (y=b1-exp(-b2*x+b3)) R^2=', num2str(mdl2.Rsquared.Ordinary)]);
legend(groupslabels)
% text(30,max(data-offset),'y=b1-b1*e^{-b2*x}','FontSize',14)
end


title([parameters{param-1}, '        \Delta=', num2str(DeltaBIC), '     BF=', num2str(BF)])
ylabel(epochInteres{e})
% xlabel(xepoach{1})
% saveas(gcf,[epochInteres{e} parameters{param-1}],'fig')

end
end

