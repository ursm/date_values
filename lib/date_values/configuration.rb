# frozen_string_literal: true

module DateValues
  class Configuration
    attr_accessor :month_day_order

    def initialize
      @month_day_order = :month_first
    end
  end

  def self.config
    @config ||= Configuration.new
  end

  def self.configure
    yield config
  end
end
