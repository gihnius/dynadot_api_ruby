require 'net/http'
require 'uri'
require 'openssl'

# ruby interface for:
# http://www.dynadot.com/domain/api2.html

class Dynadot

  def initialize key
    @key = key
  end

  # change key
  def key=(key)
    @key = key
  end

  # search 1.com, 2.net, 3.org
  def search(*domains)
    params = {}
    domains.each_with_index do |d, i|
      params["domain#{i}"] = d
    end
    call("search", params)
  end

  def register(domain, duration, options={})
    params = {}
    params["domain"] = domain
    params["duration"] = duration
    if !options.empty?
      params.merge! options
    end
    call("register", params)
  end

  def delete(domain)
    params = {}
    params["domain"] = domain
    call("delete", params)
  end

  def renew(domain, duration, options={})
    params = {}
    params["domain"] = domain
    params["duration"] = duration
    if !options.empty?
      params.merge! options
    end
    call("renew", params)
  end

  def getNameservers(domain)
    params = {}
    params["domain"] = domain
    call("get_ns", params)
  end

  def setNameservers(domain, *ns)
    params = {}
    ns.each_with_index do |n, i|
      params["ns#{i}"] = n
    end
    call("set_ns", params)
  end

  def setRenewOptions(domain, option)
    params = {}
    params["domain"] = domain
    params["renew-option"] = option
    call("set_renew_option", params)
  end

  def setFolder(domain, folder)
    params = {}
    params["domain"] = domain
    params["folder"] = folder
    call("set_folder", params)
  end

  private

  def call(command, params={})
    url = URI("https://api.dynadot.com/api2.html")
    params["key"] = @key
    params["command"] = command
    url.query = URI.encode_www_form(params)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url.request_uri)
    res = http.request(request)
    return res.body
  end

end
