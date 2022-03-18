# restart.sh
This Bash script utilizes the [PaperMC API](https://papermc.io/api/docs) to obtain the latest Paper build for your Minecraft version. On top of that, it features auto restart and error logging on crash, provided by [this fellow](https://stackoverflow.com/a/62158802). </br>

**You do not care about all the extra stuff?**
`download_latest_paper_build.sh` does what the name suggests. You can either set your minecraft version in the script itself or **parse it with an argument**, which predestines it to be **included in your own scripts**.

# Setup
1. **Install** `jq` with your package manager. *(If not already installed.)*
2. **CD** into your server folder.
3. **Download** `restart.sh` with `wget "https://raw.githubusercontent.com/Daenges/PaperMC-restart.sh/main/restart.sh"`.
4. **Open** it with any text editor and **enter** your desired Minecraft version here:
```
MinecraftVersion="1.18.2"
MAXRAM=1024M
MINRAM=1024M
RestartDelay=20
RemoveOldBuilds=true
```
5. **Save** the file.
6. **Make** the script executable with `chmod +x restart.sh`.
7. **Start** the script with `./restart.sh`.

# How it works
> Lets assume you want a Minecraft server on the version `1.18.2`

The script sends a Request for all builds of your **version family** to the PaperMC API. This will return all `1.18` builds. The API response is processed by `jq`, which extracts all builds in this list, that exactly match your version `1.18.2`. Then it picks the last item of it, so the information for the latest build of PaperMC for `1.18.2`. *Now the most magic is done.*</br>
The script extracts all information from the json of the latest build, and combines them to a request for PaperMCs download API. If you checked `RemoveOldBuilds`, the old PaperMC executable is deleted and the latest build gets downloaded and started.</br></br>

When the server stops, the script creates a folder, with a file named `server_exit_codes.log`. To debug crashes, all **exit codes** will be saved here. After that the script starts a **Countdown** of `RestartDelaySeconds`, which can be interruptded by pressing `ENTER`. If `ENTER` is not pressed, the script starts from the top again.
