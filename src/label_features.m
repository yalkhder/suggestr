function [ features_out, labels_out ] = label_features( features, hashtags )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
m = length(find(~strcmp(hashtags, '')));
n = size(features, 2);
%guess a max of 20*m words in total.
features_out = spalloc(m, n, 20*m);
labels_out = cell(length(find(~strcmp(hashtags, ''))), 1);

k = 1;

for i = 1:size(hashtags, 1)
    [r,c,v] = find(features(i,:));
    for j = 1:size(hashtags, 2)
        if ~strcmp(hashtags(i,j), '')
            features_out(k, :) = sparse(r,c,v,1,n);
            labels_out(k) = hashtags(i,j);
            k = k+1;
            if mod(k, 1000) == 0
                disp(k);
            end
        end
    end
end

end

