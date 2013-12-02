require "bundler/gem_tasks"
require 'rake/testtask'

desc 'Default: run all tests'
task :default => [:test]

desc 'Run all DataSift unit tests'
Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
end
