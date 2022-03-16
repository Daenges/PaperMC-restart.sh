#!/bin/bash

###
# Please enter the version of your Minecraft server
# and the Max/Min RAM usage here.
###

MinecraftVersion="1.18.2"
MAXRAM=1024M
MINRAM=1024M
RestartDelaySeconds=20

###

while [ true ]; do
    ###
    # Use the PaperMC API to obtain the latest Paper build for the selected Minecraft version.
    ###

    echo "Searching the latest paper build for: $MinecraftVersion"

    # Remove last ".[digit]" to get version FAMILY
    PaperFamilyVersion=$(echo "$MinecraftVersion" | sed 's/[.][0-9]$//g')

    # Do API request and save json answer in variable.
    API_Result=$( curl "https://papermc.io/api/v2/projects/paper/version_group/$PaperFamilyVersion/builds" | jq --arg v "$MinecraftVersion" 'last(.builds[] | select(.version==$v))')

    # Extract latest build NAME for $MinecraftVersion
    LatestPaperBuildName=$(jq -r '.downloads.application.name' <<< "${API_Result}")

    # Extract latest build NUMBER for $MinecraftVersion
    BuildNum=$(jq -r '.build' <<< "${API_Result}")

    echo "Found Build: $BuildNum Name: $LatestPaperBuildName."

    # Check if the current build is the latest.
    if [[ ! -f "./$LatestPaperBuildName" ]]; then
        echo "Installing latest build..."

        # Download the latest .jar build of PaperMC
        curl -X 'GET' "https://papermc.io/api/v2/projects/paper/versions/$MinecraftVersion/builds/$BuildNum/downloads/$LatestPaperBuildName" -H 'accept: application/json' --output $LatestPaperBuildName
    else
        echo "Latest build already installed."
    fi

    ###
    # The following code comes from this genius: https://stackoverflow.com/a/62158802
    # It starts the server and restarts it automatically on crash while logging the exitcode to a file.
    ###

    echo "Starting PaperMC."

    # Start the paper.jar with the given java parameters.
    java -Xmx$MAXRAM -Xms$MINRAM -jar $LatestPaperBuildName nogui

    if [[ ! -d "exit_codes" ]]; then
            mkdir "exit_codes";
    fi
    if [[ ! -f "exit_codes/server_exit_codes.log" ]]; then
        touch "exit_codes/server_exit_codes.log";
    fi
    echo "[$(date +"%d.%m.%Y %T")] ExitCode: $?" >> exit_codes/server_exit_codes.log
    echo "----- Press enter to prevent the server from restarting in $RestartDelaySeconds seconds -----";
    read -t $RestartDelaySeconds input;
    if [ $? == 0 ]; then
        break;
    else
        echo "------------------- SERVER RESTARTS -------------------";
    fi
done
