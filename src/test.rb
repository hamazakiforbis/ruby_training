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