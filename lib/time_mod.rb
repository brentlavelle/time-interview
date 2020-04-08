#"[H]H:MM {AM|PM}", and the second argument is a signed integer indicating the number of minutes to add to the time given in the first argument.
module TimeMod

  def self.add(time_string, offset_minutes)
    raise ArgumentError unless offset_minutes.class == Integer
    raise ArgumentError unless time_string.class == String

    time_string
  end
end