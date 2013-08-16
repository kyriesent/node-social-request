async = require("async")
request = require("request")
OAuth = require("oauth").OAuth

facebookClient = (keys) ->
  self = @
  @appId = keys.appId
  @appSecret = keys.appSecret
  @requestFunctions =
    contacts: (tokens, cb) ->
      request "https://graph.facebook.com/me/friends?access_token=#{tokens.access_token}", (err, response, body) ->
        return cb null, { error: err } if err 
        body = JSON.parse(response.body)
        return cb null, { error: body.error } if body.error? 
        async.map body.data, (entry, cb) ->
          contact = 
            id: entry.id
            name: entry.name
            picture: "http://graph.facebook.com/#{entry.id}/picture"
            entry: entry
          cb(null, contact)
        , cb
    details: (tokens, cb) ->
      request "https://graph.facebook.com/me?access_token=#{tokens.access_token}", (err, response, body) ->
        return cb null, { error: err } if err
        body = JSON.parse(body)
        return cb null, { error: body.error } if body.error? 
        cb(null, body)
  return

module.exports = facebookClient