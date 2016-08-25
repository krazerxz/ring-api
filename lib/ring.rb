require "byebug"
require "httparty"
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
    @authentication_token = nil
  end

  def devices
    devices_url = API_URI + DEVICES_ENDPOINT
    params = {
      "api_version" => API_VERSION,
      "auth_token" => @authentication_token
    }

    http = HTTParty.get(devices_url, query: params)
    exit unless http.code == 200
    http.body
  end

  def dings
    dings_url = API_URI + DINGS_ENDPOINT
    params = {
      "api_version" => API_VERSION,
      "auth_token" => @authentication_token
    }

    http = HTTParty.get(dings_url, query: params)
    exit unless http.code == 200
    http.body
  end

  def authenticate
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

    new_session_url = API_URI + NEW_SESSION_ENDPOINT
    auth = {username: @username, password: @password}
    http = HTTParty.post(new_session_url, query: post_data, basic_auth: auth)

    exit unless http.code == 201
    authentication_token =  JSON.parse(http.body)["profile"]["authentication_token"]
    puts "Authenticated"
    @authentication_token = authentication_token
  end
end
