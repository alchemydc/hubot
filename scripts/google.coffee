# Description:
#   Returns the URL of the first google hit for a query
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot google <query> - Googles <query> & returns 1st result's URL
#
# Author:
#   searls / dc

module.exports = (robot) ->
  robot.hear /google (.*)/i, (msg) ->
    googleMe msg, msg.match[1], (url) ->
      msg.send url

googleMe = (msg, query, cb) ->
  msg.http('http://www.google.com/search')
    .query(q: query)
    .get() (err, res, body) ->
      cb body.match(/class="r"><a href="\/url\?q=([^"]*)(&amp;sa.*)">/)?[1] || "Sorry, Google had zero results for '#{query}'"