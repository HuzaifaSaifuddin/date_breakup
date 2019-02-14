require "date_breakup/version"
require "time_difference"

module DateBreakup
  class Range
    private_class_method :new

    def self.between(date1, date2)
      new(Date.parse(date1), Date.parse(date2))
    end

    def get_accurate
      years, remaining_dates_year = get_years(@date1, @date2)

      months, remaining_dates_month = get_months(remaining_dates_year)

      weeks, remaining_dates_week = get_weeks(remaining_dates_month)

      days, remaining_dates_days = get_days(remaining_dates_week)

      output = { years: years, months: months, weeks: weeks, days: days }
    end

    private

    def initialize(date1, date2)
      @date1 = date1
      @date2 = date2
    end

    def get_years(date1, date2)
      year_array = []
      remaining_dates = []

      if date1.beginning_of_year == date1 && date1.end_of_year <= date2
        year_hash = { year: date1.year, start_date: date1.beginning_of_year, end_date: date1.end_of_year }
        year_array << year_hash
      end

      get_year_range(date1, date2, year_array, year_hash)

      if year_array.count > 0
        if(date1 != year_array[0][:start_date])
          remaining_dates_hash = { date1: date1, date2: year_array[0][:start_date] - 1 }
          remaining_dates << remaining_dates_hash
        end

        if(date2 != year_array[-1][:end_date])
          remaining_dates_hash = { date1: year_array[-1][:end_date] + 1, date2: date2 }
          remaining_dates << remaining_dates_hash
        end
      else
        remaining_dates << { date1: date1, date2: date2 }
      end

      return year_array, remaining_dates
    end

    def get_months(remaining_dates_year)
      month_array = []
      remaining_dates = []

      remaining_dates_year.each do |rd|
        date1, date2 = rd[:date1], rd[:date2]
        if date1.beginning_of_month == date1 && date1.end_of_month <= date2
          month_hash = { month: date1.month, year: date1.year, start_date: date1.beginning_of_month, end_date: date1.end_of_month }
          month_array << month_hash
        end

        get_month_range(date1, date2, month_array, month_hash)
      end


      if month_array.count > 0
        month_arrx1 = month_array.sort_by{ |ma| ma[:start_date] }.select{ |wa| wa[:year] == remaining_dates_year[0][:date1].year }.first

        if month_arrx1
          if(remaining_dates_year[0][:date1] != month_arrx1[:start_date])
            remaining_dates_hash = { date1: remaining_dates_year[0][:date1], date2: month_arrx1[:start_date] - 1 }
            remaining_dates << remaining_dates_hash
          end
        else
          remaining_dates_hash = { date1: remaining_dates_year[0][:date1], date2: remaining_dates_year[0][:date2] }
          remaining_dates << remaining_dates_hash
        end

        month_arrx2 = month_array.sort_by{ |ma| ma[:start_date] }.select{ |wa| wa[:year] == remaining_dates_year[-1][:date2].year }.last
        if month_arrx2
          if(remaining_dates_year[-1][:date2] != month_arrx2[:end_date])
            remaining_dates_hash = { date1: month_arrx2[:end_date] + 1, date2: remaining_dates_year[-1][:date2] }
            remaining_dates << remaining_dates_hash
          end
        else
          remaining_dates_hash = { date1: remaining_dates_year[-1][:date1], date2: remaining_dates_year[-1][:date2] }
          remaining_dates << remaining_dates_hash
        end
      else
        remaining_dates = remaining_dates_year
      end

      return month_array, remaining_dates
    end

    def get_weeks(remaining_dates_month)
      week_array = []
      remaining_dates = []

      remaining_dates_month.each do |rd|
        date1, date2 = rd[:date1], rd[:date2]
        if date1.beginning_of_week == date1 && date1.end_of_week <= date2
          week_hash = { week: date1.cweek, month: date1.month, year: date1.year, start_date: date1.beginning_of_week, end_date: date1.end_of_week }
          week_array << week_hash
        end

        get_week_range(date1, date2, week_array, week_hash)
      end

      if week_array.count > 0
        week_arrx1 = week_array.sort_by{ |ma| ma[:start_date] }.select{ |wa| wa[:month] == remaining_dates_month[0][:date1].month }.first
        if week_arrx1
          if(remaining_dates_month[0][:date1] != week_arrx1[:start_date])
            remaining_dates_hash = { date1: remaining_dates_month[0][:date1], date2: week_arrx1[:start_date] - 1 }
            remaining_dates << remaining_dates_hash
          end
        end

        week_arrx2 = week_array.sort_by{ |ma| ma[:start_date] }.select{ |wa| wa[:month] == remaining_dates_month[0][:date2].month }.last
        if week_arrx2
          if(remaining_dates_month[0][:date2] != week_arrx2[:end_date])
            remaining_dates_hash = { date1: week_arrx2[:end_date] + 1, date2: remaining_dates_month[0][:date2] }
            remaining_dates << remaining_dates_hash
          end
        end

        week_arrx3 = week_array.sort_by{ |ma| ma[:start_date] }.select{ |wa| wa[:month] == remaining_dates_month[-1][:date1].month }.first
        if week_arrx3
          if(remaining_dates_month[0][:date1] != week_arrx3[:end_date])
            remaining_dates_hash = { date1: remaining_dates_month[-1][:date1], date2: week_arrx3[:start_date] - 1 }
            remaining_dates << remaining_dates_hash
          end
        end

        week_arrx4 = week_array.sort_by{ |ma| ma[:start_date] }.select{ |wa| wa[:month] == remaining_dates_month[-1][:date1].month }.last
        if week_arrx4
          if(remaining_dates_month[-1][:date2] != week_arrx4[:end_date])
            remaining_dates_hash = { date1: week_arrx4[:end_date] + 1, date2: remaining_dates_month[-1][:date2] }
            remaining_dates << remaining_dates_hash
          end
        end
      else
        remaining_dates = remaining_dates_month
      end

      return week_array, remaining_dates
    end

    def get_days(remaining_dates_week)
      day_array = []
      remaining_dates = []

      remaining_dates_week.each do |rd|
        date1, date2 = rd[:date1], rd[:date2]
        dates = (date1).upto(date2).to_a

        dates.each do |date|
          unless day_array.find{ |da| da[:start_date] == date }.present?
            day_hash = { day: date.yday, month_day: date.mday, month: date.month, year: date.year, start_date: date, end_date: date }
            day_array << day_hash
          end
        end
      end

      return day_array, remaining_dates
    end

    def get_year_range(date1, date2, year_array, year_hash)
      next_year = (date1.end_of_year + 1.day)
      end_next_year = next_year.end_of_year
      if end_next_year <= date2
        year = end_next_year.year
        start_date = next_year.beginning_of_year
        end_date = end_next_year
        year_hash = { year: year, start_date: start_date, end_date: end_date }
        year_array << year_hash
        get_year_range(next_year, date2, year_array, year_hash)
      end
    end

    def get_month_range(date1, date2, month_array, month_hash)
      next_month = (date1.end_of_month + 1.day)
      end_next_month = next_month.end_of_month
      if end_next_month <= date2
        month = end_next_month.month
        start_date = next_month.beginning_of_month
        end_date = end_next_month
        month_hash = { month: month, year: end_next_month.year, start_date: start_date, end_date: end_date }
        month_array << month_hash
        get_month_range(next_month, date2, month_array, month_hash)
      end
    end

    def get_week_range(date1, date2, week_array, week_hash)
      next_week = (date1.end_of_week + 1.day)
      end_next_week = next_week.end_of_week
      if end_next_week <= date2
        week = end_next_week.cweek
        start_date = next_week.beginning_of_week
        end_date = end_next_week
        week_hash = { week: week, month: end_next_week.month, year: end_next_week.year, start_date: start_date, end_date: end_date }
        week_array << week_hash
        get_week_range(next_week, date2, week_array, week_hash)
      end
    end
  end
end
