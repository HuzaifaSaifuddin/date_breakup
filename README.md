# DateBreakup

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'date_breakup'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install date_breakup

## Usage

### Pass in 2 Date(String) & get a breakup of dates in years, months, weeks & days

#### FOR YEARS (BREAKUP in YEARS, MONTHS, WEEKS, DAYS)
```ruby
DateBreakup::Range.between('01/01/2019', '31/12/2019').get_years
=> {
    :years=>[
      {:year=>2019, :start_date=>Sat, 01 Jan 2019, :end_date=>Sat, 31 Dec 2019}
    ],
    :months=>[],
    :weeks=>[],
    :days=>[]
  }
```

#### FOR MONTHS (BREAKUP in MONTHS, WEEKS, DAYS)
```ruby
DateBreakup::Range.between('01/01/2019', '31/12/2019').get_months
=> {
    :years=>[],
    :months=>[
      {:month=>1, :year=>2019, :start_date=>Tue, 01 Jan 2019, :end_date=>Thu, 31 Jan 2019},
      {:month=>2, :year=>2019, :start_date=>Fri, 01 Feb 2019, :end_date=>Thu, 28 Feb 2019},
      {:month=>3, :year=>2019, :start_date=>Fri, 01 Mar 2019, :end_date=>Sun, 31 Mar 2019},
      {:month=>4, :year=>2019, :start_date=>Mon, 01 Apr 2019, :end_date=>Tue, 30 Apr 2019},
      {:month=>5, :year=>2019, :start_date=>Wed, 01 May 2019, :end_date=>Fri, 31 May 2019},
      {:month=>6, :year=>2019, :start_date=>Sat, 01 Jun 2019, :end_date=>Sun, 30 Jun 2019},
      {:month=>7, :year=>2019, :start_date=>Mon, 01 Jul 2019, :end_date=>Wed, 31 Jul 2019},
      {:month=>8, :year=>2019, :start_date=>Thu, 01 Aug 2019, :end_date=>Sat, 31 Aug 2019},
      {:month=>9, :year=>2019, :start_date=>Sun, 01 Sep 2019, :end_date=>Mon, 30 Sep 2019},
      {:month=>10, :year=>2019, :start_date=>Tue, 01 Oct 2019, :end_date=>Thu, 31 Oct 2019},
      {:month=>11, :year=>2019, :start_date=>Fri, 01 Nov 2019, :end_date=>Sat, 30 Nov 2019},
      {:month=>12, :year=>2019, :start_date=>Sun, 01 Dec 2019, :end_date=>Tue, 31 Dec 2019}
    ],
    :weeks=>[],
    :days=>[]
  }
```
#### FOR WEEKS (BREAKUP in WEEKS, DAYS)
```ruby
DateBreakup::Range.between('01/01/2019', '31/12/2019').get_weeks
=> {
    :years=>[],
    :months=>[],
    :weeks=>[
      {:week=>2, :month=>1, :year=>2019, :start_date=>Mon, 07 Jan 2019, :end_date=>Sun, 13 Jan 2019},
      {:week=>3, :month=>1, :year=>2019, :start_date=>Mon, 14 Jan 2019, :end_date=>Sun, 20 Jan 2019},
      {:week=>4, :month=>1, :year=>2019, :start_date=>Mon, 21 Jan 2019, :end_date=>Sun, 27 Jan 2019},
      {:week=>5, :month=>1, :year=>2019, :start_date=>Mon, 28 Jan 2019, :end_date=>Sun, 03 Feb 2019},
      {:week=>6, :month=>2, :year=>2019, :start_date=>Mon, 04 Feb 2019, :end_date=>Sun, 10 Feb 2019},
      {:week=>7, :month=>2, :year=>2019, :start_date=>Mon, 11 Feb 2019, :end_date=>Sun, 17 Feb 2019},
      {:week=>8, :month=>2, :year=>2019, :start_date=>Mon, 18 Feb 2019, :end_date=>Sun, 24 Feb 2019},
      {:week=>9, :month=>2, :year=>2019, :start_date=>Mon, 25 Feb 2019, :end_date=>Sun, 03 Mar 2019},
      {:week=>10, :month=>3, :year=>2019, :start_date=>Mon, 04 Mar 2019, :end_date=>Sun, 10 Mar 2019},
      ...
      {:week=>43, :month=>10, :year=>2019, :start_date=>Mon, 21 Oct 2019, :end_date=>Sun, 27 Oct 2019},
      {:week=>44, :month=>10, :year=>2019, :start_date=>Mon, 28 Oct 2019, :end_date=>Sun, 03 Nov 2019},
      {:week=>45, :month=>11, :year=>2019, :start_date=>Mon, 04 Nov 2019, :end_date=>Sun, 10 Nov 2019},
      {:week=>46, :month=>11, :year=>2019, :start_date=>Mon, 11 Nov 2019, :end_date=>Sun, 17 Nov 2019},
      {:week=>47, :month=>11, :year=>2019, :start_date=>Mon, 18 Nov 2019, :end_date=>Sun, 24 Nov 2019},
      {:week=>48, :month=>11, :year=>2019, :start_date=>Mon, 25 Nov 2019, :end_date=>Sun, 01 Dec 2019},
      {:week=>49, :month=>12, :year=>2019, :start_date=>Mon, 02 Dec 2019, :end_date=>Sun, 08 Dec 2019},
      {:week=>50, :month=>12, :year=>2019, :start_date=>Mon, 09 Dec 2019, :end_date=>Sun, 15 Dec 2019},
      {:week=>51, :month=>12, :year=>2019, :start_date=>Mon, 16 Dec 2019, :end_date=>Sun, 22 Dec 2019},
      {:week=>52, :month=>12, :year=>2019, :start_date=>Mon, 23 Dec 2019, :end_date=>Sun, 29 Dec 2019}
    ],
    :days=>[
      {:day=>1, :month_day=>1, :month=>1, :year=>2019, :start_date=>Tue, 01 Jan 2019, :end_date=>Tue, 01 Jan 2019},
      {:day=>2, :month_day=>2, :month=>1, :year=>2019, :start_date=>Wed, 02 Jan 2019, :end_date=>Wed, 02 Jan 2019},
      {:day=>3, :month_day=>3, :month=>1, :year=>2019, :start_date=>Thu, 03 Jan 2019, :end_date=>Thu, 03 Jan 2019},
      {:day=>4, :month_day=>4, :month=>1, :year=>2019, :start_date=>Fri, 04 Jan 2019, :end_date=>Fri, 04 Jan 2019},
      {:day=>5, :month_day=>5, :month=>1, :year=>2019, :start_date=>Sat, 05 Jan 2019, :end_date=>Sat, 05 Jan 2019},
      {:day=>6, :month_day=>6, :month=>1, :year=>2019, :start_date=>Sun, 06 Jan 2019, :end_date=>Sun, 06 Jan 2019},
      {:day=>364, :month_day=>30, :month=>12, :year=>2019, :start_date=>Mon, 30 Dec 2019, :end_date=>Mon, 30 Dec 2019},
      {:day=>365, :month_day=>31, :month=>12, :year=>2019, :start_date=>Tue, 31 Dec 2019, :end_date=>Tue, 31 Dec 2019}
    ]
  }
```
#### FOR DAYS (BREAKUP in DAYS)
```ruby
DateBreakup::Range.between('01/01/2019', '31/12/2019').get_days
=> {
    :years=>[],
    :months=>[],
    :weeks=>[],
    :days=>[
      {:day=>1, :month_day=>1, :month=>1, :year=>2019, :start_date=>Tue, 01 Jan 2019, :end_date=>Tue, 01 Jan 2019},
      {:day=>2, :month_day=>2, :month=>1, :year=>2019, :start_date=>Wed, 02 Jan 2019, :end_date=>Wed, 02 Jan 2019},
      {:day=>3, :month_day=>3, :month=>1, :year=>2019, :start_date=>Thu, 03 Jan 2019, :end_date=>Thu, 03 Jan 2019},
      {:day=>4, :month_day=>4, :month=>1, :year=>2019, :start_date=>Fri, 04 Jan 2019, :end_date=>Fri, 04 Jan 2019},
      {:day=>5, :month_day=>5, :month=>1, :year=>2019, :start_date=>Sat, 05 Jan 2019, :end_date=>Sat, 05 Jan 2019},
      {:day=>6, :month_day=>6, :month=>1, :year=>2019, :start_date=>Sun, 06 Jan 2019, :end_date=>Sun, 06 Jan 2019},
      ...
      {:day=>364, :month_day=>30, :month=>12, :year=>2019, :start_date=>Mon, 30 Dec 2019, :end_date=>Mon, 30 Dec 2019},
      {:day=>365, :month_day=>31, :month=>12, :year=>2019, :start_date=>Tue, 31 Dec 2019, :end_date=>Tue, 31 Dec 2019}
    ]
  }
```

### More Further Apart Dates

```ruby
DateBreakup::Range.between('10/10/2010', '12/12/2012').get_years
=> {
    :years=>[
      {:year=>2011, :start_date=>Sat, 01 Jan 2011, :end_date=>Sat, 31 Dec 2011}
    ],
    :months=>[
      {:month=>11, :year=>2010, :start_date=>Mon, 01 Nov 2010, :end_date=>Tue, 30 Nov 2010},
      {:month=>12, :year=>2010, :start_date=>Wed, 01 Dec 2010, :end_date=>Fri, 31 Dec 2010},
      {:month=>1, :year=>2012, :start_date=>Sun, 01 Jan 2012, :end_date=>Tue, 31 Jan 2012},
      {:month=>2, :year=>2012, :start_date=>Wed, 01 Feb 2012, :end_date=>Wed, 29 Feb 2012},
      {:month=>3, :year=>2012, :start_date=>Thu, 01 Mar 2012, :end_date=>Sat, 31 Mar 2012},
      {:month=>4, :year=>2012, :start_date=>Sun, 01 Apr 2012, :end_date=>Mon, 30 Apr 2012},
      {:month=>5, :year=>2012, :start_date=>Tue, 01 May 2012, :end_date=>Thu, 31 May 2012},
      {:month=>6, :year=>2012, :start_date=>Fri, 01 Jun 2012, :end_date=>Sat, 30 Jun 2012},
      {:month=>7, :year=>2012, :start_date=>Sun, 01 Jul 2012, :end_date=>Tue, 31 Jul 2012},
      {:month=>8, :year=>2012, :start_date=>Wed, 01 Aug 2012, :end_date=>Fri, 31 Aug 2012},
      {:month=>9, :year=>2012, :start_date=>Sat, 01 Sep 2012, :end_date=>Sun, 30 Sep 2012},
      {:month=>10, :year=>2012, :start_date=>Mon, 01 Oct 2012, :end_date=>Wed, 31 Oct 2012},
      {:month=>11, :year=>2012, :start_date=>Thu, 01 Nov 2012, :end_date=>Fri, 30 Nov 2012}],
    :weeks=>[
      {:week=>41, :month=>10, :year=>2010, :start_date=>Mon, 11 Oct 2010, :end_date=>Sun, 17 Oct 2010},
      {:week=>42, :month=>10, :year=>2010, :start_date=>Mon, 18 Oct 2010, :end_date=>Sun, 24 Oct 2010},
      {:week=>43, :month=>10, :year=>2010, :start_date=>Mon, 25 Oct 2010, :end_date=>Sun, 31 Oct 2010},
      {:week=>49, :month=>12, :year=>2012, :start_date=>Mon, 03 Dec 2012, :end_date=>Sun, 09 Dec 2012}],
    :days=>[
      {:day=>283, :month_day=>10, :month=>10, :year=>2010, :start_date=>Sun, 10 Oct 2010, :end_date=>Sun, 10 Oct 2010},
      {:day=>336, :month_day=>1, :month=>12, :year=>2012, :start_date=>Sat, 01 Dec 2012, :end_date=>Sat, 01 Dec 2012},
      {:day=>337, :month_day=>2, :month=>12, :year=>2012, :start_date=>Sun, 02 Dec 2012, :end_date=>Sun, 02 Dec 2012},
      {:day=>345, :month_day=>10, :month=>12, :year=>2012, :start_date=>Mon, 10 Dec 2012, :end_date=>Mon, 10 Dec 2012},
      {:day=>346, :month_day=>11, :month=>12, :year=>2012, :start_date=>Tue, 11 Dec 2012, :end_date=>Tue, 11 Dec 2012},
      {:day=>347, :month_day=>12, :month=>12, :year=>2012, :start_date=>Wed, 12 Dec 2012, :end_date=>Wed, 12 Dec 2012}
    ]
  }
```

<!-- ## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/date_breakup. -->

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
