require './CmdSample'
# require './CmdSample2'
# require './input_keyboard'
# require './input_serial_com'

s = CmdSample.new /[[:alnum:]]{5}/, 0
s.recieve_cmd "hoge2"
puts s.create_cmd
__END__
q = CmdSample2.new /[[a-z]]{1,8}/, 30
# q.recieve_cmd "hoge2"
# puts q.create_cmd

# puts gather_cmd.map{|e|e.create_cmd}.join

class CommandHandler
    @cmd_list
    def initialize
        @cmd_list = Array.new
    end
    
    def registrate cmd
        return unless cmd.class.superclass == CommandStyle
        @cmd_list.push cmd
    end
    
    def broadcast msg
        @cmd_list.each do |cmd|
            cmd.recieve_cmd msg
        end
    end
    
    def create_message
        @cmd_list.map{|cmd|cmd.create_cmd}.join
    end
end


input_key = Thread.new { thread_input_keyboard }
input_com = Thread.new { thread_input_serial_com }
input_key.join

# while msg = input_keyboard
#     ch = CommandHandler.new
#     ch.registrate s
#     ch.registrate q
    
#     ch.broadcast "hoge"
#     puts ch.create_message
# end