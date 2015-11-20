require 'net/https'
require 'time'
require 'api-auth'
require 'json'

URL = 'https://anish-support.mingle-api.thoughtworks.com/api/v2/projects/house_build/cards.xml'
OPTIONS = {:access_key_id => 'anishn', :access_secret_key => 'U0VOB8gw0UQYwF4zjyxtqnCXmFJXm70itEfIwP/Odgo='}
PARAMS = {
  :card => {
    :card_type_name => "Story", :name => "Test Story Card"
    }
  }

def http_post(url, params, options={})
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  body = params.to_json

  request = Net::HTTP::Post.new(uri.request_uri)
  request.body = body
  request['Content-Type'] = 'application/json'
  request['Content-Length'] = body.bytesize

  ApiAuth.sign!(request, options[:access_key_id], options[:access_secret_key])

  response = http.request(request)
  card = response.body

  if response.code.to_i > 300
    raise StandardError, <<-ERROR
    Request URL: #{url}
    Response: #{response.code}
    Response Message: #{response.message}
    Response Headers: #{response.to_hash.inspect}
    Response Body: #{response.body}
    ERROR
  end

  card
end

http_post(URL, PARAMS, OPTIONS)
