function [mappedX, mapping] = myPCA(X)

%Note X here is a MxN matrix where M is the number of dimensions and N is the number of training examples

%Mean Normalization
mapping.mean = mean(X,2);
X = X - mapping.mean;

%We will find the X'*X assuming M >> N.
[Q S D] = svd(X'*X);
sigma= sqrt(S);
U = X*Q*inv(sigma);

%Mapping the original training data to rotated axes
mapping.U = U;
mapping.lambda = diag(sigma);
mappedX = (U'*X);
%mappedX = (U'*X)./mapping.lambda;
