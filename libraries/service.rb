module Fewbytes::Chef::ServiceDiscovery
  class Service
    class << self
      def register(service_type, service_name, opts)
        if opts[:backend]
          backends[opts[:backend]].register(service_type, service_name, opts)
        else
          default_backend.register(service_type, service_name, opts)
        end
      end
      attr_reader :default_backend
      attr_reader :backends
    end
  end
end
