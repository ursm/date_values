# frozen_string_literal: true

require 'active_model/validator'

class DateValueValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.nil? && options[:allow_nil]

    raw = record.read_attribute_before_type_cast(attribute)
    return if raw.blank?
    return unless value.nil?

    record.errors.add(attribute, :invalid, **options.except(:allow_nil))
  end
end
