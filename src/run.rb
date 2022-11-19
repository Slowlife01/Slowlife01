require "httpx"
require "json"

def fetchUser
    response = HTTPX.get("https://discord.com/api/v9/users/374905512661221377", :headers => {
        "Authorization" => "Bot #{ENV["DISCORD_TOKEN"]}"
    })

    return JSON.parse(response.body)
end

readmeFile = File.read("./README.md")
oldUsername = readmeFile.match(/([a-z]{2,32})[#][0-9]{4}/i)[0]

user = fetchUser()
if (not user)
    abort "Unable to fetch user from the API"
end


username = user["username"] + "#" + user["discriminator"]
newUsername = readmeFile.gsub(oldUsername, username)

if (oldUsername == username) 
    puts "No action needed - username is still the same."
else
    File.write("./README.md", newUsername)
    exec(File.read(File.join(__dir__, "update.sh")))
end
