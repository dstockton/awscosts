require 'httparty'

class AWSCosts::EBS

  TYPES = {
            'Amazon EBS Magnetic volumes' => :standard,
            'Amazon EBS General Purpose (SSD) volumes' => :gp2,
            'Amazon EBS Provisioned IOPS (SSD) volumes' => :io1,
            'ebsSnapsToS3' => :snapshots_to_s3
  }

  def initialize data
    @data= data
  end

  def price type = nil
    type.nil? ? @data : @data[type]
  end

  def self.fetch region
    transformed = AWSCosts::Cache.get_jsonp('/pricing/1/ebs/pricing-ebs.min.js') do |data|
      result = {}
      data['config']['regions'].each do |r|
        result[r['region']] = r['types']
      end
      result
    end
    self.new(transformed[region])
  end

end

