# frozen_string_literal: true

module DateValues
  module Rails
    class MonthDayType < ActiveModel::Type::Value
      def type
        :month_day
      end

      def cast(value)
        case value
        when MonthDay then value
        when String   then MonthDay.parse(value)
        when nil      then nil
        end
      rescue ArgumentError
        nil
      end

      def serialize(value)
        value&.to_s
      end

      def deserialize(value)
        return nil if value.nil?

        MonthDay.parse(value)
      end
    end
  end
end
