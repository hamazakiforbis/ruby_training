require './CommandStyle'
class CmdSample < CommandStyle
    @state = 
    {
        :spd_bp => 0,
        :spd_sp => 0
    }
    def create_cmd
        @state.to_s
    end
    
    def update_state cmd
        puts "before :#{@state.to_s}"
        @state = cmd.to_s.split("").select{|e| e=~/[0-9]+/}.join.to_i
        puts "after  :#{@state.to_s}"
    end
    
end