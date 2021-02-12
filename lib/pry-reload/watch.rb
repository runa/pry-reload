require 'listen'
require 'thread'
require 'singleton'

class PryReload
  class Watch
    include Singleton

    @@mutex = Mutex.new

    def initialize
      @modified = []
      setup
      process
    end

    def dirs
      Dir.glob(['**/', '.'])
    end

    def setup
      @listener ||= Listen.to(*dirs, only: %r{.rb$}) do |modified, added, removed|
        [*modified, *added].each { |file| @@mutex.synchronize { @modified << file } }
        removed.each { |file| @@mutex.synchronize { @modified.delete(file) } }
      end
    end

    def process
      @thread ||= Thread.new do
        # puts "Running!"
        @listener.start
      end
    end

    def reload!(output)
      @@mutex.synchronize do
        if @modified.length.zero?
          output.puts 'Nothing changed!'
        else
          changed = @modified.dup.uniq
          @modified = []
          while path = changed.shift
            output.puts "Reloading #{path}"
            load path
          end
        end
      end
    end
  end
end
