#!/bin/sh

printf " =========================================\n"
printf " =========================================\n"
printf " ========== YOUTUBE-DLP CONTAINER =========\n"
printf " =========================================\n"
printf " =========================================\n"
printf " == by github.com/dhhiep - Hiep Dinh ==\n\n"

exitIfNotIn(){
  # $1 is the name of the variable to check - not the variable itself
  # $2 is a string of comma separated possible values
  var="$(eval echo "\$$1")"
  for value in ${2//,/ }
  do
    if [ "$var" = "$value" ]; then
      return 0
    fi
  done
  printf "Environment variable $1=$var must be one of the following: "
  for value in ${2//,/ }
  do
    printf "$value "
  done
  printf "\n"
  exit 1
}

exitOnError(){
  # $1 must be set to $?
  status=$1
  message=$2
  [ "$message" != "" ] || message="Error!"
  if [ $status != 0 ]; then
    printf "$message (status $status)\n"
    exit $status
  fi
}

exitIfNotIn AUTOUPDATE "yes,no"
[ "$AUTOUPDATE" = "no" ] || youtube-dlp -U
YTDLP_VERSION=$(youtube-dlp --version)
PYTHON_VERSION=$(python3 --version 2>&1 | cut -d " " -f 2)
FFMPEG_VERSION=$(ffmpeg -version | head -n 1 | grep -oE 'version [0-9]+\.[0-9]+\.[0-9]+' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
printf "Youtube-dlp version: $YTDLP_VERSION"
printf "\nPython version: $PYTHON_VERSION"
printf "\nFFMPEG version: $FFMPEG_VERSION"
printf "\n\n"

printf "= = = = DOWNLOAD FOLDER = = = =\n"
ls -al /downloads
printf "= = = = = = = = = = = = = = = =\n\n"

test -w "/downloads"
if [ $? != 0 ]; then
  echo "WARNING: /downloads is not writable, you might want to fix its ownership and/or permissions"
fi
youtube-dlp "$@"
status=$?
printf "\n =========================================\n"
printf " Youtube-dl exit with status $status\n"
printf " =========================================\n"
