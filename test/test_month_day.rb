# frozen_string_literal: true

require 'test_helper'

class TestMonthDay < Minitest::Test
  def test_new
    md = MonthDay.new(3, 19)
    assert_equal 3, md.month
    assert_equal 19, md.day
  end

  def test_invalid_month
    assert_raises(ArgumentError) { MonthDay.new(0, 1) }
    assert_raises(ArgumentError) { MonthDay.new(13, 1) }
  end

  def test_invalid_day
    assert_raises(ArgumentError) { MonthDay.new(2, 30) }
    assert_raises(ArgumentError) { MonthDay.new(4, 31) }
    assert_raises(ArgumentError) { MonthDay.new(1, 32) }
  end

  def test_feb_29_is_valid
    md = MonthDay.new(2, 29)
    assert_equal 29, md.day
  end

  def test_parse
    md = MonthDay.parse('--03-19')
    assert_equal MonthDay.new(3, 19), md
  end

  def test_parse_invalid
    assert_raises(ArgumentError) { MonthDay.parse('03-19') }
    assert_raises(ArgumentError) { MonthDay.parse('--3-19') }
  end

  def test_comparable
    assert_operator MonthDay.new(3, 1), :<, MonthDay.new(3, 2)
    assert_operator MonthDay.new(2, 28), :<, MonthDay.new(3, 1)
    assert_equal MonthDay.new(3, 19), MonthDay.new(3, 19)
  end

  def test_to_date
    assert_equal Date.new(2026, 3, 19), MonthDay.new(3, 19).to_date(2026)
  end

  def test_to_s
    assert_equal '--03-19', MonthDay.new(3, 19).to_s
  end

  def test_inspect
    assert_equal 'MonthDay[--03-19]', MonthDay.new(3, 19).inspect
  end
end
