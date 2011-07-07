# patches Bundler.require specifically to print require times
require 'benchmark'
module Bundler
  class Runtime < Environment

    def require(*groups)
      groups.map! { |g| g.to_sym }
      groups = [:default] if groups.empty?

      @definition.dependencies.each do |dep|
        # Skip the dependency if it is not in any of the requested
        # groups
        next unless ((dep.groups & groups).any? && dep.current_platform?)

        required_file = nil

        begin
          # Loop through all the specified autorequires for the
          # dependency. If there are none, use the dependency's name
          # as the autorequire.
          Array(dep.autorequire || dep.name).each do |file|
            required_file = file
            total = Benchmark.realtime {
              Kernel.require file
            }
            puts "Bundler.require #{file}\t#{total}"
          end
        rescue LoadError => e
          REGEXPS.find { |r| r =~ e.message }
          raise if dep.autorequire || $1 != required_file
        end
      end
    end

  end
end
