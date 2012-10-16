SocialReq = require '../index.js'
expect = require 'expect.js'

describe 'Client', () ->
	socialReq = {}
	beforeEach (done) ->
		socialReq = new SocialReq()
		socialReq.use('google', {consumerKey: 'david.dev.truapp.me', consumerSecret: '3Od4rkt7vnT0oj_5Ix3_vIKs'}).use('facebook', {appId: '507989612559123', appSecret: '527af33cb71436a9856f7cde32ac0c77'})
		socialReq.getTokens (id, cb) ->
			cb
				facebook:
					access_token: 'AAAHOA4xnZBxMBAK4ZCI2PjnhqlMLhMd0aZA9lHpgPMwFN7rw6lOV5HBditZB5Hch2rFIdsNrQOR08qcR2ZAeZA5uAVzK2NNgQZD'
				google: 
					access_token: '1/He3z9WtNhZeCPLO8kAW9ayK_tU6pnwxPX8frEBaDbM4'
					access_token_secret: 'XAElLJCD0pOWlWdFDEkixEQ9'

		done()

	describe '#get', () ->
		it 'should get user details from services', (done) ->
			socialReq.get 'abcd', { details: ['*', '-facebook'], contacts: ['google'] },	(err, results) ->
				throw err if err
				console.log results
				expect(results.details.google).to.be.ok()
				expect(results.details.facebook).not.to.be.ok()
				expect(results.contacts.google).to.be.ok()
				expect(results.contacts.facebook).not.to.be.ok()
				done()