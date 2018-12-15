begin 
  require 'rubygems'
  require 'irb/completion'
  require 'wirble'
  require 'pp'

  IRB.conf[:SAVE_HISTORY] = 1000
  IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb_history"
  IRB.conf[:USE_READLINE] = true
  IRB.conf[:PROMPT_MODE] = :SIMPLE
  IRB.conf[:AUTO_INDENT] = true
  IRB.conf[:PROMPT][:CUSTOM] = "%N(%m):%03n:%i %~> ".tap {|s| def s.dup; gsub('%~', Dir.pwd); end }
  
  Wirble.init
  Wirble.colorize

  alias q exit

  if(defined? ActiveRecord) then
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end

rescue LoadError => err
  warn "Unable to load Wirble (maybe: gem install wirble)"
end

