# frozen_string_literal: true

require 'date'

class DateBreakup
  VERSION = '3.1.0'

  def self.between(start_date, end_date)
    new(coerce_to_date(start_date), coerce_to_date(end_date))
  end

  def initialize(start_date, end_date)
    raise ArgumentError, 'start_date must be before or equal to end_date' if start_date > end_date

    @start_date = start_date
    @end_date   = end_date
  end

  def in_years  = build_breakdown(years: true,  months: true,  weeks: true)
  def in_months = build_breakdown(years: false, months: true,  weeks: true)
  def in_weeks  = build_breakdown(years: false, months: false, weeks: true)
  def in_days   = build_breakdown(years: false, months: false, weeks: false)

  private_class_method def self.coerce_to_date(value)
    case value
    when Date   then value
    when Time   then value.to_date
    when String then Date.parse(value)
    else raise ArgumentError, "expected a Date, Time, or String, got #{value.class}"
    end
  end

  private

  def build_breakdown(years: false, months: false, weeks: false)
    y = []
    m = []
    w = []
    d = []
    date = @start_date

    while date <= @end_date
      year_end   = Date.new(date.year, 12, 31)
      month_end  = Date.new(date.year, date.month, -1)
      week_start = date - (date.cwday - 1)
      week_end   = date + (7 - date.cwday)

      if years && date == Date.new(date.year, 1, 1) && @end_date >= year_end
        y << { year: date.year, start_date: date, end_date: year_end }
        date = year_end + 1
      elsif months && date == Date.new(date.year, date.month, 1) && @end_date >= month_end
        m << { month: date.month, year: date.year, start_date: date, end_date: month_end }
        date = month_end + 1
      elsif weeks && date == week_start && @end_date >= week_end
        w << { week: date.cweek, month: date.month, year: date.year, start_date: date, end_date: week_end }
        date = week_end + 1
      else
        d << { day: date.yday, month_day: date.mday, month: date.month, year: date.year,
               start_date: date, end_date: date }
        date += 1
      end
    end

    { years: y, months: m, weeks: w, days: d }
  end
end
