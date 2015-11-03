unless defined?(Motion::Project::App)
  raise "This must be required from within a RubyMotion Rakefile"
end

Motion::Project::App.setup do |app|
  require "motion-gradle"

  parent = File.join(File.dirname(__FILE__), '..')
  files = [File.join(parent, 'motion/moran/version.rb')]
  files << Dir.glob(File.join(parent, "motion/**/*.rb"))
  files.flatten!.uniq!
  app.files.unshift files

  app.gradle do
    dependency "com.fasterxml.jackson.core:jackson-core:+"
    dependency "com.fasterxml.jackson.core:jackson-annotations:+"
    dependency "com.fasterxml.jackson.core:jackson-databind:+"
  end
end
