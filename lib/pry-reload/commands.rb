Pry.hooks.add_hook(:before_session, "reload-init"){ |output, b, pry|
  PryReload::Watch.instance
#  output.puts("Reload Innit")
}

Pry::Commands.block_command "reload!", "Reload changed files since the session started" do 
  PryReload::Watch.instance.reload!(output)
end
