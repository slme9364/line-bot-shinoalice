require 'net/http'
require 'net/https'
require 'uri'
require 'json'

def post
  uri = URI.parse("https://api.line.me/v2/bot/message/push")
  https = Net::HTTP.new(uri.host, uri.port);
  https.use_ssl = true

  auth = "Bearer " + ENV['LINE_TOKEN']
  params = {'to': ENV['USER_ID'], 'messages': [{'type':'text', 'text':'ゲリラの時間です'}]}
  req = Net::HTTP::Post.new(uri.request_uri)
  req["Content-Type"] = "application/json"
  req["Authorization"] = auth
  req.body = params.to_json

  res = https.request(req)

end

def send_time
  time = Time.now
  if (time.hour == 7 || time.hour == 19 || time.hour == 22) && time.min == 30
    return true
  end
  if time.hour == 12 && time.min == 0
    return true
  end
  return false
end

loop{
  time = Time.now
  if send_time && time.sec == 0
    post
    sleep(1)
  end
}

