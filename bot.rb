require 'http'
require 'json'
require 'eventmachine'
require 'faye/websocket'

rc = HTTP.post("https://slack.com/api/rtm.start", params: {
    token: ENV['SLACK_API_TOKEN'],
    channel: '#general',
    text: "That is the last time we're taking directions from a SQUIRREL!!",
    as_user: true
})

rc = JSON.parse(rc.body)
# puts JSON.pretty_generate(JSON.parse(rc.body))
# puts rc['url']
url = rc['url']

EM.run do
  ws = Faye::WebSocket::Client.new(url)
  ws.on :open do
    p [:open]
  end
  ws.on :message do |event|
    p [:message, JSON.parse(event.data)]
    data = JSON.parse(event.data)
    if data['text'] == 'yzma'
      ws.send({ type:'message',
                text: "Pull The Lever <@#{data['user']}>!",
                channel: data['channel']}.to_json)
    end
    if data['text'] == 'cusco'
      ws.send({ type: 'message',
                text: "I'll turn him into a flea. A harmless little flea. And then, I'll put that flea in a box, and then I'll put that box inside another box, and then I'll mail that box to myself. And when it arrives-AAHAHAHA! I'll SMASH IT WITH A HAMMER!",
                channel: data['channel']}.to_json)
    end
  end
  ws.on :close do
    p [:close, event.code, event.reason]
    ws = nil
    EM.stop
  end

end