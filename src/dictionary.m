function wordMap = dictionary(cellArray)
wordMap = containers.Map;
for str = cellArray'
    currentString = str{1};
    splitupString = strread(currentString, '%s');
    for word = splitupString'
        wordString = word{1};
        if ~isKey(wordMap, wordString)
            wordMap(wordString) = 0;
        end
    end
end