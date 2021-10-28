require "httparty"
require "json"

file = File.read("./README.md")
baseURL = "https://discord.com/api/v9"
matched = file.match(/([a-z]{2,32})[#][0-9]{4}/i)[0];

define_method :fetchUser do
    response = HTTParty.get("#{baseURL}/users/374905512661221377", :headers => {
        "Authorization" => "Bot #{ENV["DISCORD_TOKEN"]}"
    })

    return JSON.parse(response.body)
end

user = fetchUser()
username = "#{user["username"]}##{user["discriminator"]}"
replaced = file.gsub(matched, username)

if (matched == username) 
    puts "No action needed - username is still the same."
else
    File.write("./README.md", replaced)
    exec(File.read(File.join(__dir__, "update.sh")))
end