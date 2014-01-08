# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-scp/version'

Gem::Specification.new do |spec|
  spec.name          = "vagrant-scp"
  spec.version       = VagrantPlugins::Scp::VERSION
  spec.authors       = ["W. Andrew Loe III", "Andrew Sharpe"]
  spec.email         = ["andrew@andrewloe.com", "andrew.sharpe.7.9@gmail.com"]
  spec.description   = %q{A provisioner for Vagrant that copies files using SCP.}
  spec.summary       = %q{A provisioner for Vagrant that copies files using SCP.}
  spec.homepage      = "https://github.com/asharpe/vagrant-scp"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
