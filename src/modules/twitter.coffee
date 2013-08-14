async = require('async')
request = require('request')
OAuth = require('oauth').OAuth

twitterClient = (keys) ->
  self = @
  @consumerKey = keys.consumerKey
  @consumerSecret = keys.consumerSecret
  oauth = new OAuth null, null, @consumerKey, @consumerSecret, '1.0', null, 'HMAC-SHA1'
  @requestFunctions =
    contacts: (tokens, cb) ->
      oauth.get 'https://api.twitter.com/1.1/friends/ids.json', tokens.access_token, tokens.access_token_secret, (err, data) ->
        return cb null, {error: new Error(err.data ? err)} if err
        data = JSON.parse(data)
        ids = data.ids[0...100].join ','
        oauth.get "https://api.twitter.com/1.1/users/lookup.json?user_id=#{ids}", tokens.access_token, tokens.access_token_secret, (err, data) ->
          return cb new Error(err.data ? err) if err
          data = JSON.parse(data)
          async.map data, (entry, cb) ->
            contact = 
              id: entry.id
              name: entry.name
              picture : entry.profile_image_url
              username: entry.screen_name
              entry: entry
            cb(null, contact)
          , cb
    details: (tokens, cb) ->
      oauth.get 'https://api.twitter.com/1.1/account/verify_credentials.json', tokens.access_token, tokens.access_token_secret, (err, data) ->
        return cb null, {error: new Error(err.data ? err)} if err
        data = JSON.parse(data)
        data.username = data.screen_name
        cb(null, data)
  return

module.exports = twitterClient