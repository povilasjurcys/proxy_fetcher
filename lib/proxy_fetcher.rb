require 'open-uri'
require "proxy_fetcher/version"
require "proxy_fetcher/proxy"

module ProxyFetcher
  SOURCES = ["http://www.xroxy.com/proxyrss.xml"]
  @@list = nil

  def self.list
    return @@list if @@list.present?

    list = {}
    SOURCES.each do |url|
      xml = Nokogiri::XML(open url)
      xml.xpath("//prx:proxy").each do |proxy|
        list["#{ip}:#{port}"] ||= ProxyFetcher::Proxy.new(self.xml_node_to_hash proxy, url)
      end
    end
    @@list = list.to_a.map(&:last)
  end

  def self.xml_node_to_hash(node, source)
    ip = proxy.xpath("prx:ip").text
    port = proxy.xpath("prx:port").text
    
    {
      ip: ip, 
      port: port,
      type: proxy.xpath("prx:type").text,
      ssl: proxy.xpath("prx:type").text.downcase == "true",
      registered_at: Time.at(proxy.xpath("prx:check_timestamp").text.to_i),
      country_code: proxy.xpath("prx:country_code").text,
      latency: proxy.xpath("prx:latency").text.to_i,
      reliability: proxy.xpath("prx:reliability").text.to_i,
      source: source
    }   
  end

  def self.random_proxy
    self.list.sample
  end
end
