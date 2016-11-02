require "rb-inotify"

class PryReload
  class Watch
    include Singleton

    def initialize
      @notifier = INotify::Notifier.new
      @modified = []
      setup
      process
    end

    def dirs
      Dir.glob("**/*/");
    end

    def process_event(evt)
      if File.directory?(evt.absolute_name)
        evt.notifier.watch(evt.absolute_name)
      elsif evt.absolute_name.end_with?(".rb")
        @modified << evt.absolute_name
        #puts "modified #{evt.absolute_name}"
      end
    end

    def setup
      dirs.each do |dir|
        #puts "Listening #{dir}"
        @notifier.watch(dir, :modify, &Proc.new { |evt| process_event(evt) })
      end
    end

    def process
      Thread.new do
        #puts "Running!"
        @notifier.run
      end
    end

    def reload!(output)
      if @modified.size == 0
        output.puts "Nothing changed!"
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
