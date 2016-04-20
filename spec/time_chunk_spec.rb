require 'spec_helper'
require 'time_chunk'

def t(str)
  Time.parse(str)
end

describe TimeChunk do
  before(:each) do
    @calls = []
  end

  describe 'iterate' do
    it 'should iterate a time range by the given step size' do
      TimeChunk.iterate(
        (t('2013-01-01T00:00:00Z')..t('2013-01-01T02:59:59Z')), 3_600
      ) do |range|
        @calls << range
      end

      @calls.should eq [
        (t('2013-01-01T00:00:00Z')..t('2013-01-01T00:59:59Z')),
        (t('2013-01-01T01:00:00Z')..t('2013-01-01T01:59:59Z')),
        (t('2013-01-01T02:00:00Z')..t('2013-01-01T02:59:59Z'))
      ]
    end

    it 'should not exceed given start and end times when step size is larger than given range' do
      TimeChunk.iterate(
        '2013-01-01T00:00:00Z'..'2013-01-01T00:30:00Z', 3_600
      ) do |range|
        @calls << range
      end

      @calls.should eq [
        (t('2013-01-01T00:00:00Z')..t('2013-01-01T00:30:00Z'))
      ]
    end

    it 'should return a final range smaller than step size if begin to end range is not a perfect multiple of step size' do # rubocop:disable LineLength
      TimeChunk.iterate(
        (t('2013-01-01T00:00:00Z')..t('2013-01-01T02:29:59Z')), 3600
      ) do |range|
        @calls << range
      end

      @calls.should eq [
        (t('2013-01-01T00:00:00Z')..t('2013-01-01T00:59:59Z')),
        (t('2013-01-01T01:00:00Z')..t('2013-01-01T01:59:59Z')),
        (t('2013-01-01T02:00:00Z')..t('2013-01-01T02:29:59Z'))
      ]
    end

    it 'should raise an ArgumentError if range\'s begin is larger than its end' do
      err = 'Given range\'s begin (2013-01-05T00:00:00Z) is after its end (2013-01-01T00:00:00Z).'
      expect {
        TimeChunk.iterate(
          (t('2013-01-05T00:00:00Z')..t('2013-01-01T00:00:00Z')), 3_600
        ) do |range|
          @calls << range
        end
      }.to raise_error ArgumentError, err
    end

    it 'should accept a two-element array' do
      TimeChunk.iterate(
        [t('2013-01-01T00:00:00Z'), t('2013-01-01T02:29:59Z')], 3_600
      ) do |range|
        @calls << range
      end

      @calls.should eq [
        (t('2013-01-01T00:00:00Z')..t('2013-01-01T00:59:59Z')),
        (t('2013-01-01T01:00:00Z')..t('2013-01-01T01:59:59Z')),
        (t('2013-01-01T02:00:00Z')..t('2013-01-01T02:29:59Z'))
      ]
    end

    it 'should parse time strings' do
      TimeChunk.iterate(
        '2013-01-01T00:00:00Z'..'2013-01-01T02:59:59Z', 3_600
      ) do |range|
        @calls << range
      end

      @calls.should eq [
        (t('2013-01-01T00:00:00Z')..t('2013-01-01T00:59:59Z')),
        (t('2013-01-01T01:00:00Z')..t('2013-01-01T01:59:59Z')),
        (t('2013-01-01T02:00:00Z')..t('2013-01-01T02:59:59Z'))
      ]
    end

    it 'should handle date arguments' do
      TimeChunk.iterate(
        Date.parse('2013-02-27')..Date.parse('2013-03-05'), 86_400 * 2
      ) do |range|
        @calls << range
      end

      @calls.map(&:to_s).should eq [
        '2013-02-27..2013-02-28',
        '2013-03-01..2013-03-02',
        '2013-03-03..2013-03-04',
        '2013-03-05..2013-03-05'
      ]
    end
  end

  describe 'each_day' do
    it 'should yield time ranges when given string arguments' do
      TimeChunk.each_day('2013-01-01T00:00:00Z'..'2013-01-04T23:59:59Z') do |range|
        @calls << range
      end

      @calls.should eq [
        (t('2013-01-01T00:00:00Z')..t('2013-01-01T23:59:59Z')),
        (t('2013-01-02T00:00:00Z')..t('2013-01-02T23:59:59Z')),
        (t('2013-01-03T00:00:00Z')..t('2013-01-03T23:59:59Z')),
        (t('2013-01-04T00:00:00Z')..t('2013-01-04T23:59:59Z'))
      ]
    end

    it 'should yield date instances when given date range arguments' do
      start = Date.parse('2013-05-15')
      finish = Date.parse('2013-05-20')

      TimeChunk.each_day(start..finish) { |date| @calls << date }

      expected = ['2013-05-15', '2013-05-16', '2013-05-17',
                  '2013-05-18', '2013-05-19', '2013-05-20']
      @calls.map(&:to_s).should eq expected
    end

    it 'should raise an error if the start is after the finish' do
      finish = Date.parse('2013-05-15')
      finish_str = finish.to_time.utc.iso8601
      start = Date.parse('2013-05-20')
      start_str = start.to_time.utc.iso8601
      err = "Given range's begin (#{start_str}) is after its end (#{finish_str})."

      expect {
        TimeChunk.each_day(start..finish) { |date| @calls << date }
      }.to raise_error ArgumentError, err

    end
  end

  describe 'iterate_days' do
    it 'should iterate in chunks of the given number of days' do
      start = Date.parse('2013-05-01')
      finish = Date.parse('2013-05-31')

      TimeChunk.iterate_days(start..finish, 5) do |range|
        @calls << [range.first.to_s, range.last.to_s]
      end

      expected = [
        ['2013-05-01', '2013-05-05'],
        ['2013-05-06', '2013-05-10'],
        ['2013-05-11', '2013-05-15'],
        ['2013-05-16', '2013-05-20'],
        ['2013-05-21', '2013-05-25'],
        ['2013-05-26', '2013-05-30'],
        ['2013-05-31', '2013-05-31']
      ]
      @calls.should eq expected
    end
  end

  it 'should iterate over each_hour' do
    TimeChunk.each_hour('2013-01-01T00:00:00Z'..'2013-01-01T02:59:59Z') do |range|
      @calls << range
    end

    @calls.should eq [
      (t('2013-01-01T00:00:00Z')..t('2013-01-01T00:59:59Z')),
      (t('2013-01-01T01:00:00Z')..t('2013-01-01T01:59:59Z')),
      (t('2013-01-01T02:00:00Z')..t('2013-01-01T02:59:59Z'))
    ]
  end

  it 'should iterate over each_minute' do
    TimeChunk.each_minute('2013-01-01T00:00:00Z'..'2013-01-01T00:04:59Z') do |range|
      @calls << range
    end

    @calls.should eq [
      (t('2013-01-01T00:00:00Z')..t('2013-01-01T00:00:59Z')),
      (t('2013-01-01T00:01:00Z')..t('2013-01-01T00:01:59Z')),
      (t('2013-01-01T00:02:00Z')..t('2013-01-01T00:02:59Z')),
      (t('2013-01-01T00:03:00Z')..t('2013-01-01T00:03:59Z')),
      (t('2013-01-01T00:04:00Z')..t('2013-01-01T00:04:59Z'))
    ]
  end

end
