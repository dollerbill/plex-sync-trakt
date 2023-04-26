# frozen_string_literal: true

module Trakt
  module Authenticate
    module Token
      DEVICE_CODE_URL = 'https://api.trakt.tv/oauth/device/code'
      DEVICE_TOKEN_URL = 'https://api.trakt.tv/oauth/device/token'
      OAUTH_TOKEN_URL = 'https://api.trakt.tv/oauth/token'

      def base_json
        { 'client_id' => TRAKT_ID, 'client_secret' => TRAKT_SECRET }
      end

      def handle_response(response)
        token_data = JSON.parse(response.body.to_s)
        access_token = token_data['access_token']
        refresh_token = token_data['refresh_token']
        expires_at = token_data['created_at'] + token_data['expires_in']
        puts "Access token: #{access_token}"
        puts "Refresh token: #{refresh_token}"
        puts "Expires at: #{Time.at(expires_at)}"
        puts 'Store these tokens in your environment variables or application secrets for future use.'
      end
    end
  end
end
