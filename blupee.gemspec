# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'blupee/version'

Gem::Specification.new do |spec|
  spec.name          = "blupee"
  spec.version       = Blupee::VERSION
  spec.authors       = ["Blupee Inc."]
  spec.email         = ["admin@blupee.io"]
  spec.summary       = %q{Gem to wrap blupee.io API}
  spec.description   = %q{Official Gem to wrap blupee.io API}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = Dir['lib/**/*.rb']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.homepage      = 'https://github.com/fogonthedowns/blupee_ruby'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", '~> 10.4.2', '>= 12.0.1'
  spec.add_development_dependency "minitest", '~> 5.8.3', '>= 5.10.2'
  spec.add_development_dependency "vcr", '~> 3.0.0', '>= 3.0.3'
  spec.add_development_dependency "pry", '~> 0.10.0', '>= 0.10.9'
  spec.add_development_dependency "webmock", '~> 3.1.0', '>= 3.1.9'

  spec.add_dependency "faraday", '~> 0.11.0'
  spec.add_dependency "json", '~> 1.8', '>= 1.8.3'
end
