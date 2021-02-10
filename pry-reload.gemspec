# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pry-reload/version'

Gem::Specification.new do |spec|
  spec.name          = "pry-reload"
  spec.version       = PryReload::VERSION
  spec.authors       = ["martin sarsale"]
  spec.email         = ["martin@malditainternet.com"]

  spec.summary       = %q{Tracks and reloads changed files}
  spec.homepage      = "https://github.com/runa/pry-reload"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_dependency "listen", "~> 3.4"
end
