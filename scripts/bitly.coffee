# Description:
#   Shorten URLs with bit.ly & expand detected bit.ly URLs
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_BITLY_USERNAME
#   HUBOT_BITLY_API_KEY
#
# Commands:
#   hubot (bitly|shorten) (me) <url> - Shorten the URL using bit.ly
#   http://bit.ly/[hash] - looks up the real url
#
# Author:
#   sleekslush
#   drdamour
#   dc

module.exports = (robot) ->
  robot.respond /(bitly|shorten)\s?(me)?\s?(.+)$/i, (msg) ->
    msg
      .http("http://api.bitly.com/v3/shorten")
      .query
        login: process.env.HUBOT_BITLY_USERNAME
        apiKey: process.env.HUBOT_BITLY_API_KEY
        longUrl: msg.match[3]
        format: "json"
      .get() (err, res, body) ->
        response = JSON.parse body
        msg.send if response.status_code is 200 then response.data.url else response.status_txt


  robot.hear /^(http(?:s)?\:\/\/[a-zA-Z0-9\-]+(?:\.[a-zA-Z0-9\-]+)*\.[a-zA-Z]{2,6}(?:\/?|(?:\/[\w\-]+)*)(?:\/?|\/\w+\.[a-zA-Z]{2,4}(?:\?[\w]+\=[\w\-]+)?)?(?:\&[\w]+\=[\w\-]+)*)$/, (msg) ->
    if msg.match[0].length <= 35
      console.log("short url caught, not shortening")
      return
    else
      console.log("shortening url: " + msg.match[0])
    msg
      .http("http://api.bitly.com/v3/shorten")
      .query
        login: process.env.HUBOT_BITLY_USERNAME
        apiKey: process.env.HUBOT_BITLY_API_KEY
        longUrl: msg.match[0]
        format: "json"
      .get() (err, res, body) ->
        response = JSON.parse body
        msg.send if response.status_code is 200 then response.data.url else "Error!" + response.status_txt

  #TODO: can we make this list more expansive/dynamically generated?
  robot.hear /(https?:\/\/(bit\.ly|yhoo\.it|j\.mp|pep\.si|amzn\.to)\/[0-9a-z\-]+)/ig, (msg) ->
    msg
      .http("http://api.bitly.com/v3/expand")
      .query
        login: process.env.HUBOT_BITLY_USERNAME
        apiKey: process.env.HUBOT_BITLY_API_KEY
        shortUrl: msg.match
      .get() (err, res, body) ->
        parsedBody = JSON.parse body
        if parsedBody.status_code is not 200
          msg.send "Lookup failed #{response.status_txt}"
          return

    msg.send "#{m.short_url} is #{m.long_url}" for m in parsedBody.data.expand

