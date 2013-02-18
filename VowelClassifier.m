%%
%
%
%
%

classdef VowelClassifier
    properties(GetAccess='private', SetAccess='private')
        nb
    end
    
    methods
        function self=VowelClassifier()

            % Paths to the matlab2weka interface, and weka jar file
            addpath('../matlab2weka');
            javaaddpath('/Applications/weka-3-6-8/weka.jar');

            [dataName, featureNames, attributeType, data] = arffread('vowel/vowel.arff');

            %Shuffle the data
            % rand('twister',0);
            % perm = randperm(150);
            % meas = meas(perm,:);
            % species = species(perm,:);

            % featureNames = {'sepallength','sepalwidth','petallength','petalwidth','class'};

            %Prepare test and training sets. 
            %data = [num2cell(meas),species];
            halfway = int32(size(data, 1) / 2);
            train = data(1:halfway  ,:);
            test  = data(halfway:end,:);

            classindex = size(data, 2) - 1;

            %Convert to weka format
            train = matlab2weka(strcat(dataName, '-train'), featureNames,train,classindex);
            test =  matlab2weka(strcat(dataName, '-test'),  featureNames,test);

            %Train the classifier
            self.nb = trainWekaClassifier(train,'functions.MultilayerPerceptron');
        end
        
        function [vowel] = classify(window)
        end
    end
    
end

