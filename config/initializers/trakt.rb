# frozen_string_literal: true

TRAKT_BASE_URL = 'https://api.trakt.tv'
TRAKT_ACCESS_TOKEN = Rails.application.credentials[:TRAKT_ACCESS_TOKEN].freeze
TRAKT_ID = Rails.application.credentials[:TRAKT_CLIENT_ID].freeze
TRAKT_SECRET = Rails.application.credentials[:TRAKT_CLIENT_SECRET].freeze
TRAKT_USERNAME = Rails.application.credentials[:TRAKT_USERNAME].freeze

BASE_HEADERS = {
  'Content-Type' => 'application/json',
  'trakt-api-version' => '2',
  'trakt-api-key' => TRAKT_ID
}.freeze
