require 'byebug'
require 'net/http'
require 'net/https'
require 'uri'
require 'json'

class Ring
  def initialize(username:, password:)
    @username = username
    @password = password
  end

  def authenticate
    uri = URI.parse('https://api.ring.com/clients_api/session')
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    headers = {
      'Accept-Encoding' => 'gzip, deflate',
      'User-Agent' => 'Dalvik/1.6.0 (Linux; U; Android 4.4.4; Build/KTU84Q)',
      'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8'
    }



    post_data = {
      "device" => {
        "os" => "andriod",
        "hardware_id" => "180940d0-7285-3366-8c64-6ea91491982c'",
        "app_brand" => "ring",
        "metadata" => {
        "device_model" => "VirtualBox",
        "resolution" => "600x800",
        "app_version" => "1.7.29",
        "app_instalation_date" => "",
        "os_version" => "4.4.4",
        "manufacturer" => "innotek GmbH",
        "is_tablet" => "true",
        "linphone_initialized" => "true",
        "language" => "en"
      },
      "api_version" => "8"
      }
    }


    post_data = "device%5Bos%5D=android&device%5Bhardware_id%5D=180940d0-7285-3366-8c64-6ea91491982c&device%5Bapp_brand%5D=ring&device%5Bmetadata%5D%5Bdevice_model%5D=VirtualBox&device%5Bmetadata%5D%5Bresolution%5D=600x800&device%5Bmetadata%5D%5Bapp_version%5D=1.7.29&device%5Bmetadata%5D%5Bapp_instalation_date%5D=&device%5Bmetadata%5D%5Bos_version%5D=4.4.4&device%5Bmetadata%5D%5Bmanufacturer%5D=innotek+GmbH&device%5Bmetadata%5D%5Bis_tablet%5D=true&device%5Bmetadata%5D%5Blinphone_initialized%5D=true&device%5Bmetadata%5D%5Blanguage%5D=en&api_version=8"

    request = Net::HTTP::Post.new(uri.path, headers)
    request.body = post_data
    request.basic_auth @username, @password


    result = https.request request
    exit unless result.code == "201"
    authentication_token =  JSON.parse(result.body)['profile']['authentication_token']
    puts "Authenticated: #{authentication_token}"

  end
end
