# frozen_string_literal: true

RSpec.describe DateBreakup do
  it 'has a version number' do
    expect(DateBreakup::VERSION).not_to be_nil
  end

  describe '.between' do
    it 'accepts date strings' do
      expect(DateBreakup.between('01/01/2019', '31/12/2019')).to be_a(DateBreakup)
    end

    it 'accepts Date objects' do
      expect(DateBreakup.between(Date.new(2019, 1, 1), Date.new(2019, 12, 31))).to be_a(DateBreakup)
    end

    it 'accepts Time objects' do
      expect(DateBreakup.between(Time.new(2019, 1, 1), Time.new(2019, 12, 31))).to be_a(DateBreakup)
    end

    it 'raises ArgumentError for unsupported input types' do
      expect { DateBreakup.between(2019, 2020) }.to raise_error(ArgumentError, /Integer/)
    end

    it 'raises ArgumentError when start_date is after end_date' do
      expect { DateBreakup.between('31/12/2019', '01/01/2019') }.to raise_error(ArgumentError, /start_date/)
    end
  end

  describe '#in_years' do
    it 'returns a full calendar year as a single year entry' do
      result = DateBreakup.between('01/01/2019', '31/12/2019').in_years
      expect(result[:years]).to eq([{ year: 2019, start_date: Date.new(2019, 1, 1), end_date: Date.new(2019, 12, 31) }])
      expect(result[:months]).to be_empty
      expect(result[:weeks]).to be_empty
      expect(result[:days]).to be_empty
    end

    it 'breaks a multi-year range into years, leftover months, weeks, and days' do
      result = DateBreakup.between('10/10/2010', '12/12/2012').in_years
      expect(result[:years].map { |y| y[:year] }).to eq([2011])
      expect(result[:months].map { |m| [m[:month], m[:year]] }).to include([11, 2010], [12, 2010])
      expect(result[:days].map { |d| d[:start_date] }).to include(Date.new(2010, 10, 10))
    end

    it 'is idempotent — calling twice returns the same result' do
      db = DateBreakup.between('01/01/2019', '31/12/2019')
      expect(db.in_years).to eq(db.in_years)
    end
  end

  describe '#in_months' do
    it 'returns 12 month entries for a full calendar year' do
      result = DateBreakup.between('01/01/2019', '31/12/2019').in_months
      expect(result[:years]).to be_empty
      expect(result[:months].length).to eq(12)
      expect(result[:months].first).to eq({ month: 1, year: 2019, start_date: Date.new(2019, 1, 1), end_date: Date.new(2019, 1, 31) })
      expect(result[:months].last).to  eq({ month: 12, year: 2019, start_date: Date.new(2019, 12, 1), end_date: Date.new(2019, 12, 31) })
      expect(result[:weeks]).to be_empty
      expect(result[:days]).to be_empty
    end

    it 'is idempotent — calling twice returns the same result' do
      db = DateBreakup.between('01/01/2019', '31/12/2019')
      expect(db.in_months).to eq(db.in_months)
    end
  end

  describe '#in_weeks' do
    it 'returns a single week entry for a clean Mon–Sun range' do
      # 2019-01-07 is a Monday, 2019-01-13 is a Sunday
      result = DateBreakup.between('07/01/2019', '13/01/2019').in_weeks
      expect(result[:years]).to be_empty
      expect(result[:months]).to be_empty
      expect(result[:weeks].length).to eq(1)
      expect(result[:weeks].first[:week]).to eq(2)
      expect(result[:weeks].first[:start_date]).to eq(Date.new(2019, 1, 7))
      expect(result[:weeks].first[:end_date]).to eq(Date.new(2019, 1, 13))
      expect(result[:days]).to be_empty
    end

    it 'falls back to days for a partial week' do
      # 2019-01-09 is Wednesday, 2019-01-11 is Friday
      result = DateBreakup.between('09/01/2019', '11/01/2019').in_weeks
      expect(result[:weeks]).to be_empty
      expect(result[:days].length).to eq(3)
    end

    it 'is idempotent — calling twice returns the same result' do
      db = DateBreakup.between('07/01/2019', '13/01/2019')
      expect(db.in_weeks).to eq(db.in_weeks)
    end
  end

  describe '#in_days' do
    it 'returns one entry per day for a 3-day range' do
      result = DateBreakup.between('01/01/2019', '03/01/2019').in_days
      expect(result[:years]).to be_empty
      expect(result[:months]).to be_empty
      expect(result[:weeks]).to be_empty
      expect(result[:days].length).to eq(3)
      expect(result[:days][0]).to eq({ day: 1, month_day: 1, month: 1, year: 2019, start_date: Date.new(2019, 1, 1), end_date: Date.new(2019, 1, 1) })
      expect(result[:days][2]).to eq({ day: 3, month_day: 3, month: 1, year: 2019, start_date: Date.new(2019, 1, 3), end_date: Date.new(2019, 1, 3) })
    end

    it 'returns a single entry for a same-day range' do
      result = DateBreakup.between('15/06/2019', '15/06/2019').in_days
      expect(result[:days].length).to eq(1)
      expect(result[:days].first[:month_day]).to eq(15)
    end

    it 'is idempotent — calling twice returns the same result' do
      db = DateBreakup.between('01/01/2019', '03/01/2019')
      expect(db.in_days).to eq(db.in_days)
    end
  end
end
