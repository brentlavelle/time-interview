#"[H]H:MM {AM|PM}", and the second argument is a signed integer indicating the number of minutes to add to the time given in the first argument.
module TimeMod
  def self.parse_to_minutes_12(time_string)
    raise ArgumentError unless m = time_string.match(/^([01]?\d)\:(\d\d) ([AP]M)$/)
    raise ArgumentError if m[1].to_i == 0
    raise ArgumentError if m[1].to_i > 12
    raise ArgumentError if  m[2].to_i > 59

    if m[3] == 'AM'
      if m[1] == '12'
        hour = 0
      else
        hour = m[1].to_i
      end
    else
      if m[1] == '12'
        hour = m[1].to_i
      else
        hour = m[1].to_i + 12
      end
    end
    hour * 60 + m[2].to_i
  end

  def self.parse_to_minutes_24(time_string)
    # Handle one of the 2 versions of midnight first
    return 0 if time_string == '24:00'

    raise ArgumentError unless m = (time_string.match /^([012]?\d)\:(\d\d)$/)
    m[1].to_i * 60 + m[2].to_i
  end


  def self.format_time_12(minutes)
    ampm = 'AM'
    minutes    = minutes % (60 * 24) # Removes the day offset
    minute_pos = minutes % 60
    hour_pos   = (minutes - minute_pos) / 60
    if hour_pos == 0
      hour = 12
    elsif hour_pos < 12
      hour = hour_pos
    elsif hour_pos == 12
      ampm = 'PM'
      hour = 12
    else
      hour = hour_pos - 12
      ampm = 'PM'
    end
    "#{hour}:#{'%02d' % minute_pos} #{ampm}"
  end

  def self.format_time_24(minutes)
    minutes    = minutes % (60 * 24) # Removes the day offset
    minute_pos = minutes % 60
    hour_pos   = (minutes - minute_pos) / 60
    "#{hour_pos}:#{'%02d' % minute_pos}"

  end


  def self.add(time_string, offset_minutes)
    raise ArgumentError unless offset_minutes.class == Integer
    raise ArgumentError unless time_string.class == String
    if time_string.end_with?'M'
      self.format_time_12(self.parse_to_minutes_12(time_string) + offset_minutes)
    else
      self.format_time_24(self.parse_to_minutes_24(time_string) + offset_minutes)
    end
  end

end