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

YearMonth.from(Date.today)       # => YearMonth[2026-03]
YearMonth.parse('2026-03')       # => YearMonth[2026-03]

ym + 1                           # => YearMonth[2026-04]
ym - 1                           # => YearMonth[2026-02]
YearMonth.new(2026, 3) - YearMonth.new(2025, 1)  # => 14

# Range support
(YearMonth.new(2026, 1)..YearMonth.new(2026, 3)).to_a
# => [YearMonth[2026-01], YearMonth[2026-02], YearMonth[2026-03]]
```

### MonthDay

```ruby
md = MonthDay.new(3, 19)
md.to_s                          # => "--03-19"
md.to_date(2026)                 # => #<Date: 2026-03-19>

MonthDay.from(Date.today)        # => MonthDay[--03-20]
MonthDay.parse('--03-19')        # => MonthDay[--03-19]

# Range membership
summer = MonthDay.new(6, 1)..MonthDay.new(8, 31)
summer.cover?(MonthDay.new(7, 15))    # => true
```

### TimeOfDay

```ruby
tod = TimeOfDay.new(14, 30)
tod.to_s                         # => "14:30"

TimeOfDay.new(14, 30, 45).to_s  # => "14:30:45"

TimeOfDay.from(Time.now)         # => TimeOfDay[14:30]
TimeOfDay.parse('14:30')         # => TimeOfDay[14:30]

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
      default: '%-H時%M分'
```

```ruby
I18n.l YearMonth.new(2026, 3), locale: :en  # => "March 2026"
I18n.l YearMonth.new(2026, 3), locale: :ja  # => "2026年3月"
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
