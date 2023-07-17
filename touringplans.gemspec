# frozen_string_literal: true

require_relative "lib/touringplans/version"

Gem::Specification.new do |spec|
  spec.name          = "touringplans"
  spec.version       = Touringplans::VERSION
  spec.authors       = ["captproton"]
  spec.email         = ["carl@wdwhub.net"]

  spec.summary       = "Easily access the API of touringplans.com as ruby objects."
  spec.description   = "Because ruby objects are better than json."
  spec.homepage      = "https://github.com/wdwhub/touringplans"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"]  = "https://rubygems.org"

  spec.metadata["homepage_uri"]       = spec.homepage
  spec.metadata["source_code_uri"]    = spec.homepage
  spec.metadata["changelog_uri"]      = "#{spec.homepage}/CHANGELOG.md"

  spec.add_development_dependency "awesome_print", "~> 1.9", ">= 1.9.2"
  spec.add_development_dependency "pry", "~> 0.14.1"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rubocop", "~> 1.7"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_runtime_dependency "httparty", "~> 0.21.0"
  spec.add_runtime_dependency 'dry-struct', '~> 1.4'
  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
