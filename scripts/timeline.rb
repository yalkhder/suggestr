require 'twitter'
require 'json'
require_relative 'credentials'

client = Twitter::REST::Client.new(@config)
username = ARGV.first

options = { :count  =>  3200, :include_rts  =>  false }
allUserTweets = []

while (true)
  resultsArray = client.user_timeline(username, options)
  break if resultsArray.empty?
  resultsArray.each do |tweet|
    if tweet.hashtags?
      hashtags = []
      tweet.hashtags.each do |hashtag|
        hashtags << hashtag.text
      end
      cleanedUpTweet = { 
        :id       =>  tweet.id,
        :text     =>  tweet.text,
        :hashtags =>  hashtags,
        :user_id  =>  tweet.user.id,
        :source   =>  tweet.source
      }
      allUserTweets << cleanedUpTweet
    end
  end
  options['max_id'] = resultsArray.last.id - 1
end

puts allUserTweets.count
puts allUserTweets.last
filepath = "../data/#{username}_tweets.json"
File.open(filepath, "w").write(JSON.pretty_generate(allUserTweets))