# DateBreakup

Pass two dates and get a breakdown of the range grouped into years, months, weeks, and days. Accepts `Date`, `Time`, or date strings.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'date_breakup'
```

Then run:

```sh
bundle install
```

Or install directly:

```sh
gem install date_breakup
```

## Usage

All four methods return the same hash shape — `{ years:, months:, weeks:, days: }` — with coarser arrays left empty depending on the method used.

`.between` accepts `Date`, `Time`, or a date string:

```ruby
DateBreakup.between(Date.new(2019, 1, 1), Date.new(2019, 12, 31))
DateBreakup.between(Time.new(2019, 1, 1), Time.new(2019, 12, 31))
DateBreakup.between('01/01/2019', '31/12/2019')
```

Passing a start date after the end date raises `ArgumentError`.

### `in_years` — greedy breakdown from years down

```ruby
DateBreakup.between('01/01/2019', '31/12/2019').in_years
# => {
#   years:  [{ year: 2019, start_date: Sat 01 Jan 2019, end_date: Sat 31 Dec 2019 }],
#   months: [],
#   weeks:  [],
#   days:   []
# }
```

For a range that doesn't align to full years, the remainder falls through to months, weeks, and days:

```ruby
DateBreakup.between('10/10/2010', '12/12/2012').in_years
# => {
#   years:  [{ year: 2011, start_date: Sat 01 Jan 2011, end_date: Sat 31 Dec 2011 }],
#   months: [
#     { month: 11, year: 2010, start_date: Mon 01 Nov 2010, end_date: Tue 30 Nov 2010 },
#     { month: 12, year: 2010, start_date: Wed 01 Dec 2010, end_date: Fri 31 Dec 2010 },
#     ...
#   ],
#   weeks:  [{ week: 41, month: 10, year: 2010, start_date: Mon 11 Oct 2010, end_date: Sun 17 Oct 2010 }, ...],
#   days:   [{ day: 283, month_day: 10, month: 10, year: 2010, start_date: Sun 10 Oct 2010, end_date: Sun 10 Oct 2010 }, ...]
# }
```

### `in_months` — greedy breakdown from months down

```ruby
DateBreakup.between('01/01/2019', '31/12/2019').in_months
# => {
#   years:  [],
#   months: [
#     { month: 1,  year: 2019, start_date: Tue 01 Jan 2019, end_date: Thu 31 Jan 2019 },
#     { month: 2,  year: 2019, start_date: Fri 01 Feb 2019, end_date: Thu 28 Feb 2019 },
#     ...
#     { month: 12, year: 2019, start_date: Sun 01 Dec 2019, end_date: Tue 31 Dec 2019 }
#   ],
#   weeks:  [],
#   days:   []
# }
```

### `in_weeks` — greedy breakdown from weeks down

Partial weeks at the start or end of the range fall through to individual days.

```ruby
DateBreakup.between('01/01/2019', '31/12/2019').in_weeks
# => {
#   years:  [],
#   months: [],
#   weeks: [
#     { week: 2, month: 1, year: 2019, start_date: Mon 07 Jan 2019, end_date: Sun 13 Jan 2019 },
#     ...
#     { week: 52, month: 12, year: 2019, start_date: Mon 23 Dec 2019, end_date: Sun 29 Dec 2019 }
#   ],
#   days: [
#     { day: 1, month_day: 1, month: 1, year: 2019, start_date: Tue 01 Jan 2019, end_date: Tue 01 Jan 2019 },
#     ...
#   ]
# }
```

### `in_days` — every day individually

```ruby
DateBreakup.between('01/01/2019', '03/01/2019').in_days
# => {
#   years:  [],
#   months: [],
#   weeks:  [],
#   days: [
#     { day: 1, month_day: 1, month: 1, year: 2019, start_date: Tue 01 Jan 2019, end_date: Tue 01 Jan 2019 },
#     { day: 2, month_day: 2, month: 1, year: 2019, start_date: Wed 02 Jan 2019, end_date: Wed 02 Jan 2019 },
#     { day: 3, month_day: 3, month: 1, year: 2019, start_date: Thu 03 Jan 2019, end_date: Thu 03 Jan 2019 }
#   ]
# }
```

## Development

This project uses [mise](https://mise.jdx.dev) to manage the Ruby version.

```sh
# Install the required Ruby version
mise install

# Install dependencies
bin/setup

# Run tests
bundle exec rspec

# Run a single spec file
bundle exec rspec spec/date_breakup_spec.rb

# Open an interactive console with the gem loaded
bin/console

# Install the gem locally
bundle exec rake install
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/HuzaifaSaifuddin/date_breakup.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
