# Copyright (c) 2015 GreenSync Pty Ltd.  All rights reserved.

class DailyStats

  def initialize(time_series)
    @time_series = time_series
  end

  def values(midnight)
    (1..48).map do |interval|
      @time_series[midnight + interval * 30 * 60]
    end
  end

  def min_max_avg(midnight)
    values = values(midnight)

    [values.min, values.max, (values.inject(&:+) / values.length.to_f).round]
  end

  def median(midnight)
    values = values(midnight).sort
    ((values[(values.length - 1) / 2] + values[values.length / 2]) / 2.0).round
  end

  def std_dev(midnight)
    Math.sqrt(variance(midnight)).round
  end

  def variance(midnight)
    values = values(midnight)
    m = values.inject(&:+) / values.length.to_f
    sum = values.inject(0) { |accum, i| accum + (i - m)**2 }
    (sum / (values.length - 1).to_f).round
  end

  def each
    midnight = @time_series.first_timestamp - 30 * 60

    while midnight < @time_series.last_timestamp
      yield midnight, *min_max_avg(midnight), median(midnight), std_dev(midnight), variance(midnight)
      midnight += 24 * 60 * 60
    end
  end
end