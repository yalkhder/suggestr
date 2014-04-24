function [ features ] = get_features( tweet, keys )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

features = sparse(length(keys),1);

currentString = tweet{1};
splitupString = strread(currentString, '%s');
for word = splitupString'
    index = find(strcmp(keys, word));
    features(index) = features(index) + 1;
end
end

