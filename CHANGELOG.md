# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.1.0] - 2026-05-10

### Added
- `.between` now accepts `Date` and `Time` objects in addition to date strings.
- `ArgumentError` raised when `start_date` is after `end_date` (previously returned silently empty results).
- GitHub Actions CI replacing Travis CI.
- `.mise.toml` to pin Ruby version for consistent local development.
- RuboCop added as a development dependency with a project `.rubocop.yml`.

### Changed
- Replaced `define_method` metaprogramming loop with four explicit public methods (`in_years`, `in_months`, `in_weeks`, `in_days`) backed by a shared private `build_breakdown` method. No change to public API behaviour.
- All result arrays are now method-local variables — calling any `in_*` method twice on the same instance no longer returns duplicated data.
- `frozen_string_literal: true` added to all Ruby files.
- Bundler constraint relaxed from `~> 2.2` to `~> 2.0`.

### Removed
- Runtime dependency on `time_difference` and implicit dependency on ActiveSupport — replaced with pure stdlib `Date` arithmetic. The gem now has zero runtime dependencies.

### Fixed
- `bundle install` previously failed because `time_difference` was required in `lib/date_breakup.rb` but never declared as a dependency.

## [3.0.1] - 2021-10-01

### Changed
- Dependency bump: `date` gem updated to `3.2.1`.

## [3.0.0] - 2021-09-01

### Changed
- Class renamed from `DateBreakup::Range` to `DateBreakup`.
- Methods renamed: `get_years` → `in_years`, `get_months` → `in_months`, `get_weeks` → `in_weeks`, `get_days` → `in_days`.
- Internal code generation made dynamic via `define_method`.

## [1.0.0] - 2019-01-01

### Added
- Initial release. `DateBreakup::Range.between` with `get_years`, `get_months`, `get_weeks`, `get_days`.
