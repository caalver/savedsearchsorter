class SearchForAsset

  require 'rubygems'
  require 'json'
  require 'pp'

  @noresults = true


  def searchJSON(jsonfilename, assetname) #multiple.json

    obj = JSON.parse(File.read(jsonfilename))

    #iterate through json array
    obj.each do |element|

      description = element["_source"]["description"]

      if description.downcase.include? assetname
        @noresults = false
        puts element["_source"]["title"]
        puts "\n"
      end

    end

  end


  def main(assetlistname, jsonfilename)
    puts "============== \n"
    puts "Results:"

    File.open(assetlistname) do |searchlist|
      searchlist.each_line do |searchquery|

        puts "Asset: " + searchquery
        assetname = searchquery.downcase.chomp
        @noresults = true

        searchJSON(jsonfilename, assetname)

        if @noresults == true
          puts "No Results"
          puts "\n"
        end

      end

    end

    puts "============="

  end

end