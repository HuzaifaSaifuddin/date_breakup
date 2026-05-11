# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Install the pinned Ruby version (uses .mise.toml)
mise install

# Install dependencies
bin/setup

# Run all tests
bundle exec rake spec
# or
bundle exec rspec

# Run a single spec file
bundle exec rspec spec/date_breakup_spec.rb

# Lint (CI also runs this — keep it green)
bundle exec rubocop

# Interactive console (loads the gem)
bin/console

# Install gem locally
bundle exec rake install

# Release gem (bumps version tag, pushes to RubyGems)
bundle exec rake release
```

Ruby is pinned to 3.3 via `.mise.toml`. CI (`.github/workflows/ci.yml`) runs `rspec` then `rubocop` on push/PR. The CI matrix is currently `['3.3']` only — broadening it is a deliberate decision, not a default.

## Architecture

This is a single-file Ruby gem (`lib/date_breakup.rb`). The entire logic lives in the `DateBreakup` class.

**Entry point:** `DateBreakup.between(start_date, end_date)` — accepts `Date`, `Time`, or date strings (coerced via the private class method `coerce_to_date`); returns a `DateBreakup` instance. Raises `ArgumentError` if start is after end, or if a value isn't `Date`/`Time`/`String`.

**Core pattern:** The four public methods are thin endless-method wrappers that all delegate to a private `build_breakdown(years:, months:, weeks:)` with different boolean flags:

```ruby
def in_years  = build_breakdown(years: true,  months: true,  weeks: true)
def in_months = build_breakdown(years: false, months: true,  weeks: true)
def in_weeks  = build_breakdown(years: false, months: false, weeks: true)
def in_days   = build_breakdown(years: false, months: false, weeks: false)
```

`build_breakdown` walks day-by-day from `@start_date` to `@end_date`, greedily consuming the largest enabled unit at each step (year → month → week → day). A unit is consumed only when the current date is aligned to its start (Jan 1 / 1st of month / `cwday == 1`) **and** the full span fits within `@end_date`; otherwise the algorithm falls through to the next-finer unit. Anything that doesn't align ends up in the `days` array.

**When changing granularity rules**, update both the keyword args on `build_breakdown` and the corresponding endless-method wrapper — keep the four public methods as one-liners so the eligibility matrix stays readable at a glance.

**Return shape:** All four methods return the same hash `{ years: [], months: [], weeks: [], days: [] }` — higher-granularity methods simply leave the coarser arrays empty. Each entry includes `:start_date` and `:end_date` plus unit-specific keys: years have `:year`; months have `:month` + `:year`; weeks have `:week` (value is `Date#cweek`), `:month`, `:year`; days have `:day` (value is `Date#yday`), `:month_day` (value is `Date#mday`), `:month`, `:year`.

**Dependencies:** Zero runtime dependencies — uses only stdlib `require 'date'`. Don't add gems to the runtime gemspec without a strong reason.

## Constraints

Firm rules. Do not work around them without explicit instruction.

- **Never change the return shape silently.** If adding a new key, confirm with the user first and update all four methods to include it — the hash must always be consistent across every method.
- **Never modify the `VERSION` constant in `lib/date_breakup.rb`** unless explicitly asked to cut a release. Bumping the version publishes to RubyGems via `rake release`.
- **Never monkey-patch core classes** (Date, Time, Integer, etc.).

## Input Handling

When working on input handling:

- Do not add support for new input types without discussion.
- Do not rescue input errors silently — invalid input should raise `ArgumentError` with a clear message, as it does today.
- Do not add nil handling — `nil` input should raise, not return an empty result.
- Be especially careful with end-of-month edge cases (e.g. Jan 31 → Feb 28) and leap year boundaries — these are the most likely sources of subtle breakage.
- String inputs are parsed via `Date.parse`, so ambiguous formats (e.g. `01/02/2019`) follow `Date.parse` interpretation rules — this has historically tripped up users. Don't change the parser without flagging it; if you tighten parsing, document the new accepted formats.

## Testing

**Always write or update RSpec tests when modifying `lib` folder.** A change is not complete until tests pass.

- Every public method must have tests for its return shape and edge cases.
- When fixing a bug, add a regression test that would have caught it before writing the fix.
- When adding behaviour, add a test for the happy path and at least one edge case (e.g. same-day range, single-day range, leap year boundaries).
- Do not add new test helpers or shared contexts — keep specs flat and explicit using `describe`/`context`/`it` blocks.
- Tests live in `spec/*`. Currently a single `spec/date_breakup_spec.rb` covers the whole gem — there is no per-method file split convention to preserve.

## RuboCop

When RuboCop reports offenses after an edit:

- Fix them properly by refactoring the code (extract methods, simplify logic, reduce complexity).
- Never silence offenses with `rubocop:disable` or `rubocop:enable` inline comments. These are not acceptable under any circumstances.
- If a violation genuinely cannot be fixed without breaking the design (e.g. a method must be long because the algorithm requires it), update `.rubocop.yml` to relax that specific cop with a comment explaining why.
- Always prefer the refactor. Only fall back to `.rubocop.yml` if you've exhausted conventional fixes and can articulate why.
