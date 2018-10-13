require "garoon-cat"

module GaroonScheduler
  class ApiClient
    def initialize(uri, username, password)
      garoon = GaroonCat.setup(
        uri: uri,
        username: username,
        password: password
      )
      @service = garoon.service(:schedule)
    end

    def get_events(params)
      response = @service.get_events(params)
      extract_events(response)
    end

    private

      def extract_events(response)
        schedule_event = response.dig("schedule_event")
        return [] unless schedule_event

        schedule_event.inject([]) do |events, event|
          events += EventExtractFactory.new(event).extract_events
        end
      end
  end
end
