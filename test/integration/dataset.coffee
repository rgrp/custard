$ = jQuery = require 'jquery'
Browser = require 'zombie'
should = require 'should'

url = 'http://localhost:3001' # DRY DRY DRY
login_url = "#{url}/login"

describe 'Dataset', ->
  randomname = "New favourite number is #{Math.random()}"
  browser = new Browser()
  browser.waitDuration = "10s"

  before (done) ->
    browser.visit login_url, done

  before (done) ->
    browser.fill '#username', 'ehg'
    browser.fill '#password', 'testing'
    browser.pressButton '#login', ->
      browser.visit '/tools', done

  context 'when I click on the newdataset dataset', ->
    before (done) ->
      link = browser.query('.tool a[href="/tool/newdataset"]')
      browser.fire 'click', link, ->
        browser.wait done

    it 'takes me to the highrise dataset page', ->
      result = browser.location.href
      result.should.equal "#{url}/tool/newdataset"

    it 'has not shown the input box', ->
      @input = browser.query '#header h2 input'
      $(@input).is(':visible').should.be.false

    context 'when I click the title', ->
      before (done) ->
        @input = browser.query '#title input'
        @a = browser.query '#title .editable'
        browser.fire 'click', browser.query('#title .editable'), done

      it 'an input box appears', ->
        should.exist @input
        $(@input).is(':visible').should.be.true

      context 'when I fill in the input box and press enter', ->
        before (done) ->
          browser.fill '#title input', randomname, ->
            browser.evaluate """
              var e = jQuery.Event("keypress")
              e.which = 13
              e.keyCode = 13
              $('#title input').trigger(e)
            """
            browser.wait done

        it 'hides the input box and shows the title', ->
          @input = browser.query '#title input'
          @a = browser.query '#title .editable'
          $(@a).is(':visible').should.be.true
          $(@input).is(':visible').should.be.false

        it 'has updated the title', (done) ->
          @a = browser.query '#title .editable'
          $(@a).text().should.equal randomname
          done()

      context 'when I go back home', ->
        before (done) ->
          browser.visit "#{url}/", ->
            browser.wait done

        it 'should display the home page', ->
          browser.location.href.should.match /\/$/

        it 'should show the new dataset new name', ->
          browser.text().should.include randomname


