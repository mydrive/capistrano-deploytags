require 'rake'

$:.unshift(File.expand_path("lib"))

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = %w[--color --format=documentation]
    t.pattern = "spec/**/*_spec.rb"
  end

  task :default => [:spec]
rescue LoadError
  # don't generate Rspec tasks if we don't have it installed
end

task :build do
  system "gem build capistrano-deploytags.gemspec"
end
