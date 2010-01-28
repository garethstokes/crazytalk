#!/bin/ruby

require 'rubygems'
require 'fastercsv'
require 'tempfile'

File.open "GarryDanger-tweets.txt", "a" do |output_file|
  File.open "GarryDanger.txt", "a" do |f|
    FasterCSV.foreach "../bak/GarryDanger-53ZbvNkF.csv" do |row|
      if row[0] == "GarryDanger"
        tmp = Tempfile.new "RoroMarkov.txt"
        tmp.write row[1]
        tmp.rewind
        result = `./html2text #{tmp.path}`
        output_file.write "#{result.gsub("_\10", "").gsub("\n", ". ")}".strip + "\n"
        tmp.close
      end
    end
  end
end
