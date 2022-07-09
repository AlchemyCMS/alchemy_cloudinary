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

  s.files = Dir["lib/**/*", "MIT-LICENSE", "README.md"]

  s.add_dependency "alchemy_cms", [">= 5.1.0", "< 7.0"]
  s.add_dependency "cloudinary", "~> 1.9"
end
