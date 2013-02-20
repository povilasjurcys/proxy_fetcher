require 'open-uri'
require "proxy_fetcher/version"
require "proxy_fetcher/proxy"

module ProxyFetcher
  SOURCES = [
    "http://www.xroxy.com/proxyrss.xml", 
    "http://www.freeproxylists.com/rss", 
    "http://www.proxz.com/proxylists.xml"
  ]
  
  @@list = nil

  def self.list
    return @@list if @@list.present?

    list = {}
    SOURCES.each do |url|
      xml = Nokogiri::XML(open url)
      xml.xpath("//prx:proxy").each do |node|
        proxy = ProxyFetcher::Proxy.new( self.xml_node_to_hash(node, url) )
        list["#{proxy.ip}:#{proxy.port}"] ||= proxy
      end
    end
    @@list = list.to_a.map(&:last)
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
