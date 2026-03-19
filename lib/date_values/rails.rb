# frozen_string_literal: true

require 'date_values'
require 'active_support'
require 'active_model/type'
require_relative 'rails/year_month_type'
require_relative 'rails/month_day_type'
require_relative 'rails/time_of_day_type'

ActiveModel::Type.register(:year_month, DateValues::Rails::YearMonthType)
ActiveModel::Type.register(:month_day, DateValues::Rails::MonthDayType)
ActiveModel::Type.register(:time_of_day, DateValues::Rails::TimeOfDayType)
