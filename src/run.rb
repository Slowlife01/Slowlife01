require "httpx"
require "json"

readmeFile = File.read("./README.md")
serviceRequestFile = File.read("./data/4658.md")
featureRequestFile = File.read("./data/4660.md")

matched = readmeFile.match(/([a-z]{2,32})[#][0-9]{4}/i)[0]

def fetchUser do
    response = HTTPX.get("https://discord.com/api/v9/users/374905512661221377", :headers => {
        "Authorization" => "Bot #{ENV["DISCORD_TOKEN"]}"
    })

    return JSON.parse(response.body)
end

def fetchContent (id) do
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

user = fetchUser()
username = user["username"] << "#" << user["discriminator"]

replaced = readmeFile.gsub(matched, username)

if (matched == username) 
    puts "No action needed - username is still the same."
else
    File.write("./README.md", replaced)
    exec(File.read(File.join(__dir__, "update.sh")))
end

serviceRequest = fetchContent(4658)
featureRequest  = fetchContent(4660)

if (serviceRequest == serviceRequestFile and featureRequest == featureRequestFile)
    puts "No action needed - content is still the same."
else
    File.write("./data/4658.md", serviceRequest)
    File.write("./data/4660.md", featureRequest)
    exec(File.read(File.join(__dir__, "update.sh")))
end
