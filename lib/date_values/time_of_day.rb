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

    def self.parse(str)
      parts = str.split(':')
      raise ArgumentError, "invalid TimeOfDay: #{str}" unless [2, 3].include?(parts.size)

      new(*parts.map(&:to_i))
    end

    def <=>(other)
      return nil unless other.is_a?(TimeOfDay)

      [hour, minute, second] <=> [other.hour, other.minute, other.second]
    end

    def to_s
      if second.zero?
        format('%02d:%02d', hour, minute)
      else
        format('%02d:%02d:%02d', hour, minute, second)
      end
    end

    def inspect
      "TimeOfDay[#{self}]"
    end
  end
end
