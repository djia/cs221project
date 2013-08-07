function [examplesTraining, examplesTest] = runPCA(examplesTraining, examplesTest, bPCAWhitening, bZCAWhitening)

[examplesTraining, mapping] = myPCA(examplesTraining');
examplesTest = mapping.U' * (examplesTest' - mapping.mean);

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