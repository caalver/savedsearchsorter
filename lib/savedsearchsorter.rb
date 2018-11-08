#require "savedsearchsorter/version"

require 'rubygems'
require 'json'
require 'pp'


module Savedsearchsorter
  class Error < StandardError; end


  class Utilitymethods

    def jsonparsetest
      json = File.read('importtest.json')
      obj = JSON.parse(json)

      print obj[0]["_source"]["description"]
    end

    #test of directory iteration
    def directorytraversaltest
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
    def userinputtest
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
    def inputlisttest
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
    def searchmultipletest
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

      puts "============="

    end

    #searches json queries for presence of an asset, will update description with asset if found in the query.
    # output is a new json file
    def update_descriptions
      #create output array so that multiple objects can be imported back into kibana.
      outputarray = Array.new

      puts "============== \n"

      obj = JSON.parse(File.read('multiplenodesc.json'))
      obj.each do |element|

        puts element["_source"]["title"]

        File.open('assetlist.txt') do |searchlist|
          searchlist.each_line do |searchquery|

            puts "Asset: " + searchquery
            assetnameasinput = searchquery.chomp
            assetname = searchquery.downcase.chomp

            #this may only be for saved searches, will check later with visualisations
            searchqueryJSON = JSON.parse(element["_source"]["kibanaSavedObjectMeta"]["searchSourceJSON"])

            querystring = searchqueryJSON["query"]["query_string"]["query"]
            querystring = querystring.downcase.chomp

            if querystring.include? assetname

              puts "found assetname"

              #add to description if it is doesn't already include the asset
              description = element["_source"]["description"]

              if description.downcase.include? assetname
                #do nothing
              else
                description = description + " " + assetnameasinput
                puts "add to description"
              end

              element["_source"]["description"] = description

              puts element["_source"]["description"]

            end
          end
        end

        #elements are put back into an array so they can be read by kibana.
        outputarray << element

        puts "Writing updated search to output file"
        File.open('output.json', 'w') do |f|
          f.write(JSON.pretty_generate(outputarray))
        end
      end

      puts "============="

    end

  end

end




