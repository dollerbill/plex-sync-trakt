# frozen_string_literal: true

module Trakt
  module Authenticate
    class Access < Token
      def access_token
        response = HTTP.post(DEVICE_CODE_URL, json: { 'client_id' => TRAKT_ID })
        device_code_data = JSON.parse(response.body.to_s)

        device_code = device_code_data['device_code']
        user_code = device_code_data['user_code']
        verification_url = device_code_data['verification_url']
        interval = device_code_data['interval']

        puts "Please go to #{verification_url} and enter the code: #{user_code}"
        puts 'Waiting for user authorization...'

        access_token = nil
        loop do
          sleep(interval)

          json = base_json.merge({ 'code' => device_code })
          response = HTTP.post(DEVICE_TOKEN_URL, json:)

          case response.code
          when 200
            handle_response(response)
            break
          when 400
            # Waiting for the user to authorize the app, continue polling
          when 418, 429
            puts 'Slow down polling rate'
          else
            puts "Error: #{response.code}"
            break
          end
        end
      end
    end
  end
end
