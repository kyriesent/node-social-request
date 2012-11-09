async = require("async")
request = require("request")
OAuth = require("oauth").OAuth

facebookClient = (keys) ->
  self = @
  @appId = keys.appId
  @appSecret = keys.appSecret
  @requestFunctions =
    contacts: (tokens, cb) ->
      request "https://graph.facebook.com/me/friends?access_token=#{tokens.access_token}", (err, data, res) ->
        return cb null, {error: new Error(err.data ? err)} if err
        data = JSON.parse(data.body)
        async.map data.data, (entry, cb) ->
          contact = 
            id: entry.id
            name: entry.name
            picture: "http://graph.facebook.com/#{entry.id}/picture"
            entry: entry
          cb(null, contact)
        , cb
    details: (tokens, cb) ->
      request "https://graph.facebook.com/me?access_token=#{tokens.access_token}", (err, data, res) ->
        return cb null, {error: new Error(err.data ? err)} if err
        cb(null, JSON.parse(data.body))
  return

module.exports = facebookClient