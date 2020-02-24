class CommandStyle
    @state
    @cmd_pattern
    def initialize pattern, state = nil
        @state = state if state
        @cmd_pattern = pattern
    end

    def create_cmd
        puts "#{self.class} create command"
    end
    
    def recieve_cmd cmd
        puts "#{self.class} recieved #{cmd.to_s}"
        puts "compare #{cmd.to_s} <> #{@cmd_pattern.to_s}"
        update_state cmd if cmd =~ @cmd_pattern
    end
    
    def update_state cmd
        puts "#{self.class} recieved #{cmd.to_s}"
    end

end