# frozen_string_literal: true

require 'test_helper'

class TestYearMonth < Minitest::Test
  def test_new
    ym = YearMonth.new(2026, 3)
    assert_equal 2026, ym.year
    assert_equal 3, ym.month
  end

  def test_invalid_month
    assert_raises(ArgumentError) { YearMonth.new(2026, 0) }
    assert_raises(ArgumentError) { YearMonth.new(2026, 13) }
  end

  def test_from_date
    assert_equal YearMonth.new(2026, 3), YearMonth.from(Date.new(2026, 3, 19))
  end

  def test_parse
    ym = YearMonth.parse('2026-03')
    assert_equal YearMonth.new(2026, 3), ym
  end

  def test_parse_invalid
    assert_raises(ArgumentError) { YearMonth.parse('2026-3') }
    assert_raises(ArgumentError) { YearMonth.parse('2026/03') }
  end

  def test_comparable
    assert_operator YearMonth.new(2026, 1), :<, YearMonth.new(2026, 2)
    assert_operator YearMonth.new(2025, 12), :<, YearMonth.new(2026, 1)
    assert_equal YearMonth.new(2026, 3), YearMonth.new(2026, 3)
  end

  def test_addition
    assert_equal YearMonth.new(2026, 4), YearMonth.new(2026, 3) + 1
    assert_equal YearMonth.new(2027, 1), YearMonth.new(2026, 12) + 1
    assert_equal YearMonth.new(2027, 3), YearMonth.new(2026, 3) + 12
  end

  def test_subtraction_integer
    assert_equal YearMonth.new(2026, 2), YearMonth.new(2026, 3) - 1
    assert_equal YearMonth.new(2025, 12), YearMonth.new(2026, 1) - 1
  end

  def test_subtraction_year_month
    assert_equal 2, YearMonth.new(2026, 3) - YearMonth.new(2026, 1)
    assert_equal(-3, YearMonth.new(2026, 1) - YearMonth.new(2026, 4))
    assert_equal 12, YearMonth.new(2027, 1) - YearMonth.new(2026, 1)
  end

  def test_succ
    assert_equal YearMonth.new(2026, 4), YearMonth.new(2026, 3).succ
  end

  def test_range
    range = YearMonth.new(2026, 1)..YearMonth.new(2026, 3)
    assert_equal [YearMonth.new(2026, 1), YearMonth.new(2026, 2), YearMonth.new(2026, 3)], range.to_a
  end

  def test_strftime
    assert_equal '2026年03月', YearMonth.new(2026, 3).strftime('%Y年%m月')
  end

  def test_to_date
    assert_equal Date.new(2026, 3, 1), YearMonth.new(2026, 3).to_date
  end

  def test_to_s
    assert_equal '2026-03', YearMonth.new(2026, 3).to_s
  end

  def test_inspect
    assert_equal '#<DateValues::YearMonth 2026-03>', YearMonth.new(2026, 3).inspect
  end
end
