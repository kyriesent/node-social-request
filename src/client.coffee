async = require 'async'

SocialReq = () ->
  self = @
  @services = {}
  @serviceModules = {}
  @use = (service, keys) ->
    self.services[service] = keys
    self.serviceModules[service] = new (require './modules/' + service)(keys)
    return self
  @_getTokens = {}
  @getTokens = (fn) ->
    self._getTokens = fn
  return

SocialReq.prototype.get = (id, scopes, done) ->
  self = @
  getServiceRequestFunction = (service, scope, tokens) ->
    return (cb) ->
      if self.serviceModules[service]?.requestFunctions[scope]? then self.serviceModules[service].requestFunctions[scope](tokens, cb) else cb(null, null)
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
    async.parallel getFunctions, (err, results) ->
      return done err if err
      done err, results

module.exports = SocialReq