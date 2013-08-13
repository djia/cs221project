function [examplesTraining, examplesTest] = runPCA(examplesTraining, examplesTest, bPCAWhitening, bZCAWhitening)

[examplesTraining, mapping] = myPCA(examplesTraining');
% size(examplesTest');
% size(mapping.mean);
examplesTest = mapping.U' * (examplesTest' - repmat(mapping.mean, 1, size(examplesTest', 2)));

if (bPCAWhitening)
    examplesTraining = diag(1./mapping.lambda)*examplesTraining;
	examplesTest = diag(1./mapping.lambda)*examplesTest;
end
if (bZCAWhitening)
    examplesTraining = mapping.U*diag(1./mapping.lambda)*examplesTraining;
	examplesTest = mapping.U*diag(1./mapping.lambda)*examplesTest;
end
examplesTraining = examplesTraining';
examplesTest = examplesTest';