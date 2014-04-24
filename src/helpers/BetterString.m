classdef BetterString < handle
    properties (Hidden) 
        m_string = [];
        m_index = 0;
    end
    methods
        function BS = BetterString(string)
            BS.m_string = string;
            BS.m_index = 1;
        end
        function chars = readChars(this, count)
            chars = this.m_string(this.m_index : this.m_index+count-1);
            this.m_index = this.m_index + count;
        end
        function seek(this, count)
            this.m_index = this.m_index + count;
        end
        function empty = isEmpty(this)
            empty = (this.m_index > length(this.m_string));
        end
        function chars = readUntil(this, strings)
            count = 0;
            while ~ismember(this.m_string(this.m_index+count), strings)
                count = count + 1;
            end
            chars = this.readChars(count);
        end
    end
end