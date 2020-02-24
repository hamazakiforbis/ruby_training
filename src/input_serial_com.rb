require './wincom'

@com = Serial.new
@com.comno = 1
@com.bRate = CBR_19200
@com.parity = NOPARITY
@com.byteSize = 8

def thread_input_serial_com
    @com.open
    while true
    end
    @com.close
end
