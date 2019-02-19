require "date_breakup/version"
require "time_difference"

module DateBreakup
  class Range
    private_class_method :new

    def self.between(date1, date2)
      new(Date.parse(date1), Date.parse(date2))
    end

    def get_years
      get_year_array(@date1, @date2)

      output = { years: @year_array, months: @month_array, weeks: @week_array, days: @day_array }
    end

    def get_months
      get_month_array(@date1, @date2)

      output = { years: @year_array, months: @month_array, weeks: @week_array, days: @day_array }
    end

    def get_weeks
      get_week_array(@date1, @date2)

      output = { years: @year_array, months: @month_array, weeks: @week_array, days: @day_array }
    end

    def get_days
      get_day_array(@date1, @date2)

      output = { years: @year_array, months: @month_array, weeks: @week_array, days: @day_array }
    end

    private

    def initialize(date1, date2)
      @date1 = date1
      @date2 = date2
      @year_array = Array.new
      @month_array = Array.new
      @week_array = Array.new
      @day_array = Array.new
    end

    def get_year_array(date, end_date)
      move_to_date = true
      # YEAR
      if move_to_date
        if date.beginning_of_year == date
          if date.end_of_year <= @date2
            date, move_to_date = get_year_data(date)
          end
        end
      end

      # MONTH
      if move_to_date
        if date.beginning_of_month == date
          if date.end_of_month <= @date2
            date, move_to_date = get_month_data(date)
          end
        end
      end

      # Week
      if move_to_date
        if date.beginning_of_week == date && date.end_of_week <= @date2
          if date.beginning_of_week.month == date.end_of_week.month || date.end_of_week.end_of_month >= @date2
            date, move_to_date = get_week_data(date)
          end
        end
      end

      # DAY
      if move_to_date
        date, move_to_date = get_date_data(date)
      end

      if date <= end_date
        get_year_array(date, end_date)
      end
    end

    def get_month_array(date, end_date)
      move_to_date = true
      # MONTH
      if move_to_date
        if date.beginning_of_month == date
          if date.end_of_month <= @date2
            date, move_to_date = get_month_data(date)
          end
        end
      end

      # Week
      if move_to_date
        if date.beginning_of_week == date && date.end_of_week <= @date2
          if date.beginning_of_week.month == date.end_of_week.month || date.end_of_week.end_of_month >= @date2
            date, move_to_date = get_week_data(date)
          end
        end
      end

      # DAY
      if move_to_date
        date, move_to_date = get_date_data(date)
      end

      if date <= end_date
        get_month_array(date, end_date)
      end
    end

    def get_week_array(date, end_date)
      move_to_date = true
      # Week
      if move_to_date
        if date.beginning_of_week == date && date.end_of_week <= @date2
          date, move_to_date = get_week_data(date)
        end
      end

      # DAY
      if move_to_date
        date, move_to_date = get_date_data(date)
      end

      if date <= end_date
        get_week_array(date, end_date)
      end
    end

    def get_day_array(date, end_date)
      move_to_date = true
      # DAY
      if move_to_date
        date, move_to_date = get_date_data(date)
      end

      if date <= end_date
        get_day_array(date, end_date)
      end
    end

    def get_year_data(date)
      year_hash = { year: date.year, start_date: date, end_date: date.end_of_year }
      @year_array << year_hash
      new_date = date.end_of_year + 1.day
      move_to_date = false

      return new_date, move_to_date
    end

    def get_month_data(date)
      month_hash = { month: date.month, year: date.year, start_date: date, end_date: date.end_of_month }
      @month_array << month_hash
      new_date = date.end_of_month + 1.day
      move_to_date = false

      return new_date, move_to_date
    end

    def get_week_data(date)
      week_hash = { week: date.cweek, month: date.month, year: date.year, start_date: date, end_date: date.end_of_week }
      @week_array << week_hash
      new_date = date.end_of_week + 1.day
      move_to_date = false

      return new_date, move_to_date
    end

    def get_date_data(date)
      day_hash = { day: date.yday, month_day: date.mday, month: date.month, year: date.year, start_date: date, end_date: date }
      @day_array << day_hash
      new_date = date + 1.day
      move_to_date = false

      return new_date, move_to_date
    end
  end
end
