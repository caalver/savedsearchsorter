
class Menu < StandardError;

require 'rubygems'
require 'json'
require 'pp'
require './savedsearchsorter'
require '../lib/populate_descriptions'
require '../lib/search_for_asset'

include Savedsearchsorter

  def run

    @correct = false
    #these have a corresponding option number in update_default
    @inputjsonfilename = 'multiplenodesc.json'
    @assetlistname = 'assetlist.txt'
    @outputfilename = 'output.json'
    
    puts "Please select function"
    puts "1. Populate description based on search queries"
    puts "2. Search descriptions for assets"
    #get user input - chomp is to remove 'enter' character
    userinput = gets
    userinput = userinput.chomp

    if userinput == '1'

      puts "Running option 1"
      puts "Enter parameters as prompted or accept defaults:"

      repeatpromptthenreceiveinput("Enter input json filename (default is multiplenodesc.json)", 1)
      repeatpromptthenreceiveinput("Enter asset list name (default is assetlist.txt)", 2)
      repeatpromptthenreceiveinput("Enter output file name (default is output.json)", 3)

      run_PopulateDescriptions(@inputjsonfilename, @assetlistname, @outputfilename)

    elsif userinput == '2'

      puts "Running option 2"
      puts "Enter parameters as prompted or accept defaults:"

      repeatpromptthenreceiveinput("Enter input json filename (default is multiplenodesc.json)", 1)
      repeatpromptthenreceiveinput("Enter asset list name (default is assetlist.txt)", 2)

      run_SearchForAsset(@assetlistname, @inputjsonfilename)

    else
      puts "Invalid option, exiting."
    end

  end

  def repeatpromptthenreceiveinput(messageforuser, optiontoupdate)
    while @correct != true

      puts messageforuser
      userinput = gets.chomp

      if userinput != ''
        confirmcorrectinput(userinput)
        if @correct == true
          update_default(userinput, optiontoupdate)
        end
      else
        @correct = true
      end
    end

    @correct = false
  end

  def update_default(newvalue, optiontoupdate)

    case optiontoupdate
    when 1
      @inputjsonfilename = newvalue
    when 2
      @assetlistname = newvalue
    when 3
      @outputfilename = newvalue
    end

  end

  def confirmcorrectinput(inputtedparam)

    puts "Input is " + inputtedparam + "is this correct? Y/N"

    response = gets
    response = response.chomp.downcase

    if response == 'y' || response == 'yes'
      @correct = true
    elsif response == 'n' || response == 'no'
      @correct = false
    end

  end

  def run_PopulateDescriptions(inputjsonfilename, assetlistname, outputfilename)
    updatedescriptions = PopulateDescriptions.new()
    updatedescriptions.main(inputjsonfilename, assetlistname, outputfilename)
  end

  def run_SearchForAsset(assetlistname, jsonfilename)
    searchforasset = SearchForAsset.new()

    puts "input params are " + assetlistname + " and " + jsonfilename
    searchforasset.main(assetlistname, jsonfilename)
  end

end

