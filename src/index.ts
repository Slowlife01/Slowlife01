import fetch from "node-fetch";
import fs from "fs";

import { resolve } from "path";
import { exec } from "@actions/exec";
import { which } from "@actions/io";
import { setFailed } from "@actions/core";

const beseURL = "https://discord.com/api/v9/users/374905512661221377";
const file = fs.readFileSync("./README.md").toString("utf8");
const matchedUsername = file.match(/([a-z]{2,32})[#][0-9]{4}/i)[0];

const fetchUser = async () => {
  const response: {
    username: string;
    discriminator: string;
  } = await (
    await fetch(beseURL, {
      method: "GET",
      headers: {
        Authorization: process.env.DISCORD_TOKEN,
      }
    })
  ).json();

  return response;
};

fetchUser().then(async (user) => {
  const replaced = file.replace(
    matchedUsername,
    `${user.username}#${user.discriminator}`
  );

  if (matchedUsername === `${user.username}#${user.discriminator}`)
    return console.log("No action needed - username is still same.");

  fs.writeFile("./README.md", replaced, () => {
    console.log(
      "[LOG] Updated the file, waiting for bash to be executed."
    );
  });

  try {
    await exec(await which("bash", true), ["src/deploy.sh"], {
      cwd: resolve(__dirname, "..")
    });
    console.log("[LOG] Successfully committed and pushed.");
  } catch (error) {
    setFailed(error.message);
  }
});
