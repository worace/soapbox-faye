#!/usr/bin/env ruby

base_dir = File.expand_path("..", __FILE__)

NAME="faye"
PID="#{base_dir}/tmp/pids/#{NAME}.pid"
COMMAND="bundle 1>log/start.stdout.log 2>log/start.stderr.log exec thin -R faye.ru -l log/thin.log -e production -p 9998"

case ARGV[0]
when "start"
  pid = fork do
    Dir.chdir(base_dir)
    exec COMMAND
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
