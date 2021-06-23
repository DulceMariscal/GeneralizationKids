function TheData = calcadaptparam(refleg);
%TREADMILLCALC_TM  Calculates treadmill walking parameters.
%   TREADMILLCALC_TM(REFLEG) should be ran inside TVCEL, or after
%   'Trial','b','Events','ConditionList' are imported using SPLITBELTLOAD.
%   It returns THEDATA where stride-by-stride parameters are grouped in
%   columns:
%       1.  trial no.
%       2.  condition
%       3. phase shift
%       4. double support time difference
%       5. step length ratio
%
% O July 22nd 2010 added an offset of 90deg to limb angles to prevent alpha ratios to blow up when the limb was close to a vertical orientation

% global b Trial Events FootEvents

global TrialTM TrialOG bOG bTM ConditionListTM ConditionListOG EventsOG EventsTM
global Trial b ConditionList Events

Trial=TrialOG;
b=bOG;
ConditionList=ConditionListOG;
Events=EventsOG;


if strcmpi(refleg,'R')
    s = 'R';
    f = 'L';
    Rleg=1;
    Lleg=0;
elseif strcmpi(refleg,'L')
    s = 'L';
    f = 'R';
    Lleg=1;
    Rleg=0;
end

% Find FootEvents
FootEvents = getallFootEvents(1,Rleg,Lleg); % for all files processed after Sept12 2009

% Remove bad strides
temp=diff(FootEvents,1,2);
thresh=100;
FootEvents(find( (abs(temp(:,4))>thresh) | (abs(temp(:,5))>thresh) | (abs(temp(:,6))>thresh) | (abs(temp(:,7))>thresh) | (abs(temp(:,8))>thresh) ),:)=[];
temp=[];
temp=isnan(FootEvents);
[rr,cc]=find(temp);
rows=unique(rr);
FootEvents(rows,:)=[];

%calculate timing parameters
for i = 1:size(FootEvents,1)
    trl = FootEvents(i,1);

    if Lleg % if left leg is the slow leg

        leg = FootEvents(i,3);
        if leg %If leg=1 -> aligned to slow leg's heel strike
            shs = FootEvents(i,4);
            fto = FootEvents(i,5);
            fhs = FootEvents(i,6);
            sto = FootEvents(i,7);
            shs2 = FootEvents(i,8);
            fto2 = FootEvents(i,9);
            %stride time
            slowstridetime(i) = FootEvents(i,8) - FootEvents(i,4); %shs2-shs1
            faststridetime(i) = FootEvents(i,9) - FootEvents(i,5); %fto2-fto1
            %stance time
            slowstancetime(i) = FootEvents(i,7) - FootEvents(i,4); %sto1-shs1
            faststancetime(i) = FootEvents(i,9) - FootEvents(i,6); %fto1-fhs1
            %step time (from heel strike to heel strike= stance phase - double support)
            slowsteptime(i) = FootEvents(i,6) - FootEvents(i,4); %fhs1-shs1
            faststeptime(i) = FootEvents(i,8) - FootEvents(i,6); %fhs1-shs2

            %double support-as percent stride
            slowdoublesupportpct(i) = (FootEvents(i,7)-FootEvents(i,6))./(FootEvents(i,8)-FootEvents(i,4))*100;
            fastdoublesupportpct(i) = (FootEvents(i,5)-FootEvents(i,4))./(FootEvents(i,9)-FootEvents(i,5))*100;

            slowdoublesupporttime(i) = (FootEvents(i,7)-FootEvents(i,6));
            fastdoublesupporttime(i) = (FootEvents(i,5)-FootEvents(i,4));

            ts(i) = (FootEvents(i,6)-FootEvents(i,4)); %same as step time
            tf(i) = (FootEvents(i,8)-FootEvents(i,6));




        else %If leg=0 -> aligned to fast leg's heel strike
            fhs = FootEvents(i,4);
            sto = FootEvents(i,5);
            shs = FootEvents(i,6);
            fto = FootEvents(i,7);
            fhs2 = FootEvents(i,8);
            sto2 = FootEvents(i,9);
            %stride time
            faststridetime(i) = FootEvents(i,8) - FootEvents(i,4); %shs2-shs1
            slowstridetime(i) = FootEvents(i,9) - FootEvents(i,5); %fto2-fto1
            %stance time
            faststancetime(i) = FootEvents(i,7) - FootEvents(i,4); %sto1-shs1
            slowstancetime(i) = FootEvents(i,9) - FootEvents(i,6); %fto1-fhs1
            %step time (from heel strike to heel strike= stance phase - double support)
            faststeptime(i) = FootEvents(i,6) - FootEvents(i,4); %fhs1-shs1
            slowsteptime(i) = FootEvents(i,8) - FootEvents(i,6); %fhs1-shs2

            %double support-as percent stride
            fastdoublesupportpct(i) = (FootEvents(i,7)-FootEvents(i,6))./(FootEvents(i,8)-FootEvents(i,4))*100;
            slowdoublesupportpct(i) = (FootEvents(i,5)-FootEvents(i,4))./(FootEvents(i,9)-FootEvents(i,5))*100;

            fastdoublesupporttime(i) = (FootEvents(i,7)-FootEvents(i,6));
            slowdoublesupporttime(i) = (FootEvents(i,5)-FootEvents(i,4));

            tf(i) = (FootEvents(i,6)-FootEvents(i,4)); %same as step time
            ts(i) = (FootEvents(i,8)-FootEvents(i,6));



        end
    else % if right leg is the slow leg

        leg = FootEvents(i,3);
        if leg %If leg=1 -> aligned to slow leg's heel strike


            fhs = FootEvents(i,4);
            sto = FootEvents(i,5);
            shs = FootEvents(i,6);
            fto = FootEvents(i,7);
            fhs2 = FootEvents(i,8);
            sto2 = FootEvents(i,9);
            %stride time
            faststridetime(i) = FootEvents(i,8) - FootEvents(i,4); %shs2-shs1
            slowstridetime(i) = FootEvents(i,9) - FootEvents(i,5); %fto2-fto1
            %stance time
            faststancetime(i) = FootEvents(i,7) - FootEvents(i,4); %sto1-shs1
            slowstancetime(i) = FootEvents(i,9) - FootEvents(i,6); %fto1-fhs1
            %step time (from heel strike to heel strike= stance phase - double support)
            faststeptime(i) = FootEvents(i,6) - FootEvents(i,4); %fhs1-shs1
            slowsteptime(i) = FootEvents(i,8) - FootEvents(i,6); %fhs1-shs2

            %double support-as percent stride
            fastdoublesupportpct(i) = (FootEvents(i,7)-FootEvents(i,6))./(FootEvents(i,8)-FootEvents(i,4))*100;
            slowdoublesupportpct(i) = (FootEvents(i,5)-FootEvents(i,4))./(FootEvents(i,9)-FootEvents(i,5))*100;

            fastdoublesupporttime(i) = (FootEvents(i,7)-FootEvents(i,6));
            slowdoublesupporttime(i) = (FootEvents(i,5)-FootEvents(i,4));

            tf(i) = (FootEvents(i,6)-FootEvents(i,4)); %same as step time
            ts(i) = (FootEvents(i,8)-FootEvents(i,6));



        else %If leg=0 -> aligned to fast leg's heel strike
            shs = FootEvents(i,4);
            fto = FootEvents(i,5);
            fhs = FootEvents(i,6);
            sto = FootEvents(i,7);
            shs2 = FootEvents(i,8);
            fto2 = FootEvents(i,9);
            %stride time
            slowstridetime(i) = FootEvents(i,8) - FootEvents(i,4); %shs2-shs1
            faststridetime(i) = FootEvents(i,9) - FootEvents(i,5); %fto2-fto1
            %stance time
            slowstancetime(i) = FootEvents(i,7) - FootEvents(i,4); %sto1-shs1
            faststancetime(i) = FootEvents(i,9) - FootEvents(i,6); %fto1-fhs1
            %step time (from heel strike to heel strike= stance phase - double support)
            slowsteptime(i) = FootEvents(i,6) - FootEvents(i,4); %fhs1-shs1
            faststeptime(i) = FootEvents(i,8) - FootEvents(i,6); %fhs1-shs2

            %double support-as percent stride
            slowdoublesupportpct(i) = (FootEvents(i,7)-FootEvents(i,6))./(FootEvents(i,8)-FootEvents(i,4))*100;
            fastdoublesupportpct(i) = (FootEvents(i,5)-FootEvents(i,4))./(FootEvents(i,9)-FootEvents(i,5))*100;

            slowdoublesupporttime(i) = (FootEvents(i,7)-FootEvents(i,6));
            fastdoublesupporttime(i) = (FootEvents(i,5)-FootEvents(i,4));

            ts(i) = (FootEvents(i,6)-FootEvents(i,4)); %same as step time
            tf(i) = (FootEvents(i,8)-FootEvents(i,6));



        end


    end
    slowAlpha(i) = Trial(trl).Angle.([s 'Limb'])(shs); %s=L
    slowBeta(i) = Trial(trl).Angle.([s 'Limb'])(sto);
    fastAlpha(i) = Trial(trl).Angle.([f 'Limb'])(fhs);
    fastBeta(i) = Trial(trl).Angle.([f 'Limb'])(fto);
    %2D
    X1 = [Trial(trl).([s 'AnklePos']).X(shs2); Trial(trl).([s 'AnklePos']).Y(shs2)];
    X2 = [Trial(trl).([f 'AnklePos']).X(shs2); Trial(trl).([f 'AnklePos']).Y(shs2)];
    slowsteplength2D(i) = sqrt((sum(abs(X1-X2)).^2));
    X1 = [Trial(trl).([s 'AnklePos']).X(fhs); Trial(trl).([s 'AnklePos']).Y(fhs)];
    X2 = [Trial(trl).([f 'AnklePos']).X(fhs); Trial(trl).([f 'AnklePos']).Y(fhs)];
    faststeplength2D(i) = sqrt((sum(abs(X1-X2)).^2));
    % 1D
    %calculate step lengths
    slowsteplength(i) = abs(Trial(trl).([f 'AnklePos']).X(shs2) - Trial(trl).([s 'AnklePos']).X(shs2)); %EV edit - take absolute value
    faststeplength(i) = abs(Trial(trl).([s 'AnklePos']).X(fhs) - Trial(trl).([f 'AnklePos']).X(fhs)); %EV edit
end

%cross correlation analysis - stride by stride
for i = 1:size(FootEvents,1)
    trl = FootEvents(i,1);
    leg= FootEvents(i,3);
    start = FootEvents(i,4); %slow hs1
    finish = FootEvents(i,9); %fast to2
    slowlimb = Trial(trl).Angle.([s 'Limb'])(start:finish);
    fastlimb = Trial(trl).Angle.([f 'Limb'])(start:finish);
    slowlimb = slowlimb - mean(slowlimb);
    fastlimb = fastlimb - mean(fastlimb);
    % Circular correlation
    s1=std(slowlimb);
    s2=std(fastlimb);

    %     if trl==39
    %         trl
    %     end
    c=[];

    if Lleg % if left leg is the slow leg
        if leg

            n=length(slowlimb);
            for t=1:n
                c(t)=(slowlimb'*fastlimb)./((n-1)*s1*s2);
                fastlimb=circshift(fastlimb,1);
            end


        else
            %
            n=length(fastlimb);
            for t=1:n
                c(t)=(fastlimb'*slowlimb)./((n-1)*s1*s2);
                slowlimb=circshift(slowlimb,1);
            end

            %          n=length(slowlimb);
            %         for t=1:n
            %             c(t)=(slowlimb'*fastlimb)./((n-1)*s1*s2);
            %             fastlimb=circshift(fastlimb,1);
            %         end
            %       newt=1:n;
            %       indext=sort(newt,'descend');
            %       newc=c(indext);
            %       c=newc;
        end
    else % if right leg is the slow leg
        if leg

                        %
            n=length(fastlimb);
            for t=1:n
                c(t)=(fastlimb'*slowlimb)./((n-1)*s1*s2);
                slowlimb=circshift(slowlimb,1);
            end

            %          n=length(slowlimb);
            %         for t=1:n
            %             c(t)=(slowlimb'*fastlimb)./((n-1)*s1*s2);
            %             fastlimb=circshift(fastlimb,1);
            %         end
            %       newt=1:n;
            %       indext=sort(newt,'descend');
            %       newc=c(indext);
            %       c=newc;

        else

            n=length(slowlimb);
            for t=1:n
                c(t)=(slowlimb'*fastlimb)./((n-1)*s1*s2);
                fastlimb=circshift(fastlimb,1);
            end


        end
    end

    %c=c.^2;


    [cmax,lag]=max(c);
    lag=lag/n;

    if lag>0.7
        lag
    end

    %     if leg==0
    %         lag=lag-0.05;
    %     end
    %lag=(lag-1)/n;
    %if lag>0.5
    %   lag=lag-1;
    %end

    % for LN0038 , 382 only
    %           if leg==0 & i>15 & lag>0.48
    %           lag=(-lag+0.48)+0.48;
    %       end

    %for LN0005
    %            if leg==1 & lag<0.5
    %            lag=lag+0.02;
    %        end
    %for LN0061
    %                 if leg==0
    %             lag=lag-0.04;
    %         end
    %for LN0393
    % if leg==0 & lag>0.50
    % lag=lag-0.05;
    % end

    if cmax<0.5
        lag=NaN;
    end
    phaseshift(i)=lag;

    %     % Cross correlation
    %      if leg
    %         %if started with left leg
    %         T = (FootEvents(i,8)-FootEvents(i,4)); %slow stride time
    %     else
    %         %if started with right leg
    %         T = (FootEvents(i,9)-FootEvents(i,6)); %slow stride time
    %     end
    %     maxlag = round(T);
    %
    %     [c,lags] = xcorr(slowlimb,fastlimb,maxlag,'coeff');
    %     c = c(find(lags>=0));
    %     lags = lags(find(lags>=0));
    %     lags = lags/maxlag; %normalize to range [0,1]
    %     [maxcorr,ind] = max(c);
    %     phaseshift(i,:) = lags(ind);


end



%differences/ratios
steplengthasym2D = (faststeplength2D-slowsteplength2D)./(faststeplength2D+slowsteplength2D);
steplengthasym = (faststeplength-slowsteplength)./(faststeplength+slowsteplength);
%normalized double support (aka doublesupportasym)
doublesupportasym= (fastdoublesupportpct - slowdoublesupportpct)./(fastdoublesupportpct + slowdoublesupportpct);
%doublesupportdifference (T_error)
DSdifference=slowdoublesupporttime-fastdoublesupporttime;
%difference in HS times
td=ts-tf;
%stance time difference
STdiff=slowstancetime-faststancetime; % Temporal Goal

%alpha ratios (percentage of angular range in front of body)
ralphaS=(slowAlpha)./(slowAlpha-slowBeta);
ralphaF=(fastAlpha)./(fastAlpha-fastBeta);
S_error_old=ralphaF./ralphaS;
S_error=ralphaS-ralphaF;
%spatial motor command
alphaRatio=fastAlpha./slowAlpha;
SlowRange=slowAlpha-slowBeta;
FastRange=fastAlpha-fastBeta;
AngularRatio=FastRange./SlowRange; % Spatial Goal

%cadence (1 cycle/sec) % Cadence value was changed from 1000./faststride to
%100./faststridetime in all files processed after July 22nd 2010
fastcadence=100./faststridetime;
slowcadence=100./slowstridetime;

%cadence (1 step/sec), a step is defined as the distance from
%heel strike to heel strike of the other leg
faststepcadence=100./faststeptime;
slowstepcadence=100./slowsteptime;

% TO be consistent with Laura's values
%S=(slowAlpha+slowBeta)/2;
%F=(fastAlpha+fastBeta)/2;

S=slowAlpha+slowBeta;
F=fastAlpha+fastBeta;

angleofoscillation=S-F;

TheData = [...
    FootEvents(:,1),...                 %1-trial no.
    FootEvents(:,2),...                 %2-condition
    FootEvents(:,3),...                 %3 leg
    fastdoublesupportpct',...            %4
    slowsteplength',...          %5
    faststeplength',...          %6
    slowcadence',...                     %7
    fastcadence',...                     %8
    slowBeta',...                        %9
    fastBeta',...                        %10
    slowAlpha',...                       %11
    fastAlpha',...                       %12
    SlowRange',...%13
    FastRange',...%14
    slowstepcadence',...                  %15
    faststepcadence',...                  %16
    phaseshift',...                      %17
    slowdoublesupporttime',...           %18
    fastdoublesupporttime',...           %19
    doublesupportasym',...       %20 (aka Normdoublesupportdifference)
    steplengthasym',...          %21 (22)
    steplengthasym2D',...          %22 (aka symmetry)
    ralphaS',...                         %23
    slowsteplength2D',...                %24
    faststeplength2D',...                %25
    ralphaF',...                         %26
    alphaRatio',...                      %27 (S_motor output)
    S_error',...                         %28 (S_error)
    AngularRatio',...                    %29 (S_goal)
    DSdifference',...                    %30 (same as T_error)
    td',...                              %31 (T_motor output)
    STdiff',...                          %32 (T_goal)
    slowdoublesupportpct',...            %33
    angleofoscillation',...              %34 % added after July 22nd 2010
    S_error_old',...                     %35 (ratio of ratios) added after July 22nd 2010
    ];
%columns need to include step length and stride length 2D and 1D (6
%extra columns

%
% for i = 1:size(FootEvents,1)
%     leg= FootEvents(i,3);
%     if leg
%         %if started with left leg
%         steplengthasym2D(i,:) = (faststeplength2D(i,:)-slowsteplength2D(i,:))/(faststeplength2D(i,:)+slowsteplength2D(i,:));
%         steplengthasym(i,:) = (faststeplength(i,:)-slowsteplength(i,:))/(faststeplength(i,:)+slowsteplength(i,:));
%         %normalized double support (aka doublesupportasym)
%         doublesupportasym(i,:)= (fastdoublesupportpct(i,:) - slowdoublesupportpct(i,:))/(fastdoublesupportpct(i,:) + slowdoublesupportpct(i,:));
%         %doublesupportdifference (T_error)
%         DSdifference(i,:)=slowdoublesupporttime(i,:)-fastdoublesupporttime(i,:);
%         %difference in HS times
%         td(i,:)=ts(i,:)-tf(i,:);
%         %stance time difference
%         STdiff(i,:)=slowstancetime(i,:)-faststancetime(i,:); % Temporal Goal
%
%     else
%         %if started with right leg
%         steplengthasym2D(i,:) = (slowsteplength2D-faststeplength2D(i,:))/(faststeplength2D(i,:)+slowsteplength2D(i,:));
%         steplengthasym(i,:) = (slowsteplength-faststeplength(i,:))/(faststeplength(i,:)+slowsteplength(i,:));
%         %normalized double support (aka doublesupportasym)
%         doublesupportasym(i,:)= (slowdoublesupportpct(i,:) - fastdoublesupportpct(i,:))/(fastdoublesupportpct(i,:) + slowdoublesupportpct(i,:));
%         %T_error
%         DSdifference(i,:)=fastdoublesupporttime(i,:)-slowdoublesupporttime(i,:);
%         td(i,:)=tf(i,:)-ts(i,:);
%         %stance time difference
%         STdiff(i,:)=faststancetime(i,:)-slowstancetime(i,:); % Temporal Goal
%
%     end
% end
