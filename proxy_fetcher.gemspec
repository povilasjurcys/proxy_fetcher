# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'proxy_fetcher/version'

Gem::Specification.new do |gem|
  gem.name          = "proxy_fetcher"
  gem.version       = ProxyFetcher::VERSION
  gem.authors       = ["Povilas Jurčys"]
  gem.email         = ["povilas@d9.lt", "bloomrain@gmail.com"]
  gem.description   = %q{Use this gem to get newest free proxies list from various sources}
  gem.summary       = %q{Use this gem to get newest free proxies list from various sources}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "nokogiri"
end
