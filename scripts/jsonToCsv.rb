require 'json'

data = JSON.parse(File.read("../data/test.json"))

output = File.open("../data/test.csv", "w")

output.write("id\tuser_id\ttext\tsource\thashtags\n")

data.each do |tweet|
  output.write(tweet["id"].to_s + "\t" +
               tweet["user_id"].to_s + "\t" +
               tweet["text"].gsub("\n", " ") + "\t" +
               tweet["source"].gsub("\n", " "))
  tweet["hashtags"].each do |hashtag|
    output.write("\t" + hashtag)
  end
  output.write("\n")
end
