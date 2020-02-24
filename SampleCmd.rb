require './CommandStyle'
class Sample < CommandStyle
    def create_cmd
        @state.to_s
    end

    # def recieve_cmd cmd
        
    # end 

    def update_state cmd
        puts "before :#{@state.to_s}"
        @state = cmd.to_s.split("").select{/[0-9]+/}.join.to_i
        puts "after  :#{@state.to_s}"
    end

end