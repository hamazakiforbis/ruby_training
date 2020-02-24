require 'io/console'

class InputKeyboard
    @buf
    def initialize
        @buf = Array.new
    end
    def init_buf
        @buf.clear
    end
    
    def wait_input
        while (key = STDIN.getch) != "\C-c"
            if key =~ /[\r\n]+/ 
                if @buf.size == 5
                    puts @buf.join.upcase
                    init_buf
                end
            end
            
            next unless key =~ /[[:alnum:]]/
            if @buf.size < 5
                print key
                @buf.push key
                print "[type Enter]" if @buf.size == 5
            end
        end
    end
end
