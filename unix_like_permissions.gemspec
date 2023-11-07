# frozen_string_literal: true

require_relative "lib/unix_like_permissions/version"

Gem::Specification.new do |spec|
  spec.name          = "unix_like_permissions"
  spec.version       = UnixLikePermissions::VERSION
  spec.authors       = ["Your Name"]
  spec.email         = ["your_email@example.com"]

  spec.summary       = %q{Unix-like permissions management for Ruby applications}
  spec.description   = %q{This gem provides a robust system for managing Unix-like permissions in Ruby. It allows for setting, querying, and serializing permission sets with an ActiveRecord integration for easy database storage.}
  spec.homepage      = "https://github.com/tee0zed/unix_like_permissions"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.6.0")

  spec.metadata = {
    "allowed_push_host" => "https://rubygems.org", # You can restrict which hosts can push the gem here.
    "homepage_uri"      => spec.homepage,
    "source_code_uri"   => "https://github.com/your_username/unix_like_permissions",
    "changelog_uri"     => "https://github.com/your_username/unix_like_permissions/blob/main/CHANGELOG.md"
  }

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(bin|test|spec|features|\.git|\.circleci|appveyor|Gemfile)\z}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec"
end
