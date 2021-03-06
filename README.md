# This repo is no longer being maintained!
Check out the new template [here](https://github.com/wcolding/UMDModTemplate)

## Blacklist Mod Template
This repository is a collection of scripts to make editing Tom Clancy's Splinter Cell Blacklist files as straightforward as possible. It automates the unpacking and repacking of Blacklist.umd so you can simply edit whatever config files you like, build the file and run.
***
### Requirements
The file manipulation is done in Python, so you'll need to have Python 3 installed and added to your PATH variable. 

This repository contains no game files, and contains .gitignores to keep it free of copyrighted material, so you will need a copy of the game to pull files from.

You will also need [Gildor's unumd](https://www.gildor.org/smf/index.php/topic,458.msg15196.html#msg15196) for the initial unpacking of the compressed Blacklist.umd. Place unumd.exe in the 'Tools' folder.
***
### Getting Started
You'll want to start with a clean install of Blacklist with no files modified. Clone this repo or [download it as a .zip](https://github.com/wcolding/BlacklistModTemplate/archive/refs/heads/master.zip). Run 'unpack.ps1' in Windows PowerShell, and select the System folder ('\src\system') of your Blacklist installation when prompted. You may need to run PowerShell as admin as the scripts move files around.

First, the script will copy the compressed, original Blacklist.umd to the project 'UMD' folder. It will then run unumd to decompress that file, which it will export as 'Uncompressed.umd' to that same folder.

The script will run unumd again and populate the 'src' folder with the resulting files from inside Blacklist.umd.

Finally, 'manifest.py' will run and create a file called 'manifest.txt'. This file contains the name, offset, size and an md5 hash of every file in the 'src' folder. This information is important for patching 'Uncompressed.umd' and creating a modded 'Blacklist.umd' in the build folder. **DO NOT EDIT THIS FILE.**

Now you are free to modify the files in src. When you are ready to test it, you can run 'buildrun.ps1' from the main folder and the script will attempt to launch the game (barring DRM) after repacking. It will also rename the original Blacklist.umd in your installation to 'Blacklist.umd.backup'. If you wish to make a new mod or reset your current one, you should manually delete your modded file from that folder and rename the .backup file to its original name before running 'unpack.ps1' again. The script is looking for an compressed UMD there. The possible file sizes of Blacklist.umd are as follows:
- 2,199 KB compressed
- 19,118 KB uncompressed
***
### Additional Notes
You need to make sure that each file stays the same size. If you switch a "false" to a "true", you should make sure to add another character to a comment somewhere. Files that fail to match the specified size in 'manifest.txt' will not be patched.

Not all files can be patched. Most of the Unreal Engine formatted assets in Blacklist.umd require another layer of compression. You might notice that the contents of 'src' are a lot larger than the uncompressed UMDs. These tools do not currently support repacking such files. To see which files cannot be repacked, check 'manifest.txt'. Any files with -1 after the name could not be matched to an offset within Uncompressed.umd.
