# Copyright (c) 2015 GreenSync Pty Ltd.  All rights reserved.

require 'csv'

class DataLoader
  DATA_DIR = File.expand_path('../../data', __FILE__)

  # TIMESTAMP_REGEX = %r{\A(\d{4})/(\d{2})/(\d{2}) (\d{2}):(\d{2}):(\d{2})\z}
  # PRICE_REGEX = %r{\A(-)?(\d+)(?:.(?:(\d{2})|(\d)))?\z}

  def parse_timestamp(timestamp_string)
    DateTime.parse(timestamp_string).to_time
    # raise "invalid timestamp #{timestamp_string}" unless timestamp_string =~ TIMESTAMP_REGEX

    # Time.utc($1.to_i, $2.to_i, $3.to_i, $4.to_i, $5.to_i, $6.to_i)
  end

  def parse_price(price_string)
    (price_string.to_f * 100).to_i
  end

  def load_series
    time_series = TimeSeries.new

    Dir.glob(File.join(DATA_DIR, 'DATA??????_VIC1.csv')) do |filename|
      STDERR.puts "Loading #{filename}..."

      CSV.foreach(filename, headers: true) do |row|
        timestamp = parse_timestamp(row['SETTLEMENTDATE'])
        value = parse_price(row['RRP'])
        time_series[timestamp] = value
      end
    end

    time_series
  end

end