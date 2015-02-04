require 'awscosts/ec2_on_demand'
require 'awscosts/ec2_spot'
require 'awscosts/ec2_reserved_instances'
require 'awscosts/ec2_elb'
require 'awscosts/ec2_ebs'
require 'awscosts/ec2_ebs_optimized'
require 'awscosts/ec2_elastic_ips'

class AWSCosts::EC2

  attr_reader :region

  TYPES = { windows: 'mswin', linux: 'linux', windows_with_sql: 'mswinSQL',
            windows_with_sql_web: 'mswinSQLWeb', rhel: 'rhel', sles: 'sles' }

  def initialize region
    @region = region
  end

  def on_demand(type)
    raise ArgumentError.new("Unknown platform: #{type}") if TYPES[type].nil?
    AWSCosts::EC2OnDemand.fetch(TYPES[type], self.region.name)
  end

  def spot(type)
    raise ArgumentError.new("Unknown platform: #{type}") if TYPES[type].nil?
    AWSCosts::EC2Spot.fetch(TYPES[type], self.region.price_mapping)
  end

  def reserved(type, utilisation = :light)
    r = self.region.name
    r = 'us-east' if r == 'us-east-1'
    raise ArgumentError.new("Unknown platform: #{type}") if TYPES[type].nil?
    AWSCosts::EC2ReservedInstances.fetch(TYPES[type], utilisation, r)
  end

  def elb
    AWSCosts::ELB.fetch(self.region.price_mapping)
  end

  def ebs
    AWSCosts::EBS.fetch(self.region.price_mapping)
  end

  def ebs_optimized
    r = self.region.name
    r = 'us-east' if r == 'us-east-1'
    AWSCosts::EBSOptimized.fetch(r)
  end

  def elastic_ips
    AWSCosts::ElasticIPs.fetch(self.region.price_mapping)
  end
end


