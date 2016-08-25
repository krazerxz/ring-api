require "byebug"
require "json"
require "active_support/core_ext/object/to_param"

API_VERSION          = "8".freeze
API_URI              = "https://api.ring.com".freeze
NEW_SESSION_ENDPOINT = "/clients_api/session".freeze
DINGS_ENDPOINT       = "/clients_api/dings/active".freeze
DEVICES_ENDPOINT     = "/clients_api/devices".freeze

class Ring
  def initialize(username:, password:)
    @username = username
    @password = password
    @auth_token = nil
  end

  def dings
    uri = URI.parse(API_URI + DINGS_ENDPOINT)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    post_data = {
      "api_version" => API_VERSION,
      "auth_token" => @auth_token
    }

    request = Net::HTTP::Post.new(uri.path)
    request.body = post_data.to_param
    result = https.request request
    exit unless result.code == "201"
  end

  def authenticate
    uri = URI.parse(API_URI + NEW_SESSION_ENDPOINT)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    post_data = {
      "device[os]" => "android",
      "device[hardware_id]" => "hardware_id",
      "device[app_brand]" => "ring",
      "device[metadata][device_model]" => "",
      "device[metadata][resolution]" => "600x800",
      "device[metadata][app_version]" => "1.7.29",
      "device[metadata][app_instalation_date]" => "",
      "device[metadata][os_version]" => "4.4.4",
      "device[metadata][manufacturer]" => "innotek GmbH",
      "device[metadata][is_tablet]" => "true",
      "device[metadata][linphone_initialized]" => "true",
      "device[metadata][language]" => "en",
      "api_version" => API_VERSION
    }

    request = Net::HTTP::Post.new(uri.path)
    request.body = post_data.to_param
    request.basic_auth @username, @password

    result = https.request request
    exit unless result.code == "201"
    authentication_token =  JSON.parse(result.body)["profile"]["authentication_token"]
    @authentication_token = authentication_token
  end
end
