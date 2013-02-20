require "proxy_fetcher/version"

module ProxyFetcher
  SOURCES = ["http://www.xroxy.com/proxyrss.xml"]
  @@list = nil

  def self.list
    return @@list if @@list.present?
    require 'open-uri'
    list = {}
    SOURCES.each do |url|
      xml = Nokogiri::XML(open url)
      xml.xpath("//prx:proxy").each do |proxy|
        ip = proxy.xpath("prx:ip").text
        port = proxy.xpath("prx:port").text
        list["#{ip}:#{port}"] ||= {
          "ip" => ip, 
          "port" => port,
          "type" => proxy.xpath("prx:type").text,
          "ssl" => proxy.xpath("prx:type").text.downcase == "true",
          "check_timestamp" => proxy.xpath("prx:check_timestamp").text.to_i,
          "country_code" => proxy.xpath("prx:country_code").text,
          "latency" => proxy.xpath("prx:latency").text.to_i,
          "reliability" => proxy.xpath("prx:reliability").text.to_i
        }
      end
    end
    @@list = list.to_a.map(&:last)
  end

  def self.random_proxy
    self.list.sample
  end
end
