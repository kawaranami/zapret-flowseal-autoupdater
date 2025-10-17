# zapret-flowseal-autoupdater

fork of flowseal’s **zapret-discord-youtube**, now extended with a fully automatic updater & downloader built in together

---

## fork changelog

- each `.bat` now automatically checks for updates on launch  
- injection of update check into scripts only once (prevents duplication)  
- works correctly with paths containing spaces or cyrillic characters   

---

## how to use

- just download and run autoupdater `.bat` file in this repository anywhere you want (or just add it to your zapret folder that already exist) 
- if a new version is available, it will be downloaded and applied automatically
- if there's no zapret on your path, the script will automatically download it from the original repository
- no manual steps needed after initial setup

---

## files and structure

- `zapret_autoupdate.bat` - the core auto-updater logic  
- `last_update.txt` - stores the timestamp or commit identifier of the last applied update  


## credits

original repo: [Flowseal / zapret-discord-youtube](https://github.com/Flowseal/zapret-discord-youtube)  
