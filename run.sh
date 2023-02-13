#!/usr/bin/env ruby

class Language
  attr_accessor :ext, :name, :type, :compile_cmd, :run_cmd, :compile_time, :run_time
  def initialize(ext, name, type, compile_cmd, run_cmd)
    @ext = ext
    @name = name
    @type = type
    @compile_cmd = compile_cmd
    @run_cmd = run_cmd
    @compile_times = []
    @run_times = []
  end

  def run
    unless compile_cmd.empty?
      c_time = `{ bash -c "time #{compile_cmd}" ; } 2>&1`.split("\n").find{|s| s.include? "real"}.split("\t")[1].split(/[m,s]/)
      @compile_times << (c_time[0].to_i * 60) + c_time[1].to_f
    end
    r_time = `{ bash -c "time #{run_cmd}" ; } 2>&1`.split("\n").find{|s| s.include? "real"}.split("\t")[1].split(/[m,s]/)
    @run_times << (r_time[0].to_i * 60) + r_time[1].to_f
    `rm ./fib` if run_cmd == "./fib"
  rescue StandardError  => ex
    puts ex.message
    puts ex.backtrace.inspect
  end

  def average_compile_time
    return 0 if @compile_times.empty?
    @compile_times.inject(0, :+) / @compile_times.size.to_f
  end

  def average_run_time
    return 0 if @run_times.empty?
    @run_times.inject(0, :+) / @run_times.size.to_f
  end

  def total_time
    average_compile_time + average_run_time
  end
end

languages = []
languages << Language.new("c", "C", :compiled, "gcc -O3 -o fib fib.c", "./fib")
languages << Language.new("cpp", "C++", :compiled, "g++ -O3 -o fib fib.cpp", "./fib")
languages << Language.new("go", "Go", :compiled, "go build fib.go", "./fib")
languages << Language.new("rs", "Rust", :compiled, "rustc -C opt-level=3 fib.rs", "./fib")
#languages << Language.new("swift", "Swift", :compiled, "swiftc -O -g fib.swift", "./fib")
#languages << Language.new("cr", "Crystal", :compiled, "crystal build --release fib.cr", "./fib")
languages << Language.new("java", "Java", :vm, "javac Fib.java", "java Fib")
languages << Language.new("js", "Node", :mixed, "", "node fib.js")
languages << Language.new("rbjit", "Ruby (jit)", :mixed, "", "ruby --jit fib.rb")
languages << Language.new("py", "Python3", :interpreted, "", "python3 fib.py")
languages << Language.new("rb", "Ruby", :interpreted, "", "ruby fib.rb")
#languages << Language.new("php", "Php", :interpreted, "", "php fib.php")
languages << Language.new("pl", "Perl", :interpreted, "", "perl fib.pl")

filter = ARGV[0] ? ARGV[0].split(",") : []
count = ARGV[1] ? ARGV[1].to_i : 1
list = languages

unless (filter.empty? || filter[0] == "all")
  list = languages.select{|lang| filter.include? lang.ext}
  names = list.map(&:name).join(", ")
  puts "Filter: #{names}"
end

begin
  puts "-----------------"
  list.each do |lang|
    if [:compiled, :vm, :mixed].include? lang.type
      puts "Running #{lang.name} #{count} time(s)"
      count.times do
        print "."
        lang.run
      end
    else
      puts "Running #{lang.name} 1 time"
      print "."
      lang.run
    end
    puts ""
    puts "Average Compile #{("%.3f" % lang.average_compile_time)}"
    puts "Average Run #{("%.3f" % lang.average_run_time)}"
    puts "Total Time #{("%.3f" % lang.total_time)}"
    puts "-----------------"
  end
rescue Interrupt
end

puts "Last benchmark was ran on #{Time.now.strftime("%B %d, %Y")}"
puts ""

unless list.select {|l| l.type == :compiled}.empty?
  puts "## Natively compiled, statically typed"
  puts ""
  puts "| Language | Total | Compile | Time, s | Run | Time, s | Ext |"
  puts "|----------|-------|---------|---------|-----|---------|-----|"
  list.select {|l| l.type == :compiled}.sort_by {|l| l.total_time}.each do |lang|
      results = []
      results << lang.name
      results << ("%.3f" % lang.total_time).rjust(8, " ")
      results << lang.compile_cmd
      results << ("%.3f" % lang.average_compile_time).rjust(8, " ")
      results << lang.run_cmd
      results << ("%.3f" % lang.average_run_time).rjust(8, " ")
      results << lang.ext
      puts "| #{results.join(" | ")} |"
  end
  puts ""
end

unless list.select {|l| l.type == :vm}.empty?
  puts "## VM compiled bytecode, statically typed"
  puts ""
  puts "| Language | Total | Compile | Time, s | Run | Time, s | Ext |"
  puts "|----------|-------|---------|---------|-----|---------|-----|"
  list.select {|l| l.type == :vm}.sort_by {|l| l.total_time}.each do |lang|
      results = []
      results << lang.name
      results << ("%.3f" % lang.total_time).rjust(8, " ")
      results << lang.compile_cmd
      results << ("%.3f" % lang.average_compile_time).rjust(8, " ")
      results << lang.run_cmd
      results << ("%.3f" % lang.average_run_time).rjust(8, " ")
      results << lang.ext
      puts "| #{results.join(" | ")} |"
  end
  puts ""
end

unless list.select {|l| l.type == :mixed}.empty?
  puts "## VM compiled before execution, mixed/dynamically typed"
  puts ""
  puts "| Language | Time, s | Run | Ext |"
  puts "|----------|---------|-----|-----|"
  list.select {|l| l.type == :mixed}.sort_by {|l| l.total_time}.each do |lang|
      results = []
      results << lang.name
      results << ("%.3f" % lang.total_time).rjust(8, " ")
      results << lang.run_cmd
      results << lang.ext
      puts "| #{results.join(" | ")} |"
  end
  puts ""
end

unless list.select {|l| l.type == :interpreted}.empty?
  puts "## Interpreted, dynamically typed"
  puts ""
  puts "| Language | Time, s | Run | Ext |"
  puts "|----------|---------|-----|-----|"
  list.select {|l| l.type == :interpreted}.sort_by {|l| l.total_time}.each do |lang|
      results = []
      results << lang.name
      results << ("%.3f" % lang.total_time).rjust(8, " ")
      results << lang.run_cmd
      results << lang.ext
      puts "| #{results.join(" | ")} |"
  end
  puts ""
end
