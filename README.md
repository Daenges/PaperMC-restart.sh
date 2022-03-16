# restart.sh
This Bash script utilizes the [PaperMC API](https://papermc.io/api/docs) to obtain the latest Paper build for your Minecraft version. On top of that, it features auto restart and error logging on crash, provided by [this fellow](https://stackoverflow.com/a/62158802). </br>

# Setup
1. **Install** `jq` with your package manager. *(If not already installed.)*
2. **Clone** this repository.
3. **Move** `restart.sh` in your server folder.
4. **Open** it with a text editor and enter your parameters here.:
```
MinecraftVersion="1.18.2"
PaperFileName="paper.jar"
MAXRAM=1024M
MINRAM=1024M
RestartDelay=20
```
5. **Save** the file.
6. **Make** the script executable with `chmod +x restart.sh`.
7. **Start** the script with `./restart.sh`.
