function [ features ] = get_features( tweet, keys, dict )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

currentString = tweet{1};
splitupString = strread(currentString, '%s');
features = zeros(1, length(keys));
for word = splitupString'
    if isKey(dict, word)
        index = find(strcmp(keys, word));
        features(index) = features(index) + 1;
    end
end
end

