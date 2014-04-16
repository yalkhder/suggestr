require 'twitter'

config = {
  :consumer_key         =>  "2obJdnCcsfskkdDkgIzwke9Eq",
  :consumer_secret      =>  "pnlVumuzUgjnwXr3AuEvREWaE8HMjgrVV1NV73E1V6stVapTdK",
  :access_token         =>  "2447737650-Eb7axidllSjzY34yUMTnGRWjE8924QJ2p6gzrrL",
  :access_token_secret  =>  "rswb7umdaZCqhYyyG0ipic5XLCCbTXVSX7oiKnwjYM6Cg"
}

client = Twitter::REST::Client.new(config)

searchResult = client.search("a", {:lang  =>  'en'})

# searchResult.each do |tweet|
#     puts tweet.attrs
# end

puts searchResult.first.attrs