require "date_breakup/version"
require "time_difference"

module DateBreakup
  class Range
    private_class_method :new

    def self.between(date1, date2)
      new(Date.parse(date1), Date.parse(date2))
    end

    def get_accurate
      year_array, month_array, week_array, day_array = get_date_array(@date1, @date2, year_array=[], month_array=[], week_array=[], day_array=[])

      output = { years: year_array, months: month_array, weeks: week_array, days: day_array }
    end

    private

    def initialize(date1, date2)
      @date1 = date1
      @date2 = date2
    end

    def get_date_array(date, end_date, year_array, month_array, week_array, day_array)
      move_to_date = true
      # YEAR
      if move_to_date
        if date.beginning_of_year == date
          if date.end_of_year <= @date2
            year_hash = { year: date.year, start_date: date, end_date: date.end_of_year }
            year_array << year_hash
            new_date = date.end_of_year + 1.day
            move_to_date = false
          end
        end
      end

      # MONTH
      if move_to_date
        if date.beginning_of_month == date
          if date.end_of_month <= @date2
            month_hash = { month: date.month, year: date.year, start_date: date, end_date: date.end_of_month }
            month_array << month_hash
            new_date = date.end_of_month + 1.day
            move_to_date = false
          end
        end
      end

      # Week
      if move_to_date
        if date.beginning_of_week == date
          if (date.end_of_week <= @date2) && (date.beginning_of_week.month == date.end_of_week.month)
            week_hash = { week: date.cweek, month: date.month, year: date.year, start_date: date, end_date: date.end_of_week }
            week_array << week_hash
            new_date = date.end_of_week + 1.day
            move_to_date = false
          elsif (date.end_of_week.end_of_month >= @date2) && (date.end_of_week < @date2)
            week_hash = { week: date.cweek, month: date.month, year: date.year, start_date: date, end_date: date.end_of_week }
            week_array << week_hash
            new_date = date.end_of_week + 1.day
            move_to_date = false
          end
        end
      end

      # DAY
      if move_to_date
        day_hash = { day: date.yday, month_day: date.mday, month: date.month, year: date.year, start_date: date, end_date: date }
        day_array << day_hash
        new_date = date + 1.day
      end

      if new_date <= @date2
        get_date_array(new_date, end_date, year_array, month_array, week_array, day_array)
      else
        return year_array, month_array, week_array, day_array
      end
    end
  end
end
