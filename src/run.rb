require "httpx"
require "json"

def fetchUser
    response = HTTPX.get("https://discord.com/api/v9/users/374905512661221377", :headers => {
        "Authorization" => "Bot #{ENV["DISCORD_TOKEN"]}"
    })

    return JSON.parse(response.body)
end

readmeFile = File.read("./README.md")
oldUsername = readmeFile.match(/374905512661221377">`(.*)`<\/a>/)[1]

user = fetchUser()
if (user["username"] == nil)
    puts user
    
    abort("Unable to fetch user from the API")
end

username = user["username"]
newUsername = readmeFile.gsub(oldUsername, username)

if (oldUsername == username) 
    puts "No action needed - username is still the same."
else
    File.write("./README.md", newUsername)
    exec(File.read(File.join(__dir__, "update.sh")))
end
