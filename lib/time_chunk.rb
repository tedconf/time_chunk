require 'time'

module TimeChunk

  def self.each_day(range)
    # &Proc.new : return a proc containing the block passed to the method
    # http://www.ruby-doc.org/core-1.9.3/Proc.html#method-c-new
    iterate(range, 86400, &Proc.new)
  end

  def self.each_hour(range)
    iterate(range, 3600, &Proc.new)
  end

  def self.each_minute(range)
    iterate(range, 60, &Proc.new)
  end

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
end