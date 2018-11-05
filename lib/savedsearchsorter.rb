#require "savedsearchsorter/version"

require 'rubygems'
require 'json'
require 'pp'

module Savedsearchsorter
  class Error < StandardError; end

  test1 = false
  test2 = false
  test3 = false
  test4 = false
  test5 = true

  #test of json parsing
  if test1 == true
    json = File.read('importtest.json')
    obj = JSON.parse(json)

    #pp obj

    print obj[0]["_source"]["description"]
  end

  #test of directory iteration
  if test2 == true
    Dir.foreach('./jsons/') do |item|
      next if item == '.' or item == '..'

        #print item.pretty_inspect
        puts item

        #it doesn't appear to treat 'item' as a file object it is a just a string of the filename..
        obj = JSON.parse(File.read('./jsons/' + item))
        print obj[0]["_source"]["description"]
        puts "\n"
    end
  end

  #test of searching for user input
  if test3 == true

    puts "Please enter search term"
    #get user input - chomp is to remove 'enter' character
    searchquery = gets()
    puts "Searching stored Saved Searches for asset " + searchquery
    searchquery = searchquery.chomp.downcase

    puts "============== \n"
    puts "Results:"

    Dir.foreach('./jsons/') do |item|
      next if item == '.' or item == '..'

      #puts item

      #it doesn't appear to treat 'item' as a file object it is a just a string of the filename..
      obj = JSON.parse(File.read('./jsons/' + item))
      description = obj[0]["_source"]["description"]

      if description.downcase.include? searchquery
        puts item
        puts obj[0]["_source"]["title"]
        puts "\n"
      end

    end

    puts "============="

  end

  #test of searching from input list
  if test4 == true

    puts "============== \n"
    puts "Results:"

    File.open('assetlist.txt') do |searchlist|
      searchlist.each_line do |searchquery|

        puts "Asset: " + searchquery
        assetname = searchquery.downcase.chomp

        Dir.foreach('./jsons/') do |item|
          next if item == '.' or item == '..'

          #it doesn't appear to treat 'item' as a file object it is a just a string of the filename..
          obj = JSON.parse(File.read('./jsons/' + item))
          description = obj[0]["_source"]["description"]

          if description.downcase.include? assetname
            puts item
            puts obj[0]["_source"]["title"]
            puts "\n"
          end

        end
      end
    end

    puts "============="

  end

  ##searches multiple json entries from single json file using asset list as input
  if test5 == true

    puts "============== \n"
    puts "Results:"

    File.open('assetlist.txt') do |searchlist|
      searchlist.each_line do |searchquery|

        puts "Asset: " + searchquery
        assetname = searchquery.downcase.chomp
        noresults = true

       obj = JSON.parse(File.read('multiple.json'))

        #iterate through json array
        obj.each do |element|

          description = element["_source"]["description"]

          if description.downcase.include? assetname
            noresults = false
            puts element["_source"]["title"]
            puts "\n"

          end

        end

        if noresults == true
          puts "No Results"
          puts "\n"
        end

      end

    end

  end

  puts "============="

end


