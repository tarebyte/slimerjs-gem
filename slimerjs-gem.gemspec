# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'slimerjs/version'

Gem::Specification.new do |spec|
  spec.name          = "slimerjs-gem"
  spec.version       = Slimerjs::VERSION
  spec.authors       = ["Mark Tareshawty"]
  spec.email         = ["tarebyte@gmail.com"]
  spec.licenses      = ['MIT']
  spec.summary       = %q{Auto-install slimerjs on demand for current platform.}
  spec.description   = %q{Auto-install slimerjs on demand for current platform.}
  spec.homepage      = "https://github.com/tarebyte/slimerjs-gem"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
