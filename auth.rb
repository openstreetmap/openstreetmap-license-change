require 'oauth2'

module Auth
  def self.client(y)
    OAuth2::Client.new y["oauth2"]["client_id"],
                       nil,
                       { :site => y["oauth2"]["site"],
                         :redirect_uri => "urn:ietf:wg:oauth:2.0:oob",
                         :authorize_url => "/oauth2/authorize",
                         :token_url => "/oauth2/token",
                         :raise_errors => false,
                         :connection_opts =>{ :request => { :open_timeout => 320, :read_timeout => 320 } } }
  end

  def self.access_token(y)
    OAuth2::AccessToken.new client(y), y["oauth2"]["token"]
  end
end
