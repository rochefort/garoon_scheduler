require "date"
require "time"

module GaroonScheduler
  class EventExtractor
    def initialize(event)
      @event = event
      @event_type = event["event_type"]
      @detail = event["detail"]
    end

    def run
      raise "Called abstract method!!"
    end

    private
      def localtime(t)
        return nil unless t

        t = Time.parse(t)
        t.localtime
      end
  end

  class NormalEventExtractor < EventExtractor
    def run
      event_date = @event.dig("when", 0, "datetime", 0)
      start_at = localtime(event_date&.dig("start"))
      end_at   = localtime(event_date&.dig("end"))

      [Event.new(@event_type, @detail, start_at, end_at)]
    end
  end

  class RepeatEventExtractor < EventExtractor
    def run
      repeat_info = @event.dig("repeat_info", 0)
      condition = repeat_info.dig("condition", 0)
      week = condition["week"].to_i
      day = (Date.today..(Date.today + 5)).find { |d| d.wday == week }

      start_at = Time.parse("#{day} #{condition['start_time']}")
      end_at   = Time.parse("#{day} #{condition['end_date']}")
      [Event.new(@event_type, @detail, start_at, end_at)]
    end
  end

  class BannerEventExtractor < EventExtractor
    def run
      event_date = @event.dig("when", 0, "date", 0)
      start_date = event_date&.dig("start")
      end_date   = event_date&.dig("end")
      (start_date..end_date).take_while { |d| d <= (Date.today + 5).to_s }
        .map do |d|
          start_at = localtime(d)
          end_at   = Time.parse("#{d} 23:59:59")
          Event.new(@event_type, @detail, start_at, end_at)
      end
    end
  end
end
