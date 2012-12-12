module Fewbytes::Chef::ServiceDiscovery::Interface
  # params:
  # @service_type - type of service, should (hopefully) match a known interface
  # @service_name - a name of this service instance
  # @opts - a hash of options. known options:
  #   :backend - register this service on a specified backend instead of the default/all
  #   :scope - register for a specific scope, values: node, environment(default), universe
  #   :data - extra data to help consumers connect to this service
  def provides(service_type, service_name, opts)
    Fewbytes::Chef::ServiceDiscovery::Service.register(service_type, service_name, opts)
  end

  def endpoint_for(service_type, opts)
    endpoints_for(service_type, opts).first
  end

  def endpoints_for(service_type, opts)
    Fewbytes::Chef::ServiceDiscovery::Service.find(service_type, opts).sort do |s|
      s.distance
    end
  end
end
