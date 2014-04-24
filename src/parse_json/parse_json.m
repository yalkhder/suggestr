function data = parse_json(file)
% [DATA JSON] = PARSE_JSON(file)
% This function parses a JSON file and returns a cell array with the
% parsed data. JSON objects are converted to structures and JSON arrays are
% converted to cell arrays.
%
% Example:
% google_search = 'http://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=matlab';
% matlab_results = parse_json(urlread(google_search));
% disp(matlab_results{1}.responseData.results{1}.titleNoFormatting)
% disp(matlab_results{1}.responseData.results{1}.visibleUrl)

    data = cell(0,1);
    json = BetterString(fileread(file));

    while ~json.isEmpty()
        value = parse_value(json);
        data{end+1} = value; %#ok<AGROW>
    end
end

function [] = skip_whitespace(string)
%skips whitespace in file.
    c = string.readChars(1);
    while ~string.isEmpty() && isstrprop(c, 'wspace')
        c = string.readChars(1);
    end
    string.seek(-1);
end

function value = parse_value(json)
    value = [];
     if ~json.isEmpty()
        skip_whitespace(json);
        id = json.readChars(1);
        
        switch lower(id)
            case '"'
                value = parse_string(json);
                
            case '{'
                value = parse_object(json);
                
            case '['
                value = parse_array(json);
                
            case 't'
                value = true;
                str = json.readChars(3);
                if (~strcmp(str, 'rue'))
                    ME = MException('json:parse_value',['Invalid TRUE identifier: ' id str]);
                    ME.throw;
                end
                
            case 'f'
                value = false;
                str = json.readChars(4);
                if (~strcmp(str, 'alse'))
                    ME = MException('json:parse_value',['Invalid FALSE identifier: ' id str]);
                    ME.throw;
                end
                
            case 'n'
                value = [];
                str = json.readChars(3);
                if (~strcmp(str, 'ull'))
                    ME = MException('json:parse_value',['Invalid NULL identifier: ' id str]);
                    ME.throw;
                end
                
            otherwise
                % Need to put the id back on the string
                json.seek(-1);

                value = parse_number(json);
        end
    end
end

function data = parse_array(json)
    data = cell(0,1);
    while ~json.isEmpty()
        if strcmp(json.readChars(1),']') % Check if the array is closed
            return
        end
        
        value = parse_value(json);
        
        if isempty(value)
            ME = MException('json:parse_array',['Parsed an empty value: ' json]);
            ME.throw;
        end
        data{end+1} = value; %#ok<AGROW>
        
        skip_whitespace(json);
    end
end

function data = parse_object(json)
    data = [];
    while ~json.isEmpty()
        id = json.readChars(1);
        
        switch id
            case '"' % Start a name/value pair
                [name value] = parse_name_value(json);
                if isempty(name)
                    ME = MException('json:parse_object',['Can not have an empty name: ' json]);
                    ME.throw;
                end
                data.(name) = value;
                
            case '}' % End of object, so exit the function
                return
                
            otherwise % Ignore other characters
        end
    end
end

function [name value] = parse_name_value(json)
    name = [];
    value = [];
    if ~json.isEmpty()
        name = parse_string(json);
        
        % Skip spaces and the : separator
        skip_whitespace(json);
        if strcmp(json.readChars(1), ':')
           skip_whitespace(json);
        else
            %error?
            json.seek(-1);
        end
        value = parse_value(json);
    end
end

function string = parse_string(json)
    string = [];
    while ~json.isEmpty()
        string = [string json.readUntil(['\'; '"'])]; %#ok<AGROW>
        letter = json.readChars(1);
        
        switch lower(letter)
            case '\' % Deal with escaped characters
                if ~json.isEmpty()
                    code = json.readChars(1);
                    switch lower(code)
                        case '"'
                            new_char = '"';
                        case '\'
                            new_char = '\';
                        case '/'
                            new_char = '/';
                        case {'b' 'f' 'n' 'r' 't'}
                            new_char = sprintf(sprintf('\\%c',code));
                        case 'u'
                            code_cont = json.readChars(4);
                            if ~json.isEmpty()
                                new_char = sprintf('\\u%s', code_cont);
                            end
                        otherwise
                            new_char = [];
                    end
                end
                
            case '"' % Done with the string
                return
        end
        string = [string new_char]; %#ok<AGROW>
    end
end

function num = parse_number(json)
    num = [];
    skip_whitespace(json);
    if ~json.isEmpty()
        string = '';
        % read a character until something that isn't part of a number is
        % found.
        while true
            c = json.readChars(1);
            
            % Validate the floating point number using a regular expression
            [s e] = regexp([string c],'^[\w]?[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?[\w]?','once');
            if e-s == length(string)+1
                string = [string c]; %#ok<AGROW>
            else
                break;
            end
        end
        json.seek(-1);
        
        num = str2double(strtrim(string));
    end
end