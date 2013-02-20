class ProxyFetcher::Proxy
  attr_reader :ip, :port, :type, :ssl, :registered_at, :country_code, :ssl, :latency, :reliability 

  def initialize(attributes = {})
  	attrs = attributes.clone.with_indifferent_access

  	@ip = attrs[:ip]
  	@port = attrs[:port]
  	@registered_at = attrs[:registered_at]
  	@country_code = attrs[:country_code]
  	@ssl = attrs[:ssl]
  	@latency = attrs[:latency]
  	@reliability = attrs[:reliability]
  	@source = attrs[:source]
  end
end