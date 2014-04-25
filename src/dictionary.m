function wordMap = dictionary(cellArray)
i=1;
countMap = containers.Map('KeyType', 'char', 'ValueType', 'int32');
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
            if ~isKey(countMap, wordString)
                countMap(wordString) = 1;
            else
                countMap(wordString) = countMap(wordString) + 1;
                if countMap(wordString) > 100
                    wordMap(wordString) = 0;
                end
            end
        end
    end
end

end