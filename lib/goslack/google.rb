class Goslack
  class Google

    attr_accessor :application_name, :application_version
    attr_accessor :analytics
    attr_accessor :client, :email, :key, :key_secret, :signing_key

    def initialize(options = {})
      @application_name = 'Goslack'
      @application_version = Goslack::VERSION
      @analytics = Goslack::Google::Analytics.new

      yield(self) if block_given?

      @client = ::Google::APIClient.new(
        application_name: @application_name,
        application_version: @application_version
      )
    end

    def authorize_client!
      if @signing_key.nil? && @key && @key_secret
        @signing_key = ::Google::APIClient::KeyUtils.load_from_pkcs12(@key, @key_secret)
      end

      if @signing_key
        @client.authorization = Signet::OAuth2::Client.new(
          token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
          audience: 'https://accounts.google.com/o/oauth2/token',
          scope: 'https://www.googleapis.com/auth/analytics.readonly',
          issuer: @email,
          signing_key: @signing_key
        )

        @client.authorization.fetch_access_token!
      end
    end
  end
end
