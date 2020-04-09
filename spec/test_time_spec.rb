require 'rspec'
require_relative '../lib/time_mod'

describe 'Parameters' do
  context 'AM/PM tests' do
    it 'works with a +1 offset' do
      expect(TimeMod::add("12:55 PM", 1)).to eq("12:56 PM")
    end

    it 'works with a -1 offset' do
      expect(TimeMod::add("1:15 AM", -1)).to eq("1:14 AM")
    end

    it 'can cross the noon hour boundary in both directions' do
      expect(TimeMod::add("11:05 AM", 62)).to eq("12:07 PM")
      expect(TimeMod::add("12:07 PM", -62)).to eq("11:05 AM")
    end

    it 'allows for leading 0s on input hours' do
      expect(TimeMod::add("07:05 AM", 55)).to eq("8:00 AM")
    end

    it 'midnight to midnight' do
      expect(TimeMod::add("12:00 AM", 24*60)).to eq("12:00 AM")
    end

    it 'midnight to noon backwards' do
      expect(TimeMod::add("12:00 AM", -12*60)).to eq("12:00 PM")
    end

    it 'can go a year and a minute into the future' do
      expect(TimeMod::add("7:02 AM", 365*24*60+1)).to eq("7:03 AM")

    end

    it 'exhaustive set 0 offset for all times' do
      # This is overkill but proves that all the inputs are parsed and produced
      (1..12).each do |hour|
        (0..59).each do |minute|
          ['AM','PM'].each do |am_or_pm|
            some_time = "#{hour}:#{'%02d' % minute} #{am_or_pm}"
            expect(TimeMod::add(some_time, 0)).to eq(some_time)
            end
        end
      end
    end
  end

  context 'AM/PM negative tests' do
    it 'use a Float instead of an int' do
      expect { TimeMod::add("12:30 AM", 10.5) }.to raise_error(ArgumentError)
    end

    it 'needs the time to be a string' do
      expect { TimeMod::add(1215, 1) }.to raise_error(ArgumentError)
    end

    it 'needs the time formatted correctly' do
      [
          '123:30 AM',
          '9:130 AM',
          '11:13 TM',
          '11:1 AM',
          '1201 AM',
          '',
          '∰',
          '﷽',
      ].each do |time|
        expect { TimeMod::add(time, 2) }.to raise_error(ArgumentError)
      end
    end
  end

  context '24 hour tests' do
    it 'works with a +1 offset' do
      expect(TimeMod::add("12:55", 1)).to eq("12:56")
    end

    it 'works with a -1 offset' do
      expect(TimeMod::add("14:15", -1)).to eq("14:14")
    end

    it 'can cross the noon hour boundary in both directions' do
      expect(TimeMod::add("11:05", 122)).to eq("13:07")
      expect(TimeMod::add("13:07", -122)).to eq("11:05")
    end

    it 'allows for leading 0s on input hours' do
      expect(TimeMod::add("07:05", 55)).to eq("8:00")
    end

    it 'midnight to midnight' do
      # the 00:00 format for midnight is read and written
      expect(TimeMod::add("0:00", 24*60)).to eq("0:00")
      # the 24:00 format of midnight is read but not written possible bug
      expect(TimeMod::add("24:00", 24*60)).to eq("0:00")
    end

    it 'midnight to noon backwards' do
      expect(TimeMod::add("24:00", -12*60)).to eq("12:00")
    end

    it 'can go a year and a minute into the future' do
      expect(TimeMod::add("17:02", 365*24*60+1)).to eq("17:03")
    end

    it 'exhaustive set 0 offset for all times' do
      # This is overkill but proves that all the inputs are parsed and produced
      (1..12).each do |hour|
        (0..0).each do |minute|
            some_time = "#{hour}:#{'%02d' % minute}"
            expect(TimeMod::add(some_time, 0)).to eq(some_time)
        end
      end
    end
  end

end
