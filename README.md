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

YearMonth.from(Date.today)       # => #<DateValues::YearMonth 2026-03>
YearMonth.parse('2026-03')       # => #<DateValues::YearMonth 2026-03>
YearMonth.parse('2026/3')        # also works

ym + 1                           # => #<DateValues::YearMonth 2026-04>
ym - 1                           # => #<DateValues::YearMonth 2026-02>
YearMonth.new(2026, 3) - YearMonth.new(2025, 1)  # => 14

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
MonthDay.parse('3/19')           # also works (always month/day order)

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

## Rails Integration

See [date_values-rails](https://github.com/ursm/date_values-rails) for ActiveModel/ActiveRecord type casting, validation, and I18n support.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
