require 'twitter'
require 'json'
require_relative 'credentials'

client = Twitter::REST::Client.new(@config)
searchResult = client.search("a", {:lang  =>  'en'})
# might get dupe tweets
File.open("test.json", "a+") do |f|
  searchResult.each do |tweet|
    if tweet.hashtags?
      f.write(tweet.attrs.to_json)
    end
  end
end