lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'date_breakup'

Gem::Specification.new do |spec|
  spec.name          = 'date_breakup'
  spec.version       = DateBreakup::VERSION
  spec.authors       = ['Huzaifa Saifuddin']
  spec.email         = ['Huzaifa@Huzaifas-MacBook-Pro.local']

  spec.summary       = 'Feed in 2 dates and get a breakup of dates grouped in years, months, weeks & days'
  spec.description   = 'Feed in 2 dates and get a breakup of dates grouped in years, months, weeks & days'
  spec.homepage      = 'https://github.com/HuzaifaSaifuddin/date_breakup'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.2', '>= 2.2.20'
  spec.add_development_dependency 'pry', '~> 0.14.1'
  spec.add_development_dependency 'rake', '~> 13.0', '>= 13.0.3'
  spec.add_development_dependency 'rspec', '~> 3.10'

  spec.add_runtime_dependency 'date', '~> 3.1', '>= 3.1.1'
end
