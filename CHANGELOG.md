## [Unreleased]

- Remove `YearMonth#to_date_range` — use `ym.to_date.in_time_zone.all_month` instead

## [0.2.3] - 2026-03-31

- Add `YearMonth#to_date_range` — returns an exclusive `Date` range for the month, ideal for ActiveRecord queries on timestamp columns

## [0.2.2] - 2026-03-21

- `TimeOfDay#-` accepts `TimeOfDay` to return difference in seconds

## [0.2.1] - 2026-03-21

- Add `TimeOfDay` arithmetic (`+`, `-`), `advance`, `change`, `to_seconds`, `.from_seconds`
- Add `YearMonth#advance`, `YearMonth#change`, `YearMonth#days`
- Add `MonthDay#change`
- Add `#as_json` to all value classes
- Add `DateValues.config.month_day_order` for locale-dependent `MonthDay.parse`

## [0.2.0] - 2026-03-20

- **Breaking**: Rails integration extracted to [date_values-rails](https://github.com/ursm/date_values-rails). `require 'date_values/rails'` now requires installing `date_values-rails` gem.

## [0.1.4] - 2026-03-20

- Cast returns `nil` for invalid input instead of raising, following Rails convention
- Add `date_value` validator to distinguish "invalid input" from "no input"
- `#inspect` now uses `#<ClassName value>` format following Ruby convention
- Works with Rails standard validators (`comparison`, `inclusion`, `exclusion`)

## [0.1.3] - 2026-03-20

- Fix ActiveRecord type registration — use `ActiveSupport.on_load(:active_record)` to register types regardless of load order
- Values now work directly in ActiveRecord queries (`Shop.where(billing_month: YearMonth.new(2026, 3))`)

## [0.1.2] - 2026-03-19

- Add `#strftime` to `YearMonth`, `MonthDay`, and `TimeOfDay`
- Add I18n backend extension for Rails `l` helper — looks up `year_month.formats`, `month_day.formats`, and `time_of_day.formats` in locale files

## [0.1.1] - 2026-03-19

- Add `.from` class methods for converting from `Date` / `Time` (`YearMonth.from(date)`, `MonthDay.from(date)`, `TimeOfDay.from(time)`)

## [0.1.0] - 2026-03-19

- `DateValues::YearMonth` — year-month value object with arithmetic (`+`, `-`), `Range` support, and `Date` conversion
- `DateValues::MonthDay` — month-day value object with ISO 8601 `--MM-DD` format
- `DateValues::TimeOfDay` — time-of-day value object with optional seconds
- All classes are `Data.define`-based (immutable, value equality) and include `Comparable`
- `require 'date_values/rails'` registers ActiveModel types (`:year_month`, `:month_day`, `:time_of_day`)
- RBS type signatures included
