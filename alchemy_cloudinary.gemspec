# frozen_string_literal: true

$:.push File.expand_path("lib", __dir__)

require "alchemy_cloudinary/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = "alchemy_cloudinary"
  s.version = AlchemyCloudinary::VERSION
  s.authors = ["Thomas von Deyen"]
  s.email = ["thomas@vondeyen.com"]
  s.homepage = "https://alchemy-cms.com"
  s.summary = "AlchemyCMS Cloudinary Integration."
  s.description = "Render AlchemyCMS images directly from cloudinary."
  s.license = "MIT"

  s.files = Dir["app/**/*", "lib/**/*", "MIT-LICENSE", "README.md"]

  s.add_dependency "alchemy_cms", [">= 8.0.0.c", "< 9.0"]
  s.add_dependency "cloudinary", "~> 2.0"

  s.add_development_dependency "rspec-rails", "~> 6.0"
  s.add_development_dependency "sqlite3", ">= 2.1"
end
