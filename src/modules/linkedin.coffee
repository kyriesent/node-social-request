async = require('async')
request = require('request')
OAuth = require('oauth').OAuth

linkedinClient = (keys) ->
  self = @
  @apiKey = keys.apiKey
  @secretKey = keys.secretKey
  oauth = new OAuth null, null, @apiKey, @secretKey, '1.0', null, 'HMAC-SHA1'
  @requestFunctions =
    contacts: (tokens, cb) ->
      oauth.get 'http://api.linkedin.com/v1/people/~/connections?format=json', tokens.access_token, tokens.access_token_secret, (err, data) ->
        return cb new Error(err.data ? err) if err
        data = JSON.parse(data)
        async.map data.values, (entry, cb) ->
          contact = 
            id: entry.id
            name: "#{entry.firstName} #{entry.lastName}"
            picture: entry.pictureUrl
            entry: entry
          cb(null, contact)
        , cb
    details: (tokens, cb) ->
      oauth.get 'http://api.linkedin.com/v1/people/~:(id,first-name,last-name,industry,picture-url)?format=json', tokens.access_token, tokens.access_token_secret, (err, data) ->
        return cb new Error(err.data ? err) if err
        data = JSON.parse(data)
        data.name = "#{data.firstName} #{data.lastName}"
        data.picture = data.pictureUrl
        cb(null, data)
  return

module.exports = linkedinClient