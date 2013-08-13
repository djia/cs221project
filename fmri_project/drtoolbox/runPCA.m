function [examplesTraining, examplesTest] = runPCA(examplesTraining, examplesTest, bPCAWhitening, bZCAWhitening, maxDimensions)

[examplesTraining, mapping] = myPCA(examplesTraining', maxDimensions);
% size(examplesTest');
% size(mapping.mean);
examplesTest = mapping.U' * (examplesTest' - repmat(mapping.mean, 1, size(examplesTest', 2)));

if (bPCAWhitening)
    examplesTraining = examplesTraining./mapping.lambda;
    examplesTest = examplesTest./mapping.lambda;
end
if (bZCAWhitening)
    examplesTraining = mapping.U*(examplesTraining./mapping.lambda);
    examplesTest = mapping.U*(examplesTest./mapping.lambda);
end
examplesTraining = examplesTraining';
examplesTest = examplesTest';
