# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ledger/version'

Gem::Specification.new do |spec|
  spec.name          = "ledger"
  spec.version       = Ledger::VERSION
  spec.authors       = ["Varun Srinivasan"]
  spec.email         = ["varunsrin@gmail.com"]
  spec.summary       = %q{Accounting module to settle account balances}
  spec.homepage      = "https://github.com/varunsrin/ledger"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 1.9.2"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
