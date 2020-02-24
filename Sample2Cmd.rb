require './CommandStyle'
class Sample2 < CommandStyle
    def create_cmd
        @state.to_s.split("").join("_")
    end

    def update_state cmd
        puts "before :#{@state.to_s}"
        @state = cmd.to_s.upcase
        puts "after  :#{@state.to_s}"
    end

end