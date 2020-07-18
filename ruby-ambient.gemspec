require_relative 'lib/ambient/version'

Gem::Specification.new do |spec|
  spec.name          = "ruby-ambient"
  spec.version       = Ambient::VERSION
  spec.authors       = ["yukihiro amadatsu"]
  spec.email         = ["suruseas@gmail.com"]

  spec.summary       = %q{A simple library for using the Ambient API.}
  spec.description   = %q{A RubyGem library that can be used like the official python library}
  spec.homepage      = "https://github.com/suruseas/ruby-ambient"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/suruseas/ruby-ambient"
  spec.metadata["changelog_uri"] = "https://github.com/suruseas/ruby-ambient/CHANGELOG.md"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
