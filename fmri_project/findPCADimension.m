%Load the data
subjects = {'data-starplus-04799-v7.mat', 'data-starplus-04820-v7.mat', 'data-starplus-04847-v7.mat', 'data-starplus-05675-v7.mat', 'data-starplus-05680-v7.mat', 'data-starplus-05710-v7.mat'};
accuracy = zeros(length(subjects),1);


nLambdas = 78;
varianceThreshold = 0.95;
for j = 1 : nLambdas
    varianceThresholdMet = 1;
    
    % loop through all the subjects
    for sub_id = 1:length(subjects) 
        load(subjects{1,sub_id}); 

        % collect the non-noise and non-fixation trials
        trials=find([info.cond]>1); 
        [info1,data1,meta1]=transformIDM_selectTrials(info,data,meta,trials);
        % seperate P1st and S1st trials
        [infoP1,dataP1,metaP1]=transformIDM_selectTrials(info1,data1,meta1,find([info1.firstStimulus]=='P'));
        [infoS1,dataS1,metaS1]=transformIDM_selectTrials(info1,data1,meta1,find([info1.firstStimulus]=='S'));

        % seperate reading P vs S
        [infoP2,dataP2,metaP2]=transformIDM_selectTimewindow(infoP1,dataP1,metaP1,[1:16]);
        [infoP3,dataP3,metaP3]=transformIDM_selectTimewindow(infoS1,dataS1,metaS1,[17:32]);
        [infoS2,dataS2,metaS2]=transformIDM_selectTimewindow(infoP1,dataP1,metaP1,[17:32]);
        [infoS3,dataS3,metaS3]=transformIDM_selectTimewindow(infoS1,dataS1,metaS1,[1:16]);

        % convert to examples
        [examplesP2,labelsP2,exInfoP2]=idmToExamples_condLabel(infoP2,dataP2,metaP2);
        [examplesP3,labelsP3,exInfoP3]=idmToExamples_condLabel(infoP3,dataP3,metaP3);
        [examplesS2,labelsS2,exInfoS2]=idmToExamples_condLabel(infoS2,dataS2,metaS2);
        [examplesS3,labelsS3,exInfoS3]=idmToExamples_condLabel(infoS3,dataS3,metaS3);

        % combine examples and create labels.  Label 'picture' 1, label 'sentence' 2.
        examplesP=[examplesP2;examplesP3];
        examplesS=[examplesS2;examplesS3];
        labelsP=ones(size(examplesP,1),1);
        labelsS=ones(size(examplesS,1),1)+1;
        examples=[examplesP;examplesS];
        labels=[labelsP;labelsS];

        %Split into test and training test. The approach is to leave one trial out.
        nTrials = length(labelsP);
        for i = 1 : nTrials
            examplesTraining = examples;
            examplesTraining(i,:) = [];
            examplesTraining(i + nTrials -1, :) = [];
            labelsTraining = labels;
            labelsTraining(i) = [];
            labelsTraining(i + nTrials -1) = [];
            examplesTest = [examples(i, :); examples(i + nTrials, :)];
            labelsTest = [labels(i); labels(i + nTrials)];

            % addpath(genpath('~/Documents/cs221/cs221project/fmri_project'))
            [examplesTraining, mapping] = myPCA(examplesTraining');
            N = j;
            varianceRetained = sum(mapping.lambda(1 : N)) / sum(mapping.lambda)
            
            % check to see whether the variance threshold is retained
            % if not, then just try the next lambda
            if(varianceRetained < varianceThreshold)
                varianceThresholdMet = 0;
                break;
            end
        end
        
        if(varianceThresholdMet == 0)
            break;
        end
        
    end
    
    if(varianceThresholdMet == 1)
        j
        break;
    end
    
end
