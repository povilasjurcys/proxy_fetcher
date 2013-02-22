require 'open-uri'
require "proxy_fetcher/version"
require "proxy_fetcher/proxy"

module ProxyFetcher
  SOURCES = [
    "http://www.xroxy.com/proxyrss.xml", 
    "http://www.freeproxylists.com/rss", 
    "http://www.proxz.com/proxylists.xml"
  ]
  SOURCE_CACHE_DURATION = 12.hours
  
  @@list = nil

  def self.list
    return @@list if @@list.present?

    list = {}
    SOURCES.each do |url|
      xml = Nokogiri::XML(self.xml_source url)

      xml.xpath("//prx:proxy").each do |node|
        proxy = ProxyFetcher::Proxy.new( self.xml_node_to_hash(node, url) )
        list["#{proxy.ip}:#{proxy.port}"] ||= proxy
      end
    end
    @@list = list.to_a.map(&:last)
  end

  def self.xml_source(url)
    source_key = "proxy_fetcher/xml_source:#{url}"
    date_key = "#{source_key}/last_updated"

    xml = ""
    if Rails.cache.exist?(source_key) and Time.now - Rails.cache.read(date_key) > SOURCE_CACHE_DURATION
      xml = Rails.cache.read(source_key)
    else
      begin
        xml = open(url)
        Rails.cache.write(source_key, xml.to_s)
        Rails.cache.write(date_key, Time.now)
      rescue Exception => e
        raise e unless e.is_a?(Timeout::Error)
      end      
    end
    xml
  end

  def self.xml_node_to_hash(node, source)
    ip = node.xpath("prx:ip").text
    port = node.xpath("prx:port").text
    
    {
      ip: ip, 
      port: port,
      type: node.xpath("prx:type").text,
      ssl: node.xpath("prx:ssl").text.downcase == "true",
      registered_at: Time.at(node.xpath("prx:check_timestamp").text.to_i),
      country_code: node.xpath("prx:country_code").text,
      latency: node.xpath("prx:latency").text.to_i,
      reliability: node.xpath("prx:reliability").text.to_i,
      source: source
    }   
  end

  def self.random_proxy
    self.list.sample
  end
end
