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
    begin_time = range.first.is_a?(Time) ? range.first : Time.parse(range.first)
    end_time = range.last.is_a?(Time) ? range.last : Time.parse(range.last)
    raise ArgumentError, "Given range's begin (#{begin_time.iso8601}) is after its end (#{end_time.iso8601})." if begin_time > end_time

    current_end_time = begin_time - 1

    begin
      current_begin_time = current_end_time + 1
      current_end_time = current_begin_time + step_size - 1
      current_end_time = [current_end_time, end_time].min

      yield current_begin_time..current_end_time
    end while current_end_time < end_time
  end

end