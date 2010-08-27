require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "tumblr_dashboard_rss"
    gem.summary = %Q{Generates rss feed from tumblr dashboard}
    gem.description = %Q{Generates rss feed from tumblr dashboard}
    gem.email = "me@timurv.ru"
    gem.homepage = "http://github.com/timurvafin/tumblr-dashboard-rss"
    gem.authors = ["Timur Vafin"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_development_dependency "cucumber", ">= 0"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features)

  task :features => :check_dependencies
rescue LoadError
  task :features do
    abort "Cucumber is not available. In order to run features, you must: sudo gem install cucumber"
  end
end

task :default => :features
