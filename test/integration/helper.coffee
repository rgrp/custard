# Shared before/after functions for all integration tests

{wd40, browser} = require('../wd40')

url = 'http://localhost:3001'
login_url = "#{url}/login"

before (done) ->
  wd40.init ->
    browser.get login_url, done

after (done) ->
  browser.quit ->
    done()

exports.wd40 = wd40
exports.browser = browser
exports.login_url = login_url
exports.url = url
