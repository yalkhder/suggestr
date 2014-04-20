require 'twitter'
require 'json'
require_relative 'credentials'

testArray = []

client = Twitter::REST::Client.new(@config)
10.times do
  searchResult = client.search("a", {:lang  =>  'en'})
  searchResult.each do |tweet|
    testArray << tweet.attrs
  end
end

# might not be the best way to load JSON from file and add new results to exisiting results
previousArray = []
previousArray = JSON.parse(File.read("test.json"))

finalArray = testArray + previousArray

puts testArray.count
puts previousArray.count
puts finalArray.count

# overwrites last file
File.open("test.json", "w").write(JSON.pretty_generate(finalArray))
