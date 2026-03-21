# DateValues

Value objects for `YearMonth`, `MonthDay`, and `TimeOfDay` — the date/time types Ruby is missing.

Ruby has `Date`, `Time`, and `DateTime`, but no way to represent "March 2026" without picking a day, "March 19" without picking a year, or "14:30" without picking a date. DateValues fills that gap with immutable, `Comparable` value objects built on `Data.define`.

## Installation

```bash
bundle add date_values
```

## Usage

```ruby
require 'date_values'
include DateValues
```

### YearMonth

```ruby
ym = YearMonth.new(2026, 3)
ym.to_s                          # => "2026-03"
ym.to_date                       # => #<Date: 2026-03-01>
ym.days                          # => 31

YearMonth.from(Date.today)       # => #<DateValues::YearMonth 2026-03>
YearMonth.parse('2026-03')       # => #<DateValues::YearMonth 2026-03>
YearMonth.parse('2026/3')        # also works

ym + 1                           # => #<DateValues::YearMonth 2026-04>
ym - 1                           # => #<DateValues::YearMonth 2026-02>
YearMonth.new(2026, 3) - YearMonth.new(2025, 1)  # => 14

ym.advance(years: 1, months: 2)  # => #<DateValues::YearMonth 2027-05>
ym.change(year: 2025)            # => #<DateValues::YearMonth 2025-03>

# Range support
(YearMonth.new(2026, 1)..YearMonth.new(2026, 3)).to_a
# => [#<DateValues::YearMonth 2026-01>, #<DateValues::YearMonth 2026-02>, #<DateValues::YearMonth 2026-03>]
```

### MonthDay

String representation uses ISO 8601 `--MM-DD` format (year omitted):

```ruby
md = MonthDay.new(3, 19)
md.to_s                          # => "--03-19"
md.to_date(2026)                 # => #<Date: 2026-03-19>

MonthDay.from(Date.today)        # => #<DateValues::MonthDay --03-20>
MonthDay.parse('--03-19')        # => #<DateValues::MonthDay --03-19>
MonthDay.parse('3/19')           # also works (month/day order by default)

md.change(month: 12)             # => #<DateValues::MonthDay --12-19>

# Range membership
summer = MonthDay.new(6, 1)..MonthDay.new(8, 31)
summer.cover?(MonthDay.new(7, 15))    # => true
```

### TimeOfDay

```ruby
tod = TimeOfDay.new(14, 30)
tod.to_s                         # => "14:30"

TimeOfDay.new(14, 30, 45).to_s  # => "14:30:45"

TimeOfDay.from(Time.now)         # => #<DateValues::TimeOfDay 14:30>
TimeOfDay.parse('14:30')         # => #<DateValues::TimeOfDay 14:30>

tod + 3600                       # => #<DateValues::TimeOfDay 15:30>
tod - 1800                       # => #<DateValues::TimeOfDay 14:00>
TimeOfDay.new(17, 0) - TimeOfDay.new(9, 0)  # => 28800 (seconds)
tod.advance(hours: 2, minutes: 15)  # => #<DateValues::TimeOfDay 16:45>
tod.change(minute: 0)            # => #<DateValues::TimeOfDay 14:00>
tod.to_seconds                   # => 52200
TimeOfDay.from_seconds(52200)    # => #<DateValues::TimeOfDay 14:30>

# Wraps at 24h boundaries
TimeOfDay.new(23, 30) + 3600    # => #<DateValues::TimeOfDay 00:30>

# Range membership
business_hours = TimeOfDay.new(9, 0)..TimeOfDay.new(17, 0)
business_hours.cover?(TimeOfDay.new(12, 30))    # => true
```

### Pattern Matching

Built on `Data.define`, so pattern matching works out of the box:

```ruby
case YearMonth.new(2026, 3)
in { year: 2026, month: (1..3) }
  puts 'Q1 2026'
end

case MonthDay.new(12, 25)
in { month: 12, day: 25 }
  puts 'Christmas'
end

case TimeOfDay.new(14, 30)
in { hour: (9..17) }
  puts 'Business hours'
end
```

### JSON

All classes implement `#as_json`, returning the same string as `#to_s`:

```ruby
YearMonth.new(2026, 3).as_json   # => "2026-03"
MonthDay.new(3, 19).as_json      # => "--03-19"
TimeOfDay.new(14, 30).as_json    # => "14:30"
```

## Configuration

### MonthDay parse order

By default, `MonthDay.parse` interprets ambiguous formats like `"3/19"` as month/day. For day/month (European convention):

```ruby
DateValues.config.month_day_order = :day_first

MonthDay.parse('19/3')   # => #<DateValues::MonthDay --03-19>
```

ISO 8601 format (`--MM-DD`) is always month/day regardless of this setting.

## Rails Integration

See [date_values-rails](https://github.com/ursm/date_values-rails) for ActiveModel/ActiveRecord type casting, validation, I18n, and ActiveJob support.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
