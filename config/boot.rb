require 'rubygems'
require 'bundler'

# Set up gems listed in the Gemfile.
gemfile = File.expand_path('../../Gemfile', __FILE__)
begin

  # For heroku
  #def FileUtils.mkdir_p(foo)
  #  puts foo
  #end

  ENV['BUNDLE_GEMFILE'] = gemfile
  Bundler.setup
rescue Bundler::GemNotFound => e
  STDERR.puts e.message
  STDERR.puts "Try running `bundle install`."
  exit!
end if File.exist?(gemfile)
