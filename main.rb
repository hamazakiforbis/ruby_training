require './SampleCmd'
require './Sample2Cmd'

s = Sample.new /[[:alnum:]]{5}/, 0
s.recieve_cmd "hoge"
puts s.create_cmd
s.recieve_cmd "hoge2"
puts s.create_cmd

q = Sample2.new /[[a-z]]{1,8}/, 30
q.recieve_cmd "hoge"
puts q.create_cmd
q.recieve_cmd "hoge2"
puts q.create_cmd