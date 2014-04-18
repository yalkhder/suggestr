require 'twitter'
require 'json'
require_relative 'credentials'

client = Twitter::REST::Client.new(@config)
jsonFile = File.open("test.json", "a+")
testArray = []
10.times do
  searchResult = client.search("a", {:lang  =>  'en'})
  searchResult.each do |tweet|
    testArray << tweet.attrs
  end
end

# might not be the best way to load JSON from file and add new results to exisiting results
previousArray = []
if (s = jsonFile.gets)
  previousArray = JSON.parse(s)
end
finalArray = testArray + previousArray

puts testArray.count
puts previousArray.count
puts finalArray.count

jsonFile.write(finalArray.to_json)