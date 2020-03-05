require 'io/console'

class InputReciever
    @buf
    def initialize
        @buf = Array.new
    end

    def get_input
        yield
    end


    def run
        th = Thread.new do 
            @buf.push get_input
            raise hoge if @buf.length > 10
        end
    end
end


# def threading
#     t = Thread.new do 
#         while true
#             yield
#             sleep 1
#         end
#     end 
# end

# th = threading do
#     puts "hoge"
# end
# sleep 10
# puts "end?"
# th.join

def parent_method
    while true
        p 1
        yield
        p 1
        puts
    end
end

def child_method
    parent_method do
        c = STDIN.getch
        return if c == "\C-c"
        print c
    end
end

child_method