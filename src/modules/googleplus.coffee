async = require('async')
request = require("request")
OAuth2 = require('oauth').OAuth2

googlePlusClient = (keys) ->
  self = @
  @clientId = keys.clientId
  @clientSecret = keys.clientSecret
  oa = new OAuth2
  @requestFunctions =
    contacts: (tokens, cb) ->
      return cb null, {error: new Error 'Google Plus API does not currently support contacts'}
    details: (tokens, cb) ->
      oa._request 'get', 'https://www.googleapis.com/plus/v1/people/me', {}, "", tokens.access_token, (err, data, res) ->
        return cb null, {error: new Error(err.data ? err)} if err
        cb(null, JSON.parse(data))
  return

module.exports = googlePlusClient