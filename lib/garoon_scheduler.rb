require "garoon_scheduler/api_client"
require "garoon_scheduler/ext"
require "garoon_scheduler/event"
require "garoon_scheduler/event_extract_factory"
require "garoon_scheduler/event_extractor"
require "garoon_scheduler/version"

# TODO: load url from the config file
# WSDL_URI = "https://info2.nri-net.com/cgi-bin/cbgrn/grn.cgi?WSDL"
WSDL_URI = "https://rochefort.cybozu.com/g/index.csp?WSDL"
USERNAME = "terasawan@gmail.com"
PASSWORD = "gyoshimura3"

module GaroonScheduler
  class << self
    def show
      client = ApiClient.new(WSDL_URI, USERNAME, PASSWORD)
      params = {
        "@start": "#{Date.today}T00:00:00Z",
        "@end": "#{(Date.today + 5)}T00:00:00Z"
      }
      events = client.get_events(params)
      print_events(events)
    end

    private

      def print_events(events)
        events.sort { |x, y| x.start_at <=> y.start_at }
        .each { |e| e.print }
      end
  end
end
