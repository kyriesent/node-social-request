async = require 'async'

SocialReq = () ->
	getServiceRequestFunction = (service, scope, tokens) ->
		return (cb) ->
			self.serviceModules[service].requestFunctions[scope](tokens, cb)

	self = @
	@services = {}
	@serviceModules = {}
	@use = (service, keys) ->
		self.services[service] = keys
		self.serviceModules[service] = new (require './modules/' + service)(keys)
		return self
	@get = (id, scopes, done) ->
		self._getTokens id, (tokens) ->
			getFunctions = {}
			pushGetFunction = (scope, services) ->
				getFunctions[scope] = (cb) ->
					serviceList = []
					parseService = (service) ->
						if service is '*'
							serviceList = []
							serviceList.push service for service, keys of self.services
						else if service.indexOf('-') is 0
							serviceName = service[1..service.length]
							serviceList.splice serviceList.indexOf(serviceName), 1
						else
							serviceList.push service if serviceList.indexOf(service) is -1
					parseService service for service in services
					serviceRequestFunctions = {}
					pushServiceRequestFunction = (service) ->
						serviceRequestFunctions[service] = getServiceRequestFunction(service, scope, tokens[service])
					pushServiceRequestFunction service for service in serviceList
					async.parallel serviceRequestFunctions, (err, results) ->
						cb err, results
			pushGetFunction scope, services for scope, services of scopes
			###
			getFunctions =
				contacts: (cb) ->
					cb null, 'asdf'
				details: (cb) ->
					cb null, 'jkl;'
			###
			async.parallel getFunctions, (err, results) ->
				return done err if err
				done err, results
	


	@_getTokens = {}
	@getTokens = (fn) ->
		self._getTokens = fn

	return

module.exports = SocialReq