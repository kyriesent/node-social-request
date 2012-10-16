Gdata = require('gdata').GDClient

google = (keys) ->
	self = @
	@consumerKey = keys.consumerKey
	@consumerSecret = keys.consumerSecret
	@requestFunctions =
		contacts: (tokens, cb) ->
			google = new Gdata(self.consumerKey, self.consumerSecret)
			google.setAccessToken(tokens.access_token, tokens.access_token_secret)
			google.get 'https://www.google.com/m8/feeds/contacts/default/full/', (err, feed) ->
				return cb err if err
				contacts = []
				for entry in feed.getEntries()
					contact = 
						entry: entry
						fullname: entry.entry['gd$name']['gd$fullName']?
						email: entry.entry['gd$name']?['gd$email']?
					contacts.push contact
					console.log contact.fullname	
					console.log contact.email
				cb(null, 'google contacts')
		details: (tokens, cb) ->
			cb(null, 'google details')
	return

module.exports = google