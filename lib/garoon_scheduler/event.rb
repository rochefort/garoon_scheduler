module GaroonScheduler
  class Event < Struct.new(:event_type, :title, :start_at, :end_at)
    EVENT_TYPE_NORMAL = "normal"
    EVENT_TYPE_REPEAT = "repeat"
    EVENT_TYPE_BANNER = "banner"

    def print
      mark = is_today(start_at) ? " *" : "  "
      start_day = start_at&.strftime("%m/%d")
      start_time = start_at&.strftime("%H:%M")
      end_time = end_at&.strftime("%H:%M")

      if event_type == EVENT_TYPE_BANNER
        end_day = end_at&.strftime("%m/%d")
        puts "#{mark} #{start_day}               : #{title}"
      else
        puts "#{mark} #{start_day} #{start_time} - #{end_time} : #{title}"
      end
    end

    private

      def is_today(time)
        Time.now.strftime("%Y-%m-%d") == time.strftime("%Y-%m-%d")
      end
  end
end
