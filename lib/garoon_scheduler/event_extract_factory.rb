module GaroonScheduler
  class EventExtractFactory
    def initialize(event)
      @extractor = case event["event_type"]
        when Event::EVENT_TYPE_NORMAL then NormalEventExtractor.new(event)
        when Event::EVENT_TYPE_REPEAT then RepeatEventExtractor.new(event)
        when Event::EVENT_TYPE_BANNER then BannerEventExtractor.new(event)
      end
    end

    def extract_events
      @extractor.run()
    end
  end
end
