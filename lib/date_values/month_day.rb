# frozen_string_literal: true

require 'date'

module DateValues
  MonthDay = Data.define(:month, :day) do
    include Comparable

    def initialize(month:, day:)
      raise ArgumentError, "invalid month: #{month}" unless (1..12).include?(month)
      raise ArgumentError, "invalid day: #{day} for month: #{month}" unless (1..max_day(month)).include?(day)

      super
    end

    def self.from(date)
      new(date.month, date.day)
    end

    def self.parse(str)
      case str
      when /\A--(\d{1,2})-(\d{1,2})\z/ then new($1.to_i, $2.to_i)
      when /\A(\d{1,2})[\/\-](\d{1,2})\z/ then new($1.to_i, $2.to_i)
      else raise ArgumentError, "invalid MonthDay: #{str}"
      end
    end

    def <=>(other)
      return nil unless other.is_a?(MonthDay)

      [month, day] <=> [other.month, other.day]
    end

    def strftime(format)
      # 2000 is a leap year, so Feb 29 works
      Date.new(2000, month, day).strftime(format)
    end

    def to_date(year)
      Date.new(year, month, day)
    end

    def as_json(*)
      to_s
    end

    def to_s
      format('--%02d-%02d', month, day)
    end

    def inspect
      "#<DateValues::MonthDay #{self}>"
    end

    private

    def max_day(m)
      case m
      when 2 then 29
      when 4, 6, 9, 11 then 30
      else 31
      end
    end
  end
end
