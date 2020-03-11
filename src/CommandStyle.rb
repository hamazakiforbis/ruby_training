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
        if crc_check(cmd) then
            cmd_parse(cmd)
            update_state cmd if cmd =~ @cmd_pattern
        end
    end
    
    def update_state cmd
        puts "#{self.class} recieved #{cmd.to_s}"
    end

end

syntax = [
    {:idx => 0, :charas => 1, :type => :txt},
    {:idx => 1, :charas => 2, :type => :num},
    {:idx => 2, :charas => 3, :type => :txt},
]


def cmd_parse cmd_txt, syn_tbl
    chunks = Array.new
    cmd_tmp = cmd_txt.split("")
    syn_tbl.each do |stx|
        chunks << cmd_tmp.shift(stx[:charas]).join
    end
    chunks
end

puts cmd_parse "123234", syntax