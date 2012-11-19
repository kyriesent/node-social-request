async = require('async')
OAuth2 = require('oauth').OAuth2

googleClient = (keys) ->
	self = @
	@clientId = keys.clientId
	@clientSecret = keys.clientSecret
	oa = new OAuth2
	@requestFunctions =
		contacts: (tokens, cb) ->
			oa._request 'get', 'https://www.google.com/m8/feeds/contacts/default/full?alt=json&max-results=10000', {'GData-Version':'3.0'}, '', tokens.access_token, (err, data, res) ->
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
			oa._request 'get', 'https://www.googleapis.com/oauth2/v1/userinfo?alt=json', {'GData-Version':'3.0'}, '', tokens.access_token, (err, data, res) ->
				return cb null, {error: new Error(err.data ? err)} if err
				cb(null, JSON.parse(data))
	return

module.exports = googleClient