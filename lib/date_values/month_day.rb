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
      raise ArgumentError, "invalid MonthDay: #{str}" unless str.match?(/\A--\d{2}-\d{2}\z/)

      month, day = str[2..].split('-').map(&:to_i)
      new(month, day)
    end

    def <=>(other)
      return nil unless other.is_a?(MonthDay)

      [month, day] <=> [other.month, other.day]
    end

    def to_date(year)
      Date.new(year, month, day)
    end

    def to_s
      format('--%02d-%02d', month, day)
    end

    def inspect
      "MonthDay[#{self}]"
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
