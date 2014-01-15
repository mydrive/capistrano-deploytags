Gem::Specification.new do |s|
  s.name        = 'capistrano-deploytags'
  s.version     = '0.9.1'
  s.date        = '2014-01-14'
  s.summary     = "Add dated, environment-specific tags to your git repo at each deployment."
  s.description = <<-EOS 
  Capistrano Deploytags is a simple plugin to Capistrano that works with your deployment framework to track your code releases. All you have to do is require capistrano-deploytags and each deployment will add a new tag for that deployment, pointing to the latest commit. This lets you easily see which code is deployed on each environment, and allows you to figure out which code was running in an environment at any time in the past.
  EOS
  s.authors     = ["Karl Matthias"]
  s.email       = 'relistan@gmail.com'
  s.files       = `git ls-files`.split(/\n/) + %w{ README.md LICENSE }
  s.homepage    = 'http://github.com/mydrive/capistrano-deploytags'
  s.add_dependency 'capistrano'
  s.add_dependency 'capistrano-ext'
  s.require_path = 'lib'
end
