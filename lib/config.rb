Sidekiq.configure_server do |config|
  config.error_handlers << Proc.new {|ex,ctx_hash| Parser.notify(ex, ctx_hash) }
end