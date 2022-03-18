#!/bin/bash

###
# Please enter the version of your Minecraft server here.
# Or use an argument on execution with
# ./download_latest_paper_build.sh 1.18.2
###

MinecraftVersion="1.18.2"

###

# Allow version to be set by the first parameter.
if ! [ -z $1 ]; then
    MinecraftVersion=$1
fi

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

# Download the latest .jar build of PaperMC
curl -X 'GET' "https://papermc.io/api/v2/projects/paper/versions/$MinecraftVersion/builds/$BuildNum/downloads/$LatestPaperBuildName" -H 'accept: application/json' --output $LatestPaperBuildName
