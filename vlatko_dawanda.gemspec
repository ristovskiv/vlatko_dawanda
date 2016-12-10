# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vlatko_dawanda/version'

Gem::Specification.new do |spec|
  spec.name          = "vlatko_dawanda"
  spec.version       = VlatkoDawanda::VERSION
  spec.authors       = ["Vlatko Ristovski"]
  spec.email         = ["ristovski.vlatko234@gmail.com"]

  spec.summary       = %q{Just an excercise gem.}
  spec.description   = %q{Just an excercise gem.}
  spec.homepage      = "https://github.com/ristovskiv/vlatko_dawanda"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry", '~> 0.10.4'
end
