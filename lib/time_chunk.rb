require 'time'
require 'date'

module TimeChunk

  def self.each_minute(range)
    # &Proc.new : return a proc containing the block passed to the method
    # http://www.ruby-doc.org/core-1.9.3/Proc.html#method-c-new
    iterate(range, 60, &Proc.new)
  end

  def self.each_hour(range)
    iterate(range, 3600, &Proc.new)
  end

  def self.each_day(range)
    # if we're given a date range, yield individual dates instead of a range.
    if range.begin.is_a?(Date)
      iterate(range, 86400) {|chunk| yield chunk.begin }
    # otherwise yield a range like all other methods do.
    else
      iterate(range, 86400, &Proc.new)
    end
  end

  # start at 1st day of range's beginning month
  # yield each month's 1..(end_date) range, as Date instances
  # don't yield a Date > the range's end
  def self.each_month(range)

    begin_at = range.first
    end_at = range.last

    if ! begin_at.is_a?(Date)
      begin_at = Date.parse(range.first.to_s)
    end
    if ! end_at.is_a?(Date)
      end_at = Date.parse(range.last.to_s)
    end

    (begin_at.year..end_at.year).each do |year|
      (1..12).each do |month|

        done = false
        if year == end_at.year && month == end_at.month
          last_day = end_at.day
          done = true
        else
          last_day = days_in_month(year, month)
        end

        yield Date.new(year,month,1) .. Date.new(year,month,last_day)

        return if done
      end
    end
  end

  # Iterate over any date or time range, yielding a range of no more than
  # step_size duration (in seconds.) The final yielded range may be smaller than
  # step_size if the total range is not a perfect multiple of the step_size.
  #
  # String arguments will be parsed into Times, and yield Time ranges.
  # Date ranges will yield Date ranges. Note that step_size is always in seconds
  #   even for date ranges. If this feels weird, see iterate_days instead.
  def self.iterate(range, step_size)
    if range.first.is_a?(Time)
      begin_at = range.first
      end_at = range.last.is_a?(Time) ? range.last : Time.parse(range.last.to_s)
    elsif range.first.is_a?(Date)
      begin_at = range.first
      end_at = range.last.is_a?(Date) ? range.last : Date.parse(range.last.to_s)
      # step size is always seconds, regardless of whether range is Time or Date instances
      step_size = step_size/86400
    else
      begin_at = Time.parse(range.first.to_s)
      end_at = Time.parse(range.last.to_s)
    end

    raise ArgumentError, "Given range's begin (#{begin_at.to_time.utc.iso8601}) is after its end (#{end_at.to_time.utc.iso8601})." if begin_at > end_at

    current_end = begin_at - 1

    begin
      current_begin = current_end + 1
      current_end = current_begin + step_size - 1
      current_end = [current_end, end_at].min

      yield current_begin..current_end
    end while current_end < end_at
  end

  # Same as iterate, but with step_size specified in days instead of seconds.
  def self.iterate_days(range, step_size)
    if ! range.begin.is_a?(Date) || ! range.end.is_a?(Date)
      raise ArgumentError, "iterate_days requires a range of dates."
    end

    iterate(range, step_size*86400, &Proc.new)
  end

  def self.days_in_month(year, month)
    # move to the last day of the month & return the day.
    # http://stackoverflow.com/questions/1489826/how-to-get-the-number-of-days-in-a-given-month-in-ruby-accounting-for-year
    (Date.new(year, 12, 31) << (12-month)).day
  end

end
