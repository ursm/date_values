# frozen_string_literal: true

require 'test_helper'
require 'date_values/rails'

class TestYearMonthType < Minitest::Test
  def setup
    @type = DateValues::Rails::YearMonthType.new
  end

  def test_type
    assert_equal :year_month, @type.type
  end

  def test_cast_from_string
    assert_equal YearMonth.new(2026, 3), @type.cast('2026-03')
  end

  def test_cast_from_year_month
    ym = YearMonth.new(2026, 3)
    assert_same ym, @type.cast(ym)
  end

  def test_cast_nil
    assert_nil @type.cast(nil)
  end

  def test_serialize
    assert_equal '2026-03', @type.serialize(YearMonth.new(2026, 3))
  end

  def test_serialize_nil
    assert_nil @type.serialize(nil)
  end

  def test_deserialize
    assert_equal YearMonth.new(2026, 3), @type.deserialize('2026-03')
  end

  def test_deserialize_nil
    assert_nil @type.deserialize(nil)
  end
end

class TestMonthDayType < Minitest::Test
  def setup
    @type = DateValues::Rails::MonthDayType.new
  end

  def test_type
    assert_equal :month_day, @type.type
  end

  def test_cast_from_string
    assert_equal MonthDay.new(3, 19), @type.cast('--03-19')
  end

  def test_cast_from_month_day
    md = MonthDay.new(3, 19)
    assert_same md, @type.cast(md)
  end

  def test_cast_nil
    assert_nil @type.cast(nil)
  end

  def test_serialize
    assert_equal '--03-19', @type.serialize(MonthDay.new(3, 19))
  end

  def test_deserialize
    assert_equal MonthDay.new(3, 19), @type.deserialize('--03-19')
  end
end

class TestTimeOfDayType < Minitest::Test
  def setup
    @type = DateValues::Rails::TimeOfDayType.new
  end

  def test_type
    assert_equal :time_of_day, @type.type
  end

  def test_cast_from_string
    assert_equal TimeOfDay.new(14, 30), @type.cast('14:30')
  end

  def test_cast_from_string_with_second
    assert_equal TimeOfDay.new(14, 30, 45), @type.cast('14:30:45')
  end

  def test_cast_from_time
    assert_equal TimeOfDay.new(14, 30, 45), @type.cast(Time.new(2000, 1, 1, 14, 30, 45))
  end

  def test_cast_from_time_of_day
    tod = TimeOfDay.new(14, 30)
    assert_same tod, @type.cast(tod)
  end

  def test_cast_nil
    assert_nil @type.cast(nil)
  end

  def test_serialize
    assert_equal '14:30', @type.serialize(TimeOfDay.new(14, 30))
  end

  def test_serialize_with_second
    assert_equal '14:30:45', @type.serialize(TimeOfDay.new(14, 30, 45))
  end

  def test_deserialize
    assert_equal TimeOfDay.new(14, 30), @type.deserialize('14:30')
  end

  def test_deserialize_from_time
    assert_equal TimeOfDay.new(14, 30, 45), @type.deserialize(Time.new(2000, 1, 1, 14, 30, 45))
  end
end
