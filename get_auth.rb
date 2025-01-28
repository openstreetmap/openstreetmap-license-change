#!/usr/bin/ruby

# Get all the auth details you need
# You wouldn't actually do it this way, but hey.
# Normally you'd distribute the consumer stuff with your
# application, and each user gets the access_token stuff
# But hey, this is just a demo.

require './auth'
require 'rubygems'
require 'yaml'

y = YAML.load(File.open('auth.yaml'))

# Format of auth.yml:
# client_id: (from osm.org)
# token: (use Authorization Code Grant to get this)

puts "First, go to a new app registration page at #{y['oauth2']['site']}/oauth2/applications/new"
puts "Fill in the following:"
puts "* Name: enter 'DWG redaction bot' or something else, depending on how you plan to use this bot"
puts "* Redirect URIs: enter 'urn:ietf:wg:oauth:2.0:oob' without quotes"
puts "* Confidential application?: untick this checkbox"
puts "* Permissions: tick the following:"
puts "** Modify the map"
puts "** Redact map data"
puts "Register the app"
puts "Enter the Client ID you are assigned:"
y["oauth2"]["client_id"] = gets.strip
puts "Your application is now set up, but you need to register"
puts "this instance of it with your user account."

@client = Auth.client y

puts "Visit the following URL, log in if you need to, and authorize the app"
puts @client.auth_code.authorize_url(:scope => "write_api write_redactions")
puts "When you've authorized the app, enter the Authorization code you are assigned:"
code = gets.strip
puts "Converting code into token..."
@token=@client.auth_code.get_token(code)

y["oauth2"]["token"] = @token.token

File.open('auth.yaml', 'w') {|f| YAML.dump(y, f)}

puts "Done. Have a look at auth.yaml to see what's there."
