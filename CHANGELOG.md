## [Unreleased]

## [0.1.0] - 2026-03-19

- `DateValues::YearMonth` — year-month value object with arithmetic (`+`, `-`), `Range` support, and `Date` conversion
- `DateValues::MonthDay` — month-day value object with ISO 8601 `--MM-DD` format
- `DateValues::TimeOfDay` — time-of-day value object with optional seconds
- All classes are `Data.define`-based (immutable, value equality) and include `Comparable`
- `require 'date_values/rails'` registers ActiveModel types (`:year_month`, `:month_day`, `:time_of_day`)
- RBS type signatures included
