require "httpx"
require "json"

def fetchUser
    response = HTTPX.get("https://discord.com/api/v9/users/374905512661221377", :headers => {
        "Authorization" => "Bot #{ENV["DISCORD_TOKEN"]}"
    })

    return JSON.parse(response.body)
end

def fetchContent (id)
    response = HTTPX.post("https://api.github.com/graphql",
        :headers => {
          "Authorization" => "Bearer #{ENV["GITHUB"]}"
        },
        :body => JSON.generate({
          :query => %{{
            repository(owner: "PreMiD", name: "Presences") {
              discussion(number: #{id}) {
                body
              }
            }
          }
        }
    }))

    return JSON.parse(response.body)["data"]["repository"]["discussion"]["body"]
end

readmeFile = File.read("./README.md")
serviceRequestFile = File.read("./data/4658.md")
featureRequestFile = File.read("./data/4660.md")

oldUsername = readmeFile.match(/([a-z]{2,32})[#][0-9]{4}/i)[0]

user = fetchUser()
username = user["username"] << "#" << user["discriminator"]
newUsername = readmeFile.gsub(oldUsername, username)

serviceRequest = fetchContent(4658)
featureRequest  = fetchContent(4660)

if (oldUsername == username) 
    puts "No action needed - username is still the same."
else
    File.write("./README.md", newUsername)
    exec(File.read(File.join(__dir__, "update.sh")))
end

if (serviceRequest == serviceRequestFile and featureRequest == featureRequestFile)
    puts "No action needed - content is still the same."
else
    if (serviceRequest != serviceRequestFile)
        File.write("./data/4658.md", serviceRequest)
    end
    
    if (featureRequest != featureRequestFile) 
        File.write("./data/4660.md", featureRequest)
    end
    
    exec(File.read(File.join(__dir__, "update.sh")))
end
