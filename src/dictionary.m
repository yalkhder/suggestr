function wordMap = dictionary(cellArray)
i=1;
wordMap = containers.Map('KeyType', 'char', 'ValueType', 'int32');
for str = cellArray'
    if mod(i,1000) == 0
        disp(i);
    end
    i = i+1;
    currentString = str{1};
    splitupString = strread(currentString, '%s');
    for word = splitupString'
        wordString = word{1};
        if ~isKey(wordMap, wordString)
            wordMap(wordString) = 0;
        end
    end
end