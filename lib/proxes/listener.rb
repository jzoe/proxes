require 'wisper'

module ProxES
  class Listener
    def method_missing(method, *args, &block)
      vals = { action: method }
      vals[:user] = args[0][:user] if (args[0] && args[0].has_key?(:user))
      AuditLog.create vals
    end

    def respond_to_missing?(method, include_private = false)
      true
    end
  end
end

Wisper.subscribe(ProxES::Listener.new)
