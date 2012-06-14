#!/usr/bin/env ruby

base_dir = File.expand_path("..", __FILE__)

NAME="faye"
PID="#{base_dir}/tmp/pids/#{NAME}.pid"
COMMAND="bundle exec rackup faye.ru -s thin -E production -p 9998"

case ARGV[0]
when "start"
  pid = fork do
    Dir.chdir(base_dir)
    exec *COMMAND.split(' ')
  end
  Process.detach(pid)
  File.open(PID, "w+") do |f|
    f.write(pid)
  end
when "stop"
  Process.kill "TERM", File.read(PID).to_i
else
  puts "usage: #{$0} {start|stop}"
end
