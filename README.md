# Overwatch League Tokens Bot - In Docker!

This is a fork of ucarno's [ow-league-tokens](https://github.com/ucarno/ow-league-tokens) app, and while there is some Dcoker support avaiable for it, this project aims to fully implement an easy-to-run solution using Docker. 

Using a Docker container was chosen mainly due to myself wanting to start my 'big' Docker project, but also because it should allow for easier implementations of things like bandwidth restrictions and account automation. 

## Goals

These are the main project goals:

- [ ] Auto-login for Chrome/YouTube
- [ ] Bandwidth limiting
  - [ ] Only affect streaming traffic (to avoid a slow web UI)
  - [ ] Increase limit while streaming (to achive a lower resolution)
- [X] Utilize a lighter-weight browser like Chromium
- [X] A web-based UI to make interacting with Chrome easier

These are some stretch goals I'd like to achive:

- [ ] Optional notification system (via email, discord, etc...)
- [ ] Maybe add [TwitchDropsMiner](https://github.com/DevilXD/TwitchDropsMiner) to the mix?

## Credit

Obviously this project owes a great deal to the origonal [ow-league-tokens](https://github.com/ucarno/ow-league-tokens) app, which was entirely necessary as I certainly wouldn't have wanted to write my own.

Huge thanks as well to linuxserver for their [docker-chromium](https://github.com/linuxserver/docker-chromium) image, which made adding a web UI much easier!

## Installation and Use

- Clone this repository and enter the directory
```
git clone https://github.com/bmelanman/ow-token-bot.git && cd ow-token-bot
```

- Start the container
```
docker-compose up -d
```

- Watch the logs and follow any instructions given by the bot 
```
docker-compose logs -ft ow-token-bot
```

## App Info

### The following are a few excerpts from from ucarno's [ow-league-tokens](https://github.com/ucarno/ow-league-tokens) README.md

This is an app that watches League streams for you on YouTube!

<div align="center">

[Support ~~my~~ ucarno's work](https://ko-fi.com/ucarno)

[Join the Discord](https://discord.gg/kkq2XY4cJM)

[Hire ~~my~~ ucarno on Upwork](https://www.upwork.com/freelancers/~012888e364d51bc0b2)

</div>

## Features
* Automatic live broadcast detection — don't worry about "when" and "where"
* Multiple accounts support — you just need multiple Google accounts
* Headless mode — see only a console window ([as before](https://github.com/ucarno/ow-league-tokens/tree/legacy)) if extra Chrome window is bothering you
* No sound — Chrome will be muted entirely
* Easy setup on Windows, macOS and Linux (GUI)

## Usage
**Make sure you have connected Battle.net account(s) to Google account(s)
on [this](https://www.youtube.com/account_sharing) page!**

1. Start the bot using a first menu option.
You should see Chrome window(s) opening, with text in console guiding you.
2. When you see Google's login screen - log in to your account.
3. Then you should be redirected to the YouTube page, and bot will confirm that everything is OK by writing a success
message in console.

## Updating
Sometimes you may see "new version available" message in your console. It probably means that I've fixed something.

Bot can be updated without losing your profile(s) data (no need to login into Google again):
1. Download the latest version from [here](https://github.com/ucarno/ow-league-tokens/releases/latest).
2. Either:
   * Unpack it anywhere you want and move `config.json` file and `profiles` directory from an old version to new one...
   * or move new files to old directory, replacing old files with new ones.

## Disclaimer
This app is not affiliated with Blizzard Entertainment, Inc. All trademarks are the properties of their respective owners.

2023 Blizzard Entertainment, Inc. All rights reserved.
