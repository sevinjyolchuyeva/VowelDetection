clear all;
addpath('../mweka');
addpath('../matlab2weka');

[dataName, featureNames, attributeType, data] = arffread('vowel/vowel.arff');

classindex = size(data, 2);

% randomize the data, so we get a good coverage of speakers and samples
perm = randperm(size(data, 1));
meas   = data(perm, 1:(classindex - 1));
labels = cellstr(num2str(data(perm, classindex)));

%Prepare test and training sets. 
data = [num2cell(meas),labels];
halfway = int32(size(data, 1) / 5);
train = data(1:halfway  ,:);
test  = data(halfway:end,:);

%Convert to weka format
train = matlab2weka(strcat(dataName, '-train'), featureNames,train,classindex);
test =  matlab2weka(strcat(dataName, '-test'),  featureNames,test);

%Train the classifier
%nb = trainWekaClassifier(train,'functions.MultilayerPerceptron', {'-L', '0.5', '-M', '0.2', '-N', '500', '-V', '0', '-S', '0', '-E', '20', '-H', 'a'});
%nb = trainWekaClassifier(train,'bayes.NaiveBayes', {'-D'});
nb = trainWekaClassifier(train, 'lazy.IBk');

%Test the classifier
predicted = wekaClassify(train,nb);

%The actual class labels (i.e. indices thereof)
actual = train.attributeToDoubleArray(classindex-1); %java indexes from 0

successRate = 1 - sum(actual ~= predicted)/train.numInstances

%Test the classifier
predicted = wekaClassify(test,nb);

%The actual class labels (i.e. indices thereof)
actual = test.attributeToDoubleArray(classindex-1); %java indexes from 0

successRate = 1 - sum(actual ~= predicted)/test.numInstances

% figure(2)
[x,rate]=wavread('Jesse_normal_trimmed_11k.wav');

window_size = 512

samples_inc = 5000;
samples_per_ms = 11000 / 1000;
step = samples_per_ms * 5; % 5 ms step
% num of pts for DFT
nfft=window_size;

% frequency range of ft analysis (based on nyquist value and rate of wav
% file)
freq=linspace(0,rate/2,nfft/2+1);

hw = hamming(window_size);
p=12;
for i = 1:step:samples_inc

    w = x(i:(i + window_size - 1));

    w = w .* hw;
    a = lpc(w,p);
    la = zeros(10, 1);
    
    % Log area ratio
    for j = 2:11
        la(j - 1) = log((1 + a(j))/(1 - a(j)));
    end

    wdata = num2cell([la.' 0]);
    wdata =  matlab2weka(strcat(dataName, '-real'),  featureNames,wdata);

    pred = wekaClassify(wdata, nb)
    
end