# frozen_string_literal: true

module DateValues
  TimeOfDay = Data.define(:hour, :minute, :second) do
    include Comparable

    def initialize(hour:, minute:, second: 0)
      raise ArgumentError, "invalid hour: #{hour}" unless (0..23).include?(hour)
      raise ArgumentError, "invalid minute: #{minute}" unless (0..59).include?(minute)
      raise ArgumentError, "invalid second: #{second}" unless (0..59).include?(second)

      super
    end

    def self.from(time)
      new(time.hour, time.min, time.sec)
    end

    def self.parse(str)
      parts = str.split(':')
      raise ArgumentError, "invalid TimeOfDay: #{str}" unless [2, 3].include?(parts.size)

      new(*parts.map(&:to_i))
    end

    def <=>(other)
      return nil unless other.is_a?(TimeOfDay)

      [hour, minute, second] <=> [other.hour, other.minute, other.second]
    end

    def +(seconds)
      self.class.from_seconds((to_seconds + seconds) % 86_400)
    end

    def -(other)
      case other
      when Integer   then self + (-other)
      when TimeOfDay then to_seconds - other.to_seconds
      else raise TypeError, "#{other.class} can't be coerced into Integer or TimeOfDay"
      end
    end

    def advance(hours: 0, minutes: 0, seconds: 0)
      self + (hours * 3600 + minutes * 60 + seconds)
    end

    def change(hour: self.hour, minute: self.minute, second: self.second)
      self.class.new(hour, minute, second)
    end

    def to_seconds
      hour * 3600 + minute * 60 + second
    end

    def self.from_seconds(total)
      total = total % 86_400
      h, rest = total.divmod(3600)
      m, s    = rest.divmod(60)
      new(h, m, s)
    end

    def strftime(format)
      Time.new(2000, 1, 1, hour, minute, second).strftime(format)
    end

    def as_json(*)
      to_s
    end

    def to_s
      if second.zero?
        format('%02d:%02d', hour, minute)
      else
        format('%02d:%02d:%02d', hour, minute, second)
      end
    end

    def inspect
      "#<DateValues::TimeOfDay #{self}>"
    end
  end
end
