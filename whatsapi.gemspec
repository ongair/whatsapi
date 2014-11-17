# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'whatsapi/version'

Gem::Specification.new do |spec|
  spec.name          = "whatsapi"
  spec.version       = Whatsapi::VERSION
  spec.authors       = ["Trevor Kimenye"]
  spec.email         = ["trevor@sprout.co.ke"]
  spec.summary       = %q{Ruby API to connect to WhatsApp}
  spec.description   = %q{Ruby API to connect to WhatsApp}
  spec.homepage      = "https://github.com/sproutke/whatsapi"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = "~> 1.9.3"
  spec.add_dependency 'activesupport'
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry-debugger"

end