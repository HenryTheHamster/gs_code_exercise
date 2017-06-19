# Copyright (c) 2015 GreenSync Pty Ltd.  All rights reserved.
require 'pry'
require 'rspec/core/rake_task'
require 'csv'
require_relative 'lib/data_loader'
require_relative 'lib/time_series'
desc 'Default: run specs'
task default: :spec

DATA_DIR = 'data'.freeze

task :stats do
  data = []
  Dir.glob(File.join(DATA_DIR, 'DATA??????_VIC1.csv')) do |filename|
    CSV.foreach(filename, headers: true) do |row|
      timestamp = DateTime.parse(row['SETTLEMENTDATE']).to_time.utc
      value = (row['RRP'].to_f * 100).to_i
      data << [timestamp, value]
    end
  end

  years = data.group_by { |d| d[0].year }
  months = data.group_by { |d| d[0].month }
  days = data.group_by { |d| d[0].to_date }

  years.each do |_, year_values|
    stats = generate_stats(year_values.map { |v| v[1].to_f })
    date = year_values.first[0].strftime('%Y-%m-%d')
    puts "year,#{date},#{stats[:min]},#{stats[:max]},#{stats[:mean]},#{stats[:median]},#{stats[:variance]},#{stats[:std_deviation]}"

    months = year_values.group_by { |d| d[0].month }
    months.each do |_, month_values|
      stats = generate_stats(month_values.map { |v| v[1].to_f })
      date = month_values.first[0].strftime('%Y-%m-%d')
      puts "month,#{date},#{stats[:min]},#{stats[:max]},#{stats[:mean]},#{stats[:median]},#{stats[:variance]},#{stats[:std_deviation]}"

      days = month_values.group_by { |d| d[0].to_date }
      days.each do |_, day_values|
        stats = generate_stats(day_values.map { |v| v[1].to_f })
        date = day_values.first[0].strftime('%Y-%m-%d')
        puts "day,#{date},#{stats[:min]},#{stats[:max]},#{stats[:mean]},#{stats[:median]},#{stats[:variance]},#{stats[:std_deviation]}"
      end
    end
  end
end

def generate_stats(values)
  variance = variance(values)
  {
    min: values.min.round(2),
    max: values.max.round(2),
    mean: (values.inject(0, :+) / values.length).round(2),
    median: median(values).round(2),
    variance: variance.round(2),
    std_deviation: Math.sqrt(variance).round(2)
  }
end

def variance(values)
  m = values.inject(0, :+) / values.length
  sum = values.inject(0) { |accum, i| accum + (i - m)**2 }
  sum / (values.length - 1).to_f
end

def median(array)
  sorted = array.sort
  len = sorted.length
  (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
end
