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

Opt-in ActiveModel type casting for ActiveRecord attributes:

```ruby
require 'date_values/rails'

class Shop < ApplicationRecord
  attribute :billing_month, :year_month   # string column "2026-03"
  attribute :anniversary,   :month_day    # string column "--03-19"
  attribute :opens_at,      :time_of_day  # string or time column
end
```

Values are automatically serialized in queries:

```ruby
Shop.where(billing_month: YearMonth.new(2026, 3))
# SELECT * FROM shops WHERE billing_month = '2026-03'
```

### Validation

All classes are `Comparable` and value-equal, so standard Rails validators work as-is:

```ruby
class Contract < ApplicationRecord
  attribute :start_month, :year_month
  attribute :opens_at,    :time_of_day

  validates :start_month, comparison: {greater_than: -> { YearMonth.from(Date.current) }}
  validates :opens_at,    comparison: {
    greater_than_or_equal_to: TimeOfDay.new(9, 0),
    less_than_or_equal_to:    TimeOfDay.new(17, 0)
  }
end
```

Invalid input (e.g. `"25:00"`) is cast to `nil` rather than raising, following the same convention as Rails' built-in types.


### I18n / `l` Helper

All classes implement `#strftime`, and the Rails integration extends `I18n.l` to support them. Define formats in your locale files:

```yaml
# config/locales/en.yml
en:
  year_month:
    formats:
      default: '%B %Y'
  month_day:
    formats:
      default: '%B %-d'
  time_of_day:
    formats:
      default: '%-I:%M %p'
      long: '%-I:%M:%S %p'
```

```yaml
# config/locales/ja.yml
ja:
  year_month:
    formats:
      default: '%Y年%-m月'
  month_day:
    formats:
      default: '%-m月%-d日'
  time_of_day:
    formats:
      default: '%-H時%-M分'
      long: '%-H時%-M分%-S秒'
```

```ruby
I18n.l YearMonth.new(2026, 3), locale: :en   # => "March 2026"
I18n.l YearMonth.new(2026, 3), locale: :ja   # => "2026年3月"
I18n.l TimeOfDay.new(14, 30), format: :long  # => "2:30:00 PM"
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
