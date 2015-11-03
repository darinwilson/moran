# -*- encoding: utf-8 -*-

$:.push File.expand_path("../motion", __FILE__)
require "moran/version"

Gem::Specification.new do |spec|
  spec.name = "moran"
  spec.summary = "Simple JSON parsing and generation for RubyMotion Android"
  spec.description = "Moran is a simple JSON parser/outputter for RubyMotion Android"
  spec.authors = ["Darin Wilson"]
  spec.email = "darinwilson@gmail.com"
  spec.homepage = "http://github.com/darinwilson/moran"
  spec.version = Moran::VERSION
  spec.license = "MIT"

  files = []
  files << "README.md"
  files << "LICENSE"
  files.concat(Dir.glob("lib/**/*.rb"))
  files.concat(Dir.glob("motion/**/*.rb"))
  spec.files = files

  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "motion-gradle", "~> 2.0"
  spec.add_development_dependency "bacon"
  spec.add_development_dependency "rake"
end
