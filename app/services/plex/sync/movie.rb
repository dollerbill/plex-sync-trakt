# frozen_string_literal: true

module Plex
  module Sync
    class Movie < Base
      def call
        requests = 0
        library.all.each do |movie|
          next if ignore_list[:movies]&.include?(movie.title)

          puts "Starting #{movie.title}"
          puts "Trakt requests: #{requests}"
          movie_atts = movie.attribute_hash
          next unless movie_atts['last_viewed_at']
          next if watched_media.any? { |w| w['movie']['title'].match?(movie_atts['title']) }

          requests += 1
          trakt_movie = Trakt::Search::Movie.call(movie_atts)
          next unless trakt_movie

          requests += 1
          sleep(0.5)
          Trakt::Scrobble::Movie.call(trakt_movie)
        end

        super
      end

      private

      def server
        'Movie'
      end
    end
  end
end
