import fs from "fs";

import { resolve } from "path";
import { which } from "@actions/io";
import { exec } from "@actions/exec";
import { setFailed } from "@actions/core";

const beseURL = "https://discord.com/api/v9";
const file = fs.readFileSync("./README.md").toString("utf8");
const matchedUsername = file.match(/([a-z]{2,32})[#][0-9]{4}/i)[0];

const fetchUser = async () => {
  const fetch = await import("node-fetch");
  const response: {
    username?: string;
    discriminator?: string;
  } = await (
    await fetch(`${beseURL}/users/374905512661221377`, {
      method: "GET",
      headers: {
        Authorization: `Bot ${process.env.DISCORD_TOKEN}`,
      }
    })
  ).json();

  return response;
};

fetchUser().then(async (user) => {
  const username = `${user.username}#${user.discriminator}`;
  const replaced = file.replace(matchedUsername, username);

  if (matchedUsername === username)
    return console.log("No action needed - username is still the same.");

  fs.writeFile("./README.md", replaced, () => {
    console.log(
      "[LOG] Updated the file, waiting for bash to be executed."
    );
  });

  try {
    await exec(await which("bash", true), ["src/update.sh"], {
      cwd: resolve(__dirname, "..")
    });
    console.log("[LOG] Successfully committed and pushed.");
  } catch (error) {
    setFailed(error.message);
  }
});
