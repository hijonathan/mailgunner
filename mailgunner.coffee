fs = require 'fs'

require.extensions[".json"] = (m) ->
    m.exports = JSON.parse fs.readFileSync m.filename

mailgun = require 'mailgun'
config = require './config.json'


# Run this file using the following syntax
# node mailgunner 'apikey' path_to_test_file.html

args = process.argv
switch args.length
    when 1, 2
        return console.log('Incorrect number of arguments')
    when 3
        apikey = config.apikey
        path = args[2]
    when 4
        apikey = args[2]
        path = args[3]

mg = new mailgun.Mailgun apikey
if path.charAt(0) isnt '/'
    path = process.cwd() + '/' + path

filename = path.split('/').slice(-1)
subject = "#{config.subject} #{filename}"
emailBody = ''
fs.readFile path, 'utf8', (err, contents) ->
    emailBody = contents

    rawBody = "From: #{config.sender}" +
          "\nTo: #{config.recipients.toString()}" +
          '\nContent-Type: text/html; charset=utf-8' +
          "\nSubject: #{subject}" +
          "\n\n#{emailBody}"

    mg.sendRaw(
        config.sender,
        config.recipients,
        rawBody,
        (err) ->
            if err?
                console.log(err)
            else
                "Successfully sent your email"
    )
