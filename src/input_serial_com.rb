# require './wincom'
require 'serialport'

# @com = Serial.new
# @com.comno = 1
# @com.bRate = CBR_19200
# @com.parity = NOPARITY
# @com.byteSize = 8
@com = SerialPort.new('/dev/ttyS0', 19200, 8, 1, 0) # device, rate, data, stop, parity
def thread_input_serial_com
    @com.open
    loop do
    end
    @com.close
end
