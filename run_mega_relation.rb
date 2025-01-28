#!/usr/bin/env ruby
# Redacts our favourite mega relation

require './auth'
require 'yaml'
require 'logger'

# There is one massive relation where every version is by a decliner and
# it's already deleted. However, the expected runtime of the bot is something
# north of a week.

# So lets special-case it somewhat.

ENTITY_ID = 78907
HIGHEST_VERSION = 720
@redaction_id_hidden = 1

auth = YAML.load(File.open('auth.yaml'))

@access_token = Auth.access_token auth

LOG_DIR = 'logs'
log_name = "#{Time.now.strftime('%Y%m%dT%H%M%S')}-#{$$}.log"


 puts "Special mega-relation redaction."

# Don't include the highest version
(205...HIGHEST_VERSION).each do |version|
  puts "Redaction for relation #{ENTITY_ID} v#{version} hidden"
  response = @access_token.post("/api/0.6/relation/#{ENTITY_ID}/#{version}/redact?redaction=#{@redaction_id_hidden}").response
  unless response.success?
    puts "Failed to redact element - response: #{response.status} \n #{response.body}"
    raise "Failed to redact element"
  end
end
