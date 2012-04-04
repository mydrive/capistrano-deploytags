Gem::Specification.new do |s|
  s.name        = 'capistrano_deploytags'
  s.version     = '0.5'
  s.date        = '2012-04-02'
  s.summary     = "Add dated, environment-specific tags to your git repo at each deployment."
  s.description = s.summary
  s.authors     = ["Karl Matthias"]
  s.email       = 'relistan@gmail.com'
  s.files       = Dir.glob("lib/**/*") + %w{ README.md LICENSE }
  s.homepage    = 'http://github.com/mydrive/capistrano_deploytags'
  s.add_dependency 'capistrano'
  s.add_dependency 'capistrano-ext'
  s.require_path = 'lib'
end
