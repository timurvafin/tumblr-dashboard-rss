require 'rubygems'
require 'rake'
require 'rake/rdoctask'
require 'jeweler'
require 'cucumber/rake/task'

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

Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "tumblr_dashboard_rss #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Cucumber::Rake::Task.new

task :default => :cucumber
