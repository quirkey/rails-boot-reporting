require 'bundler'

module RailsBootReporting
  extend self

  def install
    install_rails
    install_bundler
    puts "Done."
  end

  def install_rails
    puts "-- Installing Rails patches"
    install_file('rails-2.3.14/initializer.rb', gem_path('rails', '2.3.14', 'initializer.rb'))
  end

  def install_bundler
    puts "-- Installing Bundler patches"
    bundler_version = Bundler::VERSION
    short_version = bundler_version.split('.', 3)[0..1].join('.')
    install_file("bundler-#{short_version}/runtime.rb", gem_path('bundler', bundler_version, 'bundler/runtime.rb'))
  end

  def gem_path(gem, version, file)
    install_path = File.join(ENV['BUNDLE_DIR'] || ENV['GEM_HOME'], 'gems', "#{gem}-#{version}", 'lib', file)
  end

  def install_file(local_path, install_path)
    local_path = File.join(File.dirname(File.expand_path(__FILE__)), local_path)
    puts "Copying #{local_path} to #{install_path}"
    FileUtils.cp(local_path, install_path)
  end

end
