require 'csv'
require 'pry'
require 'benchmark'
require 'date'

directory = ARGV[0]
key = ARGV[1]
value = ARGV[2]

csvs = Dir["#{directory}/*.csv"]

logdir = "#{directory}/log/"
unless File.directory?(logdir)
  FileUtils.mkdir_p(logdir)
end
@logfile = File.open("#{directory}/log/#{DateTime.now}.log", "w")

def print_memory_usage
  memory_before = `ps -o rss= -p #{Process.pid}`.to_i
  yield
  memory_after = `ps -o rss= -p #{Process.pid}`.to_i

  puts "Memory: #{((memory_after - memory_before) / 1024.0).round(2)} MB"
end

def print_time_spent
  time = Benchmark.realtime do
    yield
  end

  puts "Time: #{time.round(2)}"
end

def write_log(f, k, v, filesum)
  formatted = "#{f} | #{k} | #{v} | count: #{filesum}\n"
  @logfile << formatted
end

total_sum = 0
csvs.each do |file|
  print_memory_usage do
    print_time_spent do
      sum = 0

      CSV.foreach(file, headers: true, col_sep: "|") do |row|
        if row["#{key}"] == "#{value}"
          total_sum += 1
          sum += 1
        end
      end

      write_log(file, key, value, sum)
      puts "#{value} rows in this file: #{sum}"
      puts "#{value} rows total so far: #{total_sum}"
    end
  end
end

@logfile << "\n\n Total count: #{total_sum}"
puts "#{value} rows in all csv files: #{total_sum}"
