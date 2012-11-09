async = require('async')
OAuth = require('oauth').OAuth

googleClient = (keys) ->
	self = @
	@consumerKey = keys.consumerKey
	@consumerSecret = keys.consumerSecret
	oauth = new OAuth null, null, @consumerKey, @consumerSecret, '2.0', null, 'HMAC-SHA1'
	oauth._headers['GData-Version'] = '3.0'
	@requestFunctions =
		contacts: (tokens, cb) ->
			oauth.get 'https://www.google.com/m8/feeds/contacts/default/full?alt=json&max-results=10000', tokens.access_token, tokens.access_token_secret, (err, data, res) ->
				return cb null, {error: new Error(err.data ? err)} if err
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
			oauth.get 'https://www.googleapis.com/oauth2/v1/userinfo?alt=json', tokens.access_token, tokens.access_token_secret, (err, data, res) ->
				return cb null, {error: new Error(err.data ? err)} if err
				cb(null, JSON.parse(data))
	return

module.exports = googleClient