# option I
#
provides "mysql-db" do
  # ? subtype
  backend "chef"
  data :port => 3306, :private_address => "192.168.2.2", :public_address => "182.112.221.1", :protocol => "mysql"
  name "my awesom db"
  scope :environment
end

# option II
provides("mysql-db", "my awesome db", :scope => :environment, :data => {:port => 3306 ... })

# cosumers, PAAS/IAAS
endpoint_for("mysql-db", :scope => :environment, :including_down => true)

# consumers, SAAS
endpoint_for("facebook-api", :scope => :universe)
