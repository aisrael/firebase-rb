# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts 'Run `bundle install` to install missing gems'
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = 'firebase'
  gem.homepage = 'http://github.com/aisrael/firebase-rb'
  gem.license = 'MIT'
  gem.summary = 'Firebase REST API Ruby Gem'
  gem.description = 'Firebase REST API Ruby Gem'
  gem.email = 'aisrael@gmail.com'
  gem.authors = ['Alistair A. Israel']
  gem.files             = `git ls-files`.split("\n")
  gem.test_files        = `git ls-files -- {test,spec}/*`.split("\n")
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core/rake_task'
desc 'Run RSpec tests'
RSpec::Core::RakeTask.new(:test) do |test|
  test.verbose = true
end

desc 'Code coverage detail'
task :simplecov do
  ENV['COVERAGE'] = 'true'
  Rake::Task['test'].execute
end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features)

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ''

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "firebase #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
