# Description:
# Check snow at a few named epic pass resorts
#
# Dependencies:
# None
#
# Configuration:
# None
#
# Commands:
# dc

module.exports = (robot) ->

  robot.hear /eldora/i, (msg)->
    getSnow msg, "http://feeds.snocountry.com/conditions.php?apiKey=SnoCountry.example&ids=303011"

  robot.hear /vail/i, (msg)->
    getSnow msg, "http://feeds.snocountry.com/conditions.php?apiKey=SnoCountry.example&ids=303023"

  robot.hear /breck/i, (msg)->
    getSnow msg, "http://feeds.snocountry.com/conditions.php?apiKey=SnoCountry.example&ids=303007"

  robot.hear /keystone/i, (msg)->
    getSnow msg, "http://feeds.snocountry.com/conditions.php?apiKey=SnoCountry.example&ids=303014"

  robot.hear /the beav/i, (msg)->
    getSnow msg, "http://feeds.snocountry.com/conditions.php?apiKey=SnoCountry.example&ids=303005"

  robot.hear /the basin/i, (msg)->
    getSnow msg, "http://feeds.snocountry.com/conditions.php?apiKey=SnoCountry.example&ids=303001"

  robot.hear /loveland/i, (msg)->
    getSnow msg, "http://feeds.snocountry.com/conditions.php?apiKey=SnoCountry.example&ids=303015"

  robot.hear /kirkwood/i, (msg)->
    getSnow msg, "http://feeds.snocountry.com/conditions.php?apiKey=SnoCountry.example&ids=209004"

  robot.hear /heavenly/i, (msg)->
    getSnow msg, "http://feeds.snocountry.com/conditions.php?apiKey=SnoCountry.example&ids=916004"

  robot.hear /canyons/i, (msg)->
    getSnow msg, "http://feeds.snocountry.com/conditions.php?apiKey=SnoCountry.example&ids=801007"

  getSnow = (msg, url) ->
    msg.http(url)
      .get() (err, res, body) ->
        if err
          msg.send "Error: #{err}"
        else
          result = JSON.parse(body)
          console.dir(result)
          if result.items[0].newSnowMin == ""
            newSnow24 = "fuckall"
          else
             newSnow24 = result.items[0].newSnowMin + '"'

          if result.items[0].snowLast48Hours == ""
            newSnow48 = "fuckall"
          else
            newSnow48 = result.items[0].snowLast48Hours + '"'

          if result.items[0].predictedSnowFall_24Hours == ""
            predictedSnow24 = "fuckall"
          else
            predictedSnow24 = result.items[0].predictedSnowFall_24Hours + '"'

          rString = result.items[0].resortName + " is rocking " + result.items[0].primarySurfaceCondition + " and got " + newSnow24 \
          + " in the past 24 hours, " \
          + newSnow48 + " in the last 48, and is predicted to get " + predictedSnow24 \
          + " in the next 24 hrs. WX is " + result.items[0].weatherToday_Condition + " with temps from "\
          + result.items[0].weatherToday_Temperature_Low + " to " + result.items[0].weatherToday_Temperature_High \
          + " and winds of " + result.items[0].weatherToday_WindSpeed \
          + ". Base is " + result.items[0].avgBaseDepthMin + " inches and " + result.items[0].openDownHillPercent + "% of the mtn is open."
          #msg.send result.items[0].resortName
          msg.send rString

