function [mappedX, mapping] = myPCA(X)

%size(X)

%Note X here is a MxN matrix where M is the number of dimensions and N is the number of training examples

%Mean Normalization
mapping.mean = mean(X, 2);
X = X - repmat(mapping.mean, 1, size(X, 2));

%We will find the X'*X assuming M >> N.
[Q S D] = svd(X' * X);
sigma= sqrt(S);
U = X * Q * inv(sigma);
%size(U)

%Mapping the original training data to rotated axes
mapping.U = U;
mapping.lambda = diag(sigma);
%size(mapping.lambda);
mappedX = (U' * X);
%mappedX = (U' * X) ./ mapping.lambda;
