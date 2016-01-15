Gem::Specification.new do |s|
  s.platform     = Gem::Platform::RUBY
  s.name         = 'solidus_digital'
  s.version      = '1.1.0'
  s.summary      = ''
  s.description  = 'Digital download functionality for spree'
  s.author       = 'Saman Mohamadi'
  s.email        = 'mohamadi.saman@gmail.com'
  s.homepage     = 'https://github.com/samanmohamadi/solidus_digital.git'
  # s.files        = `git ls-files`.split("\n")
  # s.test_files   = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'
  s.required_ruby_version = '>= 2.1.0'

  s.add_dependency 'solidus_api'
  s.add_dependency 'solidus_backend'
  s.add_dependency 'solidus_core'
  s.add_dependency 'solidus_frontend'

  # test suite
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'coffee-script'
  s.add_development_dependency 'factory_girl_rails', '~> 4.5.0'
  s.add_development_dependency 'rspec-rails', '~> 3.0'
  s.add_development_dependency 'rspec-activemodel-mocks', '1.0.0'
  s.add_development_dependency 'sass-rails', '~> 4.0.2'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'database_cleaner', '1.0.1'
  s.add_development_dependency 'simplecov', '~> 0.7.1'
end
