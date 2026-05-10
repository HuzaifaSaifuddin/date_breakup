# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Install dependencies
bin/setup

# Run all tests
bundle exec rake spec
# or
bundle exec rspec

# Run a single spec file
bundle exec rspec spec/date_breakup_spec.rb

# Interactive console (loads the gem)
bin/console

# Install gem locally
bundle exec rake install

# Release gem (bumps version tag, pushes to RubyGems)
bundle exec rake release
```

## Architecture

This is a single-file Ruby gem (`lib/date_breakup.rb`). The entire logic lives in the `DateBreakup` class.

**Entry point:** `DateBreakup.between(start_date, end_date)` — accepts `Date`, `Time`, or date strings; returns a `DateBreakup` instance. Raises `ArgumentError` if start is after end.

**Core pattern:** The four public methods (`in_years`, `in_months`, `in_weeks`, `in_days`) are all generated dynamically via `define_method` in a single `%w[years months weeks days].each` loop. Each method walks day-by-day from `@start_date` to `@end_date`, greedily consuming the largest possible unit (year > month > week > day) at each step. The `unit` variable in the loop controls which units are eligible — `in_days` only ever appends to `days`; `in_weeks` can use weeks and days; `in_months` can use months, weeks, and days; `in_years` can use all four.

**Return shape:** All four methods return the same hash `{ years: [], months: [], weeks: [], days: [] }` — higher-granularity methods simply leave the coarser arrays empty.

**Dependencies:** Zero runtime dependencies — uses only stdlib `require 'date'`.
