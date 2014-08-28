# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'viewcoat/version'

Gem::Specification.new do |spec|
  spec.name          = "viewcoat"
  spec.version       = Viewcoat::VERSION
  spec.authors       = ["Shu Uesugi"]
  spec.email         = ["shu@chibicode.com"]
  spec.summary       = %q{An alternative way to pass options to partials in Rails view.}
  spec.description   = %q{An alternative way to pass options to partials in Rails view.}
  spec.homepage      = "https://github.com/chibicode/viewcoat"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
