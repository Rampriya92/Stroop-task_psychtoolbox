 
clc;
close all;
clear vars;
clear all;

% initiate screen
Screen('Preference', 'SkipSyncTests',2);
PsychDefaultSetup(2);
screen=max(Screen('Screens'));

% %  Query the maximum priority level
% topPriorityLevel = MaxPriority(window);

%opening window
[window, windowRect]=PsychImaging('Openwindow', screen,[0 0 0]);
[xcenter,ycenter]= RectCenter(windowRect);

%stimulus 
text=["RED"  "GREEN" "BLUE" ];
color_index=[[1 0 0];[0 1 0];[0 0 1 ]];

% text and color combinations
condition_base=[sort(repmat([1 2 3],1,3));repmat([1 2 3],1,3)];

%Shuffling conditions
condition_shuffle=Shuffle(condition_base);
trialpercond=2;
condition=repmat(condition_shuffle,1,trialpercond);

%number of trials
[~,num_trial]=size(condition);
result=nan(num_trial,4);
Stimulus=nan(num_trial,1);
output=nan(22,4);
outputfile='stroop.xlsx';
Screen('TextSize',window,100)

leftKey = KbName('LeftArrow'); %for red
rightKey = KbName('RightArrow');%for green
downKey = KbName('DownArrow');% for blue


%presenting stimulus in series
for trial = 1:num_trial
    Stimulus_num=condition(1,trial);
    color_num=condition(2,trial);
    Stimulus=text(Stimulus_num);
    response=0;
    Color=color_index(color_num,:);
    while response==0
        DrawFormattedText(window,char(Stimulus),'center','center',Color)
        Screen(window,'Flip')
        t1=GetSecs;
        [keyisDown,t2,keyCode]=KbCheck;
        while keyisDown==0
            [keyisDown,t2,keyCode]=KbCheck;
        end
        RT=t2-t1;
        if keyCode(leftKey)
            response=1;
        elseif keyCode(downKey)
            response=2;
            
        elseif keyCode(rightKey)

            response=3;
        end
        

    end
    result(trial,1)=Stimulus_num;
    result(trial,2)=color_num;
    result(trial,3)=response;
    result(trial,4)=RT;
    label={'word','color','response','RT'};
    output=[label; num2cell(result)];
    xlswrite(outputfile,output,1);
    
    
end



Screen('CloseAll');
