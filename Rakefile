require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs = FileList[".","lib","test"]
  t.test_files = FileList["test/test_*.rb"]
  t.verbose = true
end