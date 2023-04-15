# frozen_string_literal: true

module Plex
  module Sync
    class Show < Base
      def call
        requests = 0
        library.all.each do |show|
          show.seasons.each do |season|
            season.episodes.each do |episode|
              puts "Starting #{show.title} - Season #{season.index} - Episode #{episode.index}- #{episode.title}"
              puts "Trakt requests: #{requests}"
              episode_atts = episode.attribute_hash

              next unless episode_atts['last_viewed_at']
              next if episode_watched?(show.title, season.index, episode.index)

              requests += 1
              trakt_show = Trakt::Search::Episode.call(episode_atts)
              next unless trakt_show

              requests += 1
              sleep(0.5)
              Trakt::Scrobble::Episode.call(trakt_show)
            end
          end
        end

        super
      end

      private

      def server
        'Show'
      end

      def episode_watched?(show_name, season_number, episode_number)
        show_data = watched_media.find { |entry| entry['show']['title'] == show_name }
        return false unless show_data

        season_data = show_data['seasons'].find { |season| season['number'] == season_number.to_i }
        return false unless season_data

        episode_data = season_data['episodes'].find { |episode| episode['number'] == episode_number.to_i }
        return false unless episode_data

        !episode_data['last_watched_at'].nil?
      end
    end
  end
end
