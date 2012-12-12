module ::Fewbytes
  module Chef
    module ServiceDiscovery
      class ServiceEndpoint
        attr_reader :data
        attr_reader :location
        attr_reader :port
        attr_reader :private_address
        attr_reader :public_address
        attr_reader :status
        attr_reader :uri

        def initialize(consumer_location, service_data)
          @consumer_location = consumer_location.is_a?(Array) ? consumer_location : consumer_location.split("/").delete_if(&:empty?)
          @location = service_data[:location]
          @public_address = service_data[:public_address]
          @private_address = service_data.fetch(:private_address, @public_address)
          @port = service_data[:port]
          @protocol = service_data[:protocol]
          @data = service_data[:data]
          @status = service_data[:status]
          @uri = service_data[:uri] || "#{@protocol}://#{address}:#{port}"
        end

        # return the correct address for the consumer location
        def address
          if distance >= 3
            public_address
          else
            private_address
          end
        end

        def distance
          return location.length + 1 if location.length < @consumer_location.length # consumer_location has extra components
          zip_diff = location.zip(@consumer_location).select{|(a,b)| a != b} 
          unless zip_diff.empty?  
            location.find_index{|c| c == zip_diff.last.first} + 1
          else
            0
          end
        end
      end
    end
  end
end
