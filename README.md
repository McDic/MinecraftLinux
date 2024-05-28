# Minecraft Linux Server Template

This repository is a template repository to setup and maintain your own Minecraft Linux servers.

## Pre-requisites

- Linux (I tested with [Amazon Linux 2023](https://aws.amazon.com/linux/amazon-linux-2023/))
    - Bash
- Java Runtime Environment (I tested with [Amazon Corretto 21](https://docs.aws.amazon.com/corretto/latest/corretto-21-ug/what-is-corretto-21.html) headless version)

## How-to

Make sure you replace variables covered by parentheses to correct values under following scripts.

```bash
# 1. Download MC server jar file, check https://www.minecraft.net/en-us/download/server
wget (JAVA_FILE_DIRECT_DOWNLOAD_LINK)

# 2. Make a server folder
mkdir (YOUR_FOLDER)
mv (JAR_FILE) my_server/minecraft_server.(YOUR_VERSION).jar

# 3. Run your server (Use nohup to run server in background)
./run.sh (YOUR_FOLDER) (YOUR_VERSION)
```

You can read [here](https://en.wikipedia.org/wiki/Nohup) to how to use `nohup`.

## Notes

- Default Minecraft server port is 25565, so you have to open port 25565 (or some other port you use) on your Linux server.
- `server_archives/eula_copy.txt` exists just for a convenience, you can manually replace the EULA file by your own.
- I recommend you to install JRE headless version, since most likely you won't use GUI in the server directly.
- Minecraft Fandom Wiki provides a [tutorial](https://minecraft.fandom.com/wiki/Tutorials/Setting_up_a_server#Linux_instructions), worth looking it if you are not familiar with Linux.
- You can modify some arguments in the last command of `run.sh`, `-Xmx1536M` for example.
