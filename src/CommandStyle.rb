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

@form_tbl = [
    {
        :idx => 0,
        :charas => 2,
        :attr => {
            :type => :txt,
            :elm => :spd
        }
    },
    {
        :idx => 1,
        :charas => 1,
        :attr => {
            :type => :num,
            :elm => :dir
        }
    },
    {
        :idx => 2,
        :charas => 3,
        :attr => {
            :type => :txt, 
            :elm => :name
        }
    },
    {
        :idx => 3,
        :charas => 2,
        :attr => {
            :type => :txt,
            :elm => :crc
        }
    },
]


def cmd_parse cmd_txt
    chunks = Array.new
    cmd_tmp = cmd_txt.split("")
    @form_tbl.each do |format|
        val = cmd_tmp.shift(format[:charas]).join
        chunks << [format[:idx], val, format[:attr]]
    end
    chunks
end

def crc_check tbl
    puts tbl.select{|e| [:crc].include?(e)}
end

def optimize tbl
    tbl.map{|e| e[:val] = e[:val]}
end
def apply tbl
    tbl.map{|e| }
end


msg = "123234F0"
tbl = cmd_parse msg
puts tbl.map{|e| e.to_s}
puts @form_tbl
# crc_check tbl
# tbl = optimize tbl
# apply tbl

