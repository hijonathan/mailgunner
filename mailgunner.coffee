fs = require 'fs'
request = require 'request'
home = process.env['HOME']

require.extensions[".json"] = (m) ->
    m.exports = JSON.parse fs.readFileSync m.filename

mailgun = require 'mailgun'
config = require "#{home}/.mailgunner/config.json"


# Run this file using the following syntax
# node mailgunner path_to_test_file.html [recipient@gmail.com]

unless config.apikey
    throw "Set your api key in ./config.json"

args = process.argv
switch args.length
    when 1, 2
        return console.log('Incorrect number of arguments')
    when 3
        path = args[2]
        recipients = config.recipients
    when 4
        recipients = args[3]

mg = new mailgun.Mailgun config.apikey
sendIt = (emailBody, subject) ->

    rawBody = "From: #{config.sender}" +
          "\nTo: #{recipients.toString()}" +
          '\nContent-Type: text/html; charset=utf-8' +
          "\nSubject: #{subject}" +
          "\n\n#{emailBody}"

    mg.sendRaw(
        config.sender,
        recipients,
        rawBody,
        (err) ->
            if err?
                console.log(err)
            else
                "Successfully sent your email"
    )

# Send urls
if path.substring(0, 4).toLowerCase() is 'http'
    request path, (err, response, body) ->
        subject = "#{path} #{config.subject}"

        # Add a <base> tag to get all the assets
        closingHead = "</head>"
        baseTag = "<base href='#{path}'>"
        # I'm not proud of this solution
        rebasedBody = body.replace closingHead, "#{baseTag}#{closingHead}"

        sendIt rebasedBody, subject

# Send local files
else
    if path.charAt(0) isnt '/'
        path = process.cwd() + '/' + path

    filename = path.split('/').slice(-1)
    subject = "#{filename} #{config.subject}"
    fs.readFile path, 'utf8', (err, contents) ->
        sendIt contents, subject
