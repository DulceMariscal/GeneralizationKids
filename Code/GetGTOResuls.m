%getting GTO results 

load('KIDS_DATA_BIN5_C_02-Aug-2011.mat')
OGPS=[];
OGCO=[];
OGTransSubj=[];

for g=1:6

eval(['Data=[ATransOG',num2str(g),'];'])
eval(['OGTrans',num2str(g),'=nanmean(Data);'])

eval(['OGTransSubj=[OGTransSubj;Data];'])

eval(['OGPS=[OGPS ','OGTrans',num2str(g),'(1)];']);
eval(['OGCO=[OGCO ','OGTrans',num2str(g),'(3)];']);

eval(['DataTM=[ATransTM',num2str(g),'];'])
eval(['OGTrans',num2str(g),'=nanmean(Data);'])

eval(['OGTransSubj=[OGTransSubj;Data];'])

eval(['OGPS=[OGPS ','OGTrans',num2str(g),'(1)];']);
eval(['OGCO=[OGCO ','OGTrans',num2str(g),'(3)];']);
end
