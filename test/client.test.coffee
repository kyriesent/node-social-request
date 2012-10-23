SocialReq = require '../index.js'
expect = require 'expect.js'

describe 'Client', () ->
  socialReq = {}
  beforeEach (done) ->
    socialReq = new SocialReq()
    socialReq
      .use('google', {consumerKey: 'david.dev.truapp.me', consumerSecret: '3Od4rkt7vnT0oj_5Ix3_vIKs'})
      .use('facebook', {appId: '507989612559123', appSecret: '527af33cb71436a9856f7cde32ac0c77'})
      .use('twitter', {consumerKey: 'zrlEiRk1ieXffSFLE66FA', consumerSecret: '9XPjybMWIR2GiSSuqZu90HbOArYaYgeqZ7ZoCjaJic'})
      .use('linkedin', {apiKey: 'jrd5vifr3gst', secretKey: 'z745BfMl1jIA2Fn7'})
    done()

  describe '#get', () ->
    beforeEach (done) ->
      socialReq.getTokens (id, cb) ->
        cb
          facebook:
            access_token: 'AAAHOA4xnZBxMBAK4ZCI2PjnhqlMLhMd0aZA9lHpgPMwFN7rw6lOV5HBditZB5Hch2rFIdsNrQOR08qcR2ZAeZA5uAVzK2NNgQZD'
          google: 
            access_token: '1/5otDvTdamXCWJpf7L1-pzhQWKJ7Wir2idvLkPi3LLII'
            access_token_secret: 'V0b42SIiir9GKCwryxTBhi5d'
          twitter:
            access_token: '18435384-koEj8OG4nzOQTG3EeoCkVCNMnH7jv4in0v3KXzps5'
            access_token_secret: 'eKSKtQlujYadeob4TJcxqmdOTdcEB7o7lLTEJroH7cc'
          linkedin:
            access_token: '82712e42-aa22-4828-9ef6-1a10ad8ca169'
            access_token_secret: '018aff5d-fcf2-4145-af70-ad955ab83565'
      done()

    it 'should get content successfully as specified in options', (done) ->
      socialReq.get 'abcd', { details: ['*', '-facebook'], contacts: ['google'] },  (err, results) ->
        throw err if err
        expect(results.details.google).to.be.ok()
        expect(results.details.facebook).not.to.be.ok()
        expect(results.contacts.google).to.be.ok()
        expect(results.contacts.facebook).not.to.be.ok()
        done()
    describe 'for google', () ->
      it 'should get content successfully', (done) ->
        socialReq.get 'abcd', { details: ['google'], contacts: ['google'] },  (err, results) ->
          throw err if err
          expect(results.details.google.id).to.be.ok()
          expect(results.details.google.email).to.be.ok()
          expect(results.contacts.google).to.be.ok()
          expect(results.contacts.google.length).to.be.greaterThan(0)
          expect(results.contacts.google[0].entry.id).to.be.ok()
          expect(results.contacts.google[0].email).to.be.ok()
          done()
    describe 'for facebook', () ->
      it 'should get content successfully', (done) ->
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
        @timeout 5000
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
          expect(results.details.linkedin.picture).to.be.ok()
          expect(results.contacts.linkedin).to.be.ok()
          expect(results.contacts.linkedin[1].name).to.be.ok()
          expect(results.contacts.linkedin[1].id).to.be.ok()
          expect(results.contacts.linkedin[1].picture).to.be.ok()
          done()