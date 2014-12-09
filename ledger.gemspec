# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ledger/version'

Gem::Specification.new do |s|
  s.name          = "ledger"
  s.version       = Ledger::VERSION
  s.authors       = ["Varun Srinivasan"]
  s.email         = ["varunsrin@gmail.com"]
  s.summary       = %q{Accounting module to settle account balances}
  s.homepage      = "https://github.com/varunsrin/ledger"
  s.license       = "MIT"

  s.required_ruby_version = ">= 1.9.2"

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "pry"
end
