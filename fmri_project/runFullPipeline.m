% add the path so it can be run outside of matlab UI
addpath(genpath('~/Documents/cs221/cs221project/fmri_project'))

% define the max dimensions to check
% these corresponds to 70%-95%+ of variance accountability
maxDimensions = [52, 57, 61, 65, 69, 73, 78];

whiteningChoices = [
    0, 0;
    0, 1;
    1, 0;
];

% define all the tests to make
k = 1;
for i = 1 : size(maxDimensions, 2)
   for j = 1 : size(whiteningChoices)
      tests(k, :) = [whiteningChoices(j, 1), whiteningChoices(j, 2), maxDimensions(1, i)];
   end
end

for i = 1 : size(tests, 1)
    [accuracy] = runTests_PCA(tests(i, 1), tests(i, 2), tests(i, 3));
    accuracies(i, :) = accuracy;
end

fileID = fopen('results.txt','w');
fprintf(fileID,'%f \n', accuracies);
fclose(fileID);

accuracies