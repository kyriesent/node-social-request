facebook = () ->
	@requestFunctions =
		contacts: (tokens, cb) ->
			cb(null, 'facebook contacts')
		details: (tokens, cb) ->
			cb(null, 'facebook details')
	return
	
module.exports = facebook