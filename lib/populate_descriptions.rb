class PopulateDescriptions

  require 'rubygems'
  require 'json'
  require 'pp'


  def check_and_update_single_description(element, assetname, assetnameasinput)

    querystring = get_querystring(element)

    if querystring.include? assetname

      puts "found assetname"

      update_single_description(element, assetname, assetnameasinput)

    end
  end

  def get_querystring(element)
    #this may only be for saved searches, will check later with visualisations
    searchqueryJSON = JSON.parse(element["_source"]["kibanaSavedObjectMeta"]["searchSourceJSON"])

    querystring = searchqueryJSON["query"]["query_string"]["query"]
    querystring = querystring.downcase.chomp

  end

  def update_single_description(element, assetname, assetnameasinput)

    #add to description if it is doesn't already include the asset
    description = element["_source"]["description"]
    if description.downcase.include? assetname
      #do nothing
    else
      if description != ""
        description = description + " & " + assetnameasinput
        puts "add to description"
      else
        description = assetnameasinput
        puts "add to description"
    end

    element["_source"]["description"] = description

    puts element["_source"]["description"]

    end

  end

  def check_every_asset(assetlistname, element)

    File.open(assetlistname) do |searchlist|
      searchlist.each_line do |searchquery|

        puts "Asset: " + searchquery
        assetnameasinput = searchquery.chomp
        assetname = searchquery.downcase.chomp

        check_and_update_single_description(element, assetname, assetnameasinput)

      end
    end
  end

  def check_every_saved_object(jsonfilename, assetlistname, outputarray)

    obj = JSON.parse(File.read(jsonfilename))
    obj.each do |element|

      puts element["_source"]["title"]

      #check every item in the assetlist
      check_every_asset(assetlistname, element)

      #elements are put back into an array so they can be read by kibana.
      outputarray << element

    end

  end

  def save_output(outputarray, outputfilename)

    File.open(outputfilename, 'w') do |f|
      f.write(JSON.pretty_generate(outputarray))
    end


  end

  def main(inputjsonfilename, assetlistname, outputfilename)
    #create output array so that multiple objects can be imported back into kibana.
    outputarray = Array.new

    puts "============== \n"

    check_every_saved_object(inputjsonfilename, assetlistname, outputarray)

    save_output(outputarray, outputfilename)

    puts "============="

  end

end