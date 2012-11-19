SocialReq = require '../index.js'
testConfig = require '../testconfig.coffee'
expect = require 'expect.js'

describe 'Client', () ->
  socialReq = {}
  beforeEach (done) ->
    socialReq = new SocialReq()
    socialReq
      .use('google', {clientId: testConfig.google.clientId, clientSecret: testConfig.google.clientSecret})
      .use('googleplus', {clientId: testConfig.google.clientId, clientSecret: testConfig.google.clientSecret})
      .use('facebook', {appId: testConfig.facebook.appId, appSecret: testConfig.facebook.appSecret})
      .use('twitter', {consumerKey: testConfig.twitter.consumerKey, consumerSecret: testConfig.twitter.consumerSecret})
      .use('linkedin', {apiKey: testConfig.linkedin.apiKey, secretKey: testConfig.linkedin.secretKey})
    done()

  describe '#get', () ->
    beforeEach (done) ->
      socialReq.getTokens (id, cb) ->
        cb
          facebook:
            access_token: testConfig.facebook.access_token
          google: 
            access_token: testConfig.google.access_token
            access_token_secret: testConfig.google.access_token_secret
          googleplus: 
            access_token: testConfig.google.access_token
            access_token_secret: testConfig.google.access_token_secret
          twitter:
            access_token: testConfig.twitter.access_token
            access_token_secret: testConfig.twitter.access_token_secret
          linkedin:
            access_token: testConfig.linkedin.access_token
            access_token_secret: testConfig.linkedin.access_token_secret
      done()

    it 'should get content successfully as specified in options', (done) ->
      @timeout 5000
      socialReq.get 'abcd', { details: ['*', '-facebook'], contacts: ['google'] },  (err, results) ->
        throw err if err
        expect(results.details.google).to.be.ok()
        expect(results.details.facebook).not.to.be.ok()
        expect(results.contacts.google).to.be.ok()
        expect(results.contacts.facebook).not.to.be.ok()
        done()
    describe 'for google', () ->
      it 'should get content successfully', (done) ->
        @timeout 5000
        socialReq.get 'abcd', { details: ['google', 'googleplus'], contacts: ['google', 'googleplus'] },  (err, results) ->
          throw err if err
          expect(results.details.google.id).to.be.ok()
          expect(results.details.google.email).to.be.ok()
          expect(results.details.googleplus.organizations).to.be.ok()
          expect(results.details.googleplus.organizations.length).to.be.greaterThan 0
          expect(results.contacts.google).to.be.ok()
          expect(results.contacts.google.length).to.be.greaterThan 0
          expect(results.contacts.google[0].entry.id).to.be.ok()
          expect(results.contacts.google[0].email).to.be.ok()
          expect(results.contacts.googleplus.error).to.be.ok()
          done()
    describe 'for facebook', () ->
      it 'should get content successfully', (done) ->
        @timeout 5000
        socialReq.get 'abcd', { details: ['facebook'], contacts: ['facebook'] },  (err, results) ->
          throw err if err
          expect(results.details.facebook).to.be.ok()
          expect(results.details.facebook.id).to.be.ok()
          expect(results.details.facebook.name).to.be.ok()
          expect(results.details.facebook.username).to.be.ok()
          expect(results.contacts.facebook).to.be.ok()
          expect(results.contacts.facebook[0].name).to.be.ok()
          expect(results.contacts.facebook[0].id).to.be.ok()
          done()
    describe 'for twitter', () ->
      it 'should get content successfully', (done) ->
        @timeout 7000
        socialReq.get 'abcd', { details: ['twitter'], contacts: ['twitter'] },  (err, results) ->
          throw err if err
          expect(results.details.twitter).to.be.ok()
          expect(results.details.twitter.id).to.be.ok()
          expect(results.details.twitter.name).to.be.ok()
          expect(results.details.twitter.username).to.be.ok()
          expect(results.contacts.twitter).to.be.ok()
          expect(results.contacts.twitter[0].name).to.be.ok()
          expect(results.contacts.twitter[0].id).to.be.ok()
          done()
    describe 'for linkedin', () ->
      it 'should get content successfully', (done) ->
        socialReq.get 'abcd', { details: ['linkedin'], contacts: ['linkedin'] },  (err, results) ->
          throw err if err
          expect(results.details.linkedin).to.be.ok()
          expect(results.details.linkedin.id).to.be.ok()
          expect(results.details.linkedin.name).to.be.ok()
          expect(results.contacts.linkedin).to.be.ok()
          expect(results.contacts.linkedin[0].name).to.be.ok()
          expect(results.contacts.linkedin[0].id).to.be.ok()
          done()
    describe 'on failure', () ->
      beforeEach () ->
        socialReq.getTokens (id, cb) ->
          cb
            facebook:
              access_token: 'nooooooooooooooooooooooooooooooo'
            google: 
              access_token: 'nooooooooooooooooooooooooooooooo'
              access_token_secret: 'nooooooooooooooooooooooooooooooo'
            twitter:
              access_token: 'nooooooooooooooooooooooooooooooo'
              access_token_secret: 'nooooooooooooooooooooooooooooooo'
            linkedin:
              access_token: 'nooooooooooooooooooooooooooooooo'
              access_token_secret: 'nooooooooooooooooooooooooooooooo'
      it 'should return keys with errors and not throw errors', (done) ->
        socialReq.get 'abcd', { details: ['*'] },  (err, results) ->
          throw err if err
          expect(results.details.google.error).to.be.ok()
          expect(results.details.facebook.error).to.be.ok()
          expect(results.details.twitter.error).to.be.ok()
          expect(results.details.linkedin.error).to.be.ok()
          done()