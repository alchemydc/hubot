# Description:
# Check btc exchange rates
#
# Dependencies:
# None
#
# Configuration:
# None
#
# Commands:
# hubot bitcoin - get current btc exchange rates

#  JSON format: { USD: { '7d': '857.44', '30d': '777.40', '24h': '896.58' },

module.exports = (robot) ->

  robot.hear /bitcoin|btc/i, (msg)->
    getBTC msg, "http://api.bitcoincharts.com/v1/weighted_prices.json"

  getBTC = (msg, url) ->
    msg.http(url)
      .get() (err, res, body) ->
        if err
          msg.send "Error: #{err}"
        else
          result = JSON.parse(body)
          # JSON with numbers for keys|property names is a PITA!!!
          rString = "24h: $" + result.USD["24h"] + " 7d: $" + result.USD["7d"] + " 30d: $" + result.USD["30d"]
          msg.send rString