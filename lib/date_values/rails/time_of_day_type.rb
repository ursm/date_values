# frozen_string_literal: true

module DateValues
  module Rails
    class TimeOfDayType < ActiveModel::Type::Value
      def type
        :time_of_day
      end

      def cast(value)
        case value
        when TimeOfDay then value
        when Time      then TimeOfDay.new(value.hour, value.min, value.sec)
        when String    then TimeOfDay.parse(value)
        when nil       then nil
        end
      rescue ArgumentError
        nil
      end

      def serialize(value)
        value&.to_s
      end

      def deserialize(value)
        case value
        when nil       then nil
        when Time      then TimeOfDay.new(value.hour, value.min, value.sec)
        when String    then TimeOfDay.parse(value)
        end
      end
    end
  end
end
