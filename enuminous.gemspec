Gem::Specification.new do |gem|
  gem.name = 'enuminous'
  gem.version = '0.0.1'

  gem.summary = 'Checked enums'
  gem.description = <<-DESC
Enums that are checked
  DESC

  gem.authors = ['Sam Stokes']
  gem.email = %w(me@samstokes.co.uk)
  gem.homepage = 'http://github.com/samstokes/enuminous'


  gem.add_development_dependency 'rspec'


  gem.files = Dir[*%w(
      lib/**/*
      README*)] & %x{git ls-files -z}.split("\0")
end
