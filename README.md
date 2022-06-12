# Docker Youtube-DLP Alpine
*Download with [**youtube-dlp**](https://github.com/yt-dlp/yt-dlp) using command line arguments or configuration files*

**yt-dlp** is a [youtube-dlp](https://github.com/ytdl-org/youtube-dlp) fork based on the now inactive [youtube-dlc](https://github.com/blackjack4494/yt-dlc). The main focus of this project is adding new features and patches while also keeping up to date with the original project

## Features

- Works with command line arguments to *youtube-dlp*
- Compatible with AMD64, 386, ARM v6/v7/v8 CPU architectures
- Small Docker image based on
    - [Alpine 3.15](https://alpinelinux.org)
    - [Youtube-dlp](https://github.com/yt-dlp/yt-dlp)
    - [ffmpeg 4.4.1](https://pkgs.alpinelinux.org/package/v3.15/community/x86_64/ffmpeg)
    - [Ca-Certificates](https://pkgs.alpinelinux.org/package/v3.15/main/x86_64/ca-certificates)
    - [Python 3.9.7](https://pkgs.alpinelinux.org/package/v3.15/main/x86_64/python)
- The container updates youtube-dlp at launch if `-e AUTOUPDATE=yes`
- Docker healthcheck downloading `https://duckduckgo.com` with `wget` every 10 minutes
- The Docker Hub image is updated automatically every 3 days, so simply update your image with `docker pull hoanghiepitvnn/youtube-dlp-aio`

## Setup

**1. Add alias commands below to ~/.bashrc or ~/.zshrc**

```bash
export YOUTUBE_DOWNLOAD_PATH=[UPDATE_ME] # ex: ~/Downloads

# Useful commands
alias yt_files="open $YOUTUBE_DOWNLOAD_PATH"
alias yt_log="tail -f $YOUTUBE_DOWNLOAD_PATH/log.txt"

# Base youtube-dl commands
alias ytdl_docker_run="docker run --rm -e AUTOUPDATE=yes -v $YOUTUBE_DOWNLOAD_PATH:/downloads:rw hoanghiepitvnn/youtube-dlp-aio"
alias ytdl_base="ytdl_docker_run --cache-dir /downloads/.cache"
alias yt_audio="ytdl_base --extract-audio --audio-format mp3 --audio-quality 0 --ignore-errors"
alias yt_video="ytdl_base --format 'bestvideo[height>=1000+height<1100]+bestaudio/bestvideo[ext=mp4]' --recode-video mp4 --postprocessor-args '-vcodec copy'"
alias yt_video2k="ytdl_base --format 'bestvideo[height>=1400+height<1500]+bestaudio/bestvideo[ext=mp4]' --recode-video mp4 --postprocessor-args '-vcodec copy'"

# Commands to download audio
alias yt="yt_audio --output '/downloads/%(title)s.%(ext)s'"
alias ytl="yt_audio --write-link --output '/downloads/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s'"

# Commands to download video
alias ytv="yt_video --output '/downloads/%(title)s.%(ext)s'"
alias ytv2k="yt_video2k --output '/downloads/%(title)s.%(ext)s'"
alias ytvl="yt_video --output '/downloads/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s'"
alias ytv2kl="yt_video2k --output '/downloads/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s'"
```

*Note:*
  - Change your folder downloads at `YOUTUBE_DOWNLOAD_PATH`

**2. Usage** ([See the youtube-dlp options](https://github.com/yt-dlp/yt-dlp#usage-and-options))

| Command | Description |
| --- | --- |
| yt_files | Open folder contain files downloaded |
| yt_log | Tail container log |
| yt | Download audio at best quality. |
| ytl | Download playlist audio at best quality. |
| ytv | Download video max resolution at 1080 quality |
| ytvl | Download playlist video max resolution at 1080 quality |
| ytv2k | Download video max resolution at 2K quality |
| ytvl2k | Download playlist video max resolution at 2K quality |

*Example:*
```
yt https://www.youtube.com/watch?v=Ex8IeflzftY
ytl https://www.youtube.com/watch?v=d--UOXdbtuE&list=PLbnOcTug_qTzM9-08LJddoirbpYX18zq0

ytv https://www.youtube.com/watch?v=Ex8IeflzftY
ytvl https://www.youtube.com/watch?v=d--UOXdbtuE&list=PLbnOcTug_qTzM9-08LJddoirbpYX18zq0

ytv2k https://www.youtube.com/watch?v=Ex8IeflzftY
ytvl2k https://www.youtube.com/watch?v=d--UOXdbtuE&list=PLbnOcTug_qTzM9-08LJddoirbpYX18zq0
```

### Environment variables

| Environment variable | Default | Description |
| --- | --- | --- |
| `AUTOUPDATE` | `yes` | Updates youtube-dlp to the latest version at launch |

### Downloads directory permission issues

You can either:

- Change the ownership and permissions of `./downloads` on your host with:

    ```sh
    chown 1000 -R ./downloads
    chmod 700 ./downloads
    chmod -R 600 ./downloads/*
    ```

- Launch the container as `root` user

  ```bash
  1. Using `--user=root`
  OR
  2. Using `--user=$UID:$GID`
  ```
