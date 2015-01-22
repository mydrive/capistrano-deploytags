Gem::Specification.new do |s|
  s.name        = 'capistrano-deploytags'
  s.license     = 'BSD-2-Clause'
  s.version     = '1.0.1'
  s.date        = '2014-06-14'
  s.summary     = 'Add dated, environment-specific tags to your git repo at each deployment.'
  s.description = <<-EOS 
  Capistrano Deploytags is a simple plugin to Capistrano 3 that works with your deployment framework to track your code releases. All you have to do is require capistrano-deploytags/capistrano and each deployment will add a new tag for that deployment, pointing to the latest commit. This lets you easily see which code is deployed on each environment, and allows you to figure out which code was running in an environment at any time in the past.
  EOS
  s.authors     = ['Karl Matthias', 'Gavin Heavyside']
  s.email       = ['relistan@gmail.com', 'gavin.heavyside@mydrivesolutions.com']
  s.files       = `git ls-files lib`.split(/\n/) + %w{ README.md LICENSE }
  s.homepage    = 'http://github.com/mydrive/capistrano-deploytags'
  s.add_dependency 'capistrano', '>= 3.2.0'
#  s.add_development_dependency 'capistrano-spec'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 3.0.0'
  s.require_path = 'lib'
end
