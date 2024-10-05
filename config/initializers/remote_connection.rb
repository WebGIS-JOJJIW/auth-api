$api_gateway_conn = Faraday.new(
  url: ENV.fetch("API_GATEWAY_URL") { "http://159.89.116.221:8001" },
  headers: {'Content-Type' => 'application/json'},
  # request: { timeout: 600 }
) do |f|
  # no custom options available
  # f.adapter :excon, persistent: true
  # f.request :multipart
  f.request :url_encoded
  f.adapter :net_http # This is what ended up making it work
end