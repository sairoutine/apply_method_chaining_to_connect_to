require_relative 'lib/apply_method_chaining_to_connected_to/version'

Gem::Specification.new do |spec|
  spec.name          = "apply_method_chaining_to_connected_to"
  spec.version       = ApplyMethodChainingToConnectedTo::VERSION
  spec.authors       = ["sairoutine"]
  spec.email         = ["sairoutine@gmail.com"]

  spec.summary       = %q{enable to use connected_to method in rails 6.1 as a chaining method.}
  spec.homepage      = "https://github.com/sairoutine/apply_method_chaining_to_connected_to"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/sairoutine/apply_method_chaining_to_connected_to"
  spec.metadata["changelog_uri"] = "https://github.com/sairoutine/apply_method_chaining_to_connected_to/blob/master/README.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
