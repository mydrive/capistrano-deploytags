Dir[File.join(File.dirname(__FILE__), 'capistrano', '*')].each do |file|
  require file
end
