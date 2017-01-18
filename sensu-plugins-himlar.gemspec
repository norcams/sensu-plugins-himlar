lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require_relative 'lib/sensu-plugins-himlar'

Gem::Specification.new do |s|
  s.name          = 'sensu-plugins-himlar'
  s.version       = SensuPluginsHimlar::Version::VER_STRING
  s.author        = 'Norcams'
  s.platform      = Gem::Platform::RUBY
  s.homepage      = 'https://github.com/norcams/sensu-plugins-himlar'
  s.summary       = 'Sensu Plugins Himlar'
  s.description   = 'Sensu plugins used in himlar'
  s.email         = 'post@uh-iaas.no'
  s.license       = 'MIT'
  s.has_rdoc      = false
  s.require_paths = ['lib']
  s.files         = Dir.glob('{bin,lib}/**/*') + %w(LICENSE README.md)
  s.executables   = Dir.glob('bin/**/*.rb').map { |file| File.basename(file) }
  s.test_files    = Dir['test/*.rb']

  #s.add_dependency('json',       '< 2.0.0')
  #s.add_dependency('mixlib-cli', '>= 1.5.0')

  s.add_development_dependency('rake')
  s.add_development_dependency('minitest')
end
