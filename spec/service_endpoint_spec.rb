require 'spec_helper'
require 'service_endpoint'

describe ::Fewbytes::Chef::ServiceDiscovery::ServiceEndpoint do
  service_provider_location = "i-3222321/us-east-1c/us-east-1"
  sample_data = { 
    name: "sample_service",
    location: service_provider_location.split("/"),
    public_address: "182.233.21.143",
    data: {},
    type: "mysql-db"
  }
  describe "#distance" do
    it "should return 0 if service is in the same location" do
      service_endpoint = Fewbytes::Chef::ServiceDiscovery::ServiceEndpoint.new(service_provider_location, sample_data)
      service_endpoint.distance.should eq 0
    end
    it "should return 2 for different availability zones" do
      Fewbytes::Chef::ServiceDiscovery::ServiceEndpoint.new(
        "i-222322/us-east-1b/us-east-1", sample_data 
      ).distance.should eq 2
    end
    it "should return 3 for different regions/clouds" do
      Fewbytes::Chef::ServiceDiscovery::ServiceEndpoint.new(
        "i-222322/us-west-1b/us-west-1", sample_data 
      ).distance.should eq 3
    end
    it "should return 3 for different clouds even if zone/rack is the same" do
      Fewbytes::Chef::ServiceDiscovery::ServiceEndpoint.new(
        "i-222322/us-east-1c/us-west-1", sample_data 
      ).distance.should eq 3
    end
    describe "Additional component in location" do
      it "should return 4 if consumer location contains aditional component" do
      Fewbytes::Chef::ServiceDiscovery::ServiceEndpoint.new(
        "i-222322/us-east-1c/us-west-1/new_comp", sample_data 
      ).distance.should eq 4
      end
      it "should return 3 if consumer location is missing cloud" do
        Fewbytes::Chef::ServiceDiscovery::ServiceEndpoint.new(
          "i-222322/us-east-1c", sample_data 
        ).distance.should eq 3
      end
    end
    describe "#address" do
      it "should return private address when available" do
        Fewbytes::Chef::ServiceDiscovery::ServiceEndpoint.new(
          "i-222322/us-east-1c/us-east-1", sample_data.merge({:private_address => "192.168.0.1"}) 
        ).address.should eq "192.168.0.1"
      end
      it "should return public address when using different clouds" do
        Fewbytes::Chef::ServiceDiscovery::ServiceEndpoint.new(
          "i-222322/us-west-1c/us-west-1", sample_data.merge({:private_address => "192.168.0.1"})
        ).address.should eq "182.233.21.143"
      end
      it "should return public address when no private address is available" do
        Fewbytes::Chef::ServiceDiscovery::ServiceEndpoint.new(
          "i-222322/us-west-1c/us-west-1", sample_data
        ).address.should eq "182.233.21.143"
      end

    end
  end
end
