# frozen_string_literal: true

require 'date'

module DateValues
  YearMonth = Data.define(:year, :month) do
    include Comparable

    def initialize(year:, month:)
      raise ArgumentError, "invalid month: #{month}" unless (1..12).include?(month)

      super
    end

    def self.from(date)
      new(date.year, date.month)
    end

    def self.parse(str)
      case str
      when /\A(\d{4})[\/\-](\d{1,2})\z/ then new($1.to_i, $2.to_i)
      else raise ArgumentError, "invalid YearMonth: #{str}"
      end
    end

    def <=>(other)
      return nil unless other.is_a?(YearMonth)

      [year, month] <=> [other.year, other.month]
    end

    def +(n)
      total = (year * 12 + (month - 1)) + n
      self.class.new(total / 12, total % 12 + 1)
    end

    def -(other)
      case other
      when Integer
        self + (-other)
      when YearMonth
        (year * 12 + month) - (other.year * 12 + other.month)
      else
        raise TypeError, "#{other.class} can't be coerced into Integer or YearMonth"
      end
    end

    def succ
      self + 1
    end

    def advance(years: 0, months: 0)
      self + (years * 12 + months)
    end

    def change(year: self.year, month: self.month)
      self.class.new(year, month)
    end

    def days
      Date.new(year, month, -1).day
    end

    def strftime(format)
      to_date.strftime(format)
    end

    def to_date_range
      to_date...(self + 1).to_date
    end

    def to_date
      Date.new(year, month, 1)
    end

    def as_json(*)
      to_s
    end

    def to_s
      format('%04d-%02d', year, month)
    end

    def inspect
      "#<DateValues::YearMonth #{self}>"
    end
  end
end
