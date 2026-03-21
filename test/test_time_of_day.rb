# frozen_string_literal: true

require 'test_helper'

class TestTimeOfDay < Minitest::Test
  def test_new
    tod = TimeOfDay.new(14, 30)
    assert_equal 14, tod.hour
    assert_equal 30, tod.minute
    assert_equal 0, tod.second
  end

  def test_new_with_second
    tod = TimeOfDay.new(14, 30, 45)
    assert_equal 45, tod.second
  end

  def test_invalid_hour
    assert_raises(ArgumentError) { TimeOfDay.new(-1, 0) }
    assert_raises(ArgumentError) { TimeOfDay.new(24, 0) }
  end

  def test_invalid_minute
    assert_raises(ArgumentError) { TimeOfDay.new(0, -1) }
    assert_raises(ArgumentError) { TimeOfDay.new(0, 60) }
  end

  def test_invalid_second
    assert_raises(ArgumentError) { TimeOfDay.new(0, 0, -1) }
    assert_raises(ArgumentError) { TimeOfDay.new(0, 0, 60) }
  end

  def test_from_time
    assert_equal TimeOfDay.new(14, 30, 45), TimeOfDay.from(Time.new(2026, 3, 19, 14, 30, 45))
  end

  def test_parse_hm
    tod = TimeOfDay.parse('14:30')
    assert_equal TimeOfDay.new(14, 30), tod
  end

  def test_parse_hms
    tod = TimeOfDay.parse('14:30:45')
    assert_equal TimeOfDay.new(14, 30, 45), tod
  end

  def test_parse_invalid
    assert_raises(ArgumentError) { TimeOfDay.parse('14') }
    assert_raises(ArgumentError) { TimeOfDay.parse('14:30:45:00') }
  end

  def test_comparable
    assert_operator TimeOfDay.new(9, 0), :<, TimeOfDay.new(17, 0)
    assert_operator TimeOfDay.new(14, 30), :<, TimeOfDay.new(14, 31)
    assert_operator TimeOfDay.new(14, 30, 0), :<, TimeOfDay.new(14, 30, 1)
    assert_equal TimeOfDay.new(14, 30), TimeOfDay.new(14, 30, 0)
  end

  def test_addition
    assert_equal TimeOfDay.new(14, 31), TimeOfDay.new(14, 30) + 60
    assert_equal TimeOfDay.new(15, 0), TimeOfDay.new(14, 30) + 1800
  end

  def test_addition_wraps
    assert_equal TimeOfDay.new(0, 30), TimeOfDay.new(23, 30) + 3600
  end

  def test_subtraction
    assert_equal TimeOfDay.new(14, 29), TimeOfDay.new(14, 30) - 60
  end

  def test_subtraction_wraps
    assert_equal TimeOfDay.new(23, 30), TimeOfDay.new(0, 30) - 3600
  end

  def test_advance
    assert_equal TimeOfDay.new(16, 45, 30), TimeOfDay.new(14, 30).advance(hours: 2, minutes: 15, seconds: 30)
  end

  def test_change
    assert_equal TimeOfDay.new(14, 0), TimeOfDay.new(14, 30, 45).change(minute: 0, second: 0)
    assert_equal TimeOfDay.new(9, 30, 45), TimeOfDay.new(14, 30, 45).change(hour: 9)
  end

  def test_to_seconds
    assert_equal 52_245, TimeOfDay.new(14, 30, 45).to_seconds
    assert_equal 0, TimeOfDay.new(0, 0, 0).to_seconds
  end

  def test_from_seconds
    assert_equal TimeOfDay.new(14, 30, 45), TimeOfDay.from_seconds(52_245)
    assert_equal TimeOfDay.new(0, 0), TimeOfDay.from_seconds(0)
  end

  def test_strftime
    assert_equal '02:30 PM', TimeOfDay.new(14, 30).strftime('%I:%M %p')
  end

  def test_as_json
    assert_equal '14:30', TimeOfDay.new(14, 30).as_json
    assert_equal '14:30:45', TimeOfDay.new(14, 30, 45).as_json
  end

  def test_to_s_without_second
    assert_equal '14:30', TimeOfDay.new(14, 30).to_s
  end

  def test_to_s_with_second
    assert_equal '14:30:45', TimeOfDay.new(14, 30, 45).to_s
  end

  def test_inspect
    assert_equal '#<DateValues::TimeOfDay 14:30>', TimeOfDay.new(14, 30).inspect
  end
end
