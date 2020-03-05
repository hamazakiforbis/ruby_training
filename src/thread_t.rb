class InputHandler
    @buf
    def initialize in, end, evt
        @buf = Array.new
    end

    def wait_input
        while
            yield
        end
    end
end

def key_input
    STDIN.getch
end

def key_end_con char
    char == "\C-c"
end

def key_event buf
    return false if buf.length != 5
    if buf =~ /[[:alnum:]]{5}/
        true
    else
        false
    end
end

ih = InputHandler.new(key_input, key_end_con, key_event)