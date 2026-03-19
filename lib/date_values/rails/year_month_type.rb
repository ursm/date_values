# frozen_string_literal: true

module DateValues
  module Rails
    class YearMonthType < ActiveModel::Type::Value
      def type
        :year_month
      end

      def cast(value)
        case value
        when YearMonth then value
        when String    then YearMonth.parse(value)
        when nil       then nil
        else raise ArgumentError, "can't cast #{value.class} to YearMonth"
        end
      end

      def serialize(value)
        value&.to_s
      end

      def deserialize(value)
        return nil if value.nil?

        YearMonth.parse(value)
      end
    end
  end
end
