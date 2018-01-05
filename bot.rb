require 'http'
require 'json'

rc = HTTP.post("https://slack.com/api/chat.postMessage", params: {
    token: ENV['SLACK_API_TOKEN'],
    channel: '#general',
    text: "That is the last time we're taking directions from a SQUIRREL!!",
    as_user: true
})
puts JSON.pretty_generate(JSON.parse(rc.body))