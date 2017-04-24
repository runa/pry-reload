require 'pry'

Pry.hooks.add_hook(:before_session, 'reload-init') do
  PryReload::Watch.instance
end

Pry::Commands.block_command 'reload!', 'Reload changed files since the session started' do
  PryReload::Watch.instance.reload!(output)
end
