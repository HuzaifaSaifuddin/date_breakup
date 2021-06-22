# frozen_string_literal: true

require 'rubygems'
require 'time_difference'

class DateBreakup
  VERSION = '3.0.1'

  def self.between(start_date, end_date)
    new(Date.parse(start_date), Date.parse(end_date))
  end

  def initialize(start_date, end_date)
    @start_date = start_date
    @end_date = end_date

    @years = []
    @months = []
    @weeks = []
    @days = []
  end

  # Methods
  # in_years, in_months, in_weeks, in_days
  %w[years months weeks days].each do |method|
    define_method "in_#{method}" do
      date = @start_date
      while date <= @end_date
        if ['years'].include?(method) && date.beginning_of_year == date && @end_date >= date.end_of_year
          @years << { year: date.year, start_date: date, end_date: date.end_of_year }
          date = date.end_of_year + 1.day
        elsif ['years', 'months'].include?(method) && date.beginning_of_month == date && @end_date >= date.end_of_month
          @months << { month: date.month, year: date.year, start_date: date, end_date: date.end_of_month }
          date = date.end_of_month + 1.day
        elsif ['years', 'months', 'weeks'].include?(method) && date.beginning_of_week == date && @end_date >= date.end_of_week
          @weeks << { week: date.cweek, month: date.month, year: date.year, start_date: date,
                      end_date: date.end_of_week }
          date = date.end_of_week + 1.day
        else
          @days << { day: date.yday, month_day: date.mday, month: date.month, year: date.year, start_date: date,
                     end_date: date }
          date += 1.day
        end
      end

      { years: @years, months: @months, weeks: @weeks, days: @days }
    end
  end
end
