async = require('async')
OAuth2 = require('oauth').OAuth2
request = require 'request'

googleClient = (keys) ->
	self = @
	@clientId = keys.clientId
	@clientSecret = keys.clientSecret
	oa = new OAuth2
	@requestFunctions =
		contacts: (tokens, cb) ->
			oa._request 'get', 'https://www.google.com/m8/feeds/contacts/default/full?alt=json&max-results=10000', {'GData-Version':'3.0'}, '', tokens.access_token, (err, data, res) ->
				if err?
					err.code = err.statusCode
					err.message = err.data
					return cb null, {error: err}
				getPrimaryEmail = (contact, cb) ->
					emails = contact.entry['gd$email']
					return cb(null, contact) if not emails?
					async.detect emails, (email, cb) ->
						cb(email.primary)
					, (primaryEmail) ->
						contact.email = if primaryEmail then primaryEmail.address else null
						cb(null, contact)
				data = JSON.parse(data)
				async.map data.feed.entry, (entry, cb) ->
					contact = 
						entry: entry
						fullname: if entry['gd$name']? and entry['gd$name']['gd$fullName']? then entry['gd$name']['gd$fullName']['$t'] else null
					getPrimaryEmail(contact, cb);
				, cb
		details: (tokens, cb) ->
			oa._request 'get', 'https://www.googleapis.com/oauth2/v1/userinfo?alt=json', {'GData-Version':'3.0'}, '', tokens.access_token, (err, data, res) ->
				return cb null, {error: JSON.parse(err.data).error} if err?
				cb(null, JSON.parse(data))
		tokens: (tokens, cb) ->
			tokenForm = 
				refresh_token: tokens.refresh_token
				client_id: self.clientId
				client_secret: self.clientSecret
				grant_type: 'refresh_token'
			request.post 'https://accounts.google.com/o/oauth2/token', {form: tokenForm}, (err, response, body) ->
				return cb null, {error: err.data or err} if err?
				console.log body
				body = JSON.parse body
				if body.error?
					error = 
						message: body.error
						code: response.statusCode
					return cb null, {error: error}
				cb(null, body)
	return

module.exports = googleClient