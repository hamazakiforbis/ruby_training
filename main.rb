require './SampleCmd'

s = Sample.new /[[:alnum:]]{5}/
s.recieve_cmd "hoge"
puts s.create_cmd
s.recieve_cmd "hoge2"
puts s.create_cmd