require 'rubygems'
require 'rake'
begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name        = "linky"
    gemspec.summary     = "A library for safely linking keywords to urls within HTML content."
    gemspec.description = "A library for safely linking keywords to urls within HTML content."
    gemspec.email       = "moonmaster9000@gmail.com"
    gemspec.files       = FileList['lib/**/*.rb', 'README.markdown']
    gemspec.homepage    = "http://github.com/moonmaster9000/linky"
    gemspec.authors     = ["Matt Parker"]
    gemspec.add_dependency('nokogiri', '>= 1.4.3.1')
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install jeweler"
end
