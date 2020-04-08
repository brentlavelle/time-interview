require 'rspec'
require_relative '../lib/time_mod'

describe 'Parameters' do
  context 'not an int' do
    it 'works with a 0 offset' do
      some_time = "12:55 PM"
      expect(TimeMod::add(some_time, 0)).to eq(some_time)
    end

    it 'use a Float instead of an int' do
      expect { TimeMod::add("12:30 AM", 10.5) }.to raise_error(ArgumentError)
    end

    it 'needs the time to be a string' do
      expect { TimeMod::add(15, 1) }.to raise_error(ArgumentError)
    end
  end
end
