# Disclaimer
My discord has been suspended, I won't be able to assist anyone in the discord at the current moment, fighting discord staff to get it back.

# DCS-wine-installer
A way to play DCS on Linux using pure wine...


Basically this installer will help people install DCS on wine properly to be able to play without using Lutris. No proton will be supported as it's way to difficult to get working.


## Instructions will be posted at a later date.


1) start DCS-helper.sh and run **Directory** and choose your selection
2) Install (it will download the files if you don't have them) and will do the install process
3) Once it's done, DO NOT start the download, decheck and then run **DCS-launcher.sh** You will do the download process
4) once download is completed, run the launcher again, you will get a blackscreen, force close it
5) run **DCS-helper.sh** again and select blackscreen, it will "patch" it for you.
6) run the **DCS-launcher.sh** again and you can sign in. Once that is done, your good to go

OPTIONAL

7) run **DCS-helper.sh** and select SRS, READ THE POP UPS!


## Getting opentrack to work

1) go to the [wiki](https://github.com/opentrack/opentrack/wiki/Building-on-Linux) and follow their instructions
2) Once it's installed open it up and click on the OUTPUT and set it for WINE.
3) Click on the little hammer BESIDE the wine drop down and switch the drop down menu to Custom Path
4) Wine path is gonna be the game location where you installed it, Then it's in the RUNNER folder, open the wine folder > Bin > select **wine** EX: ``/mnt/2tbgaming/dcs_wine/runner/wine-10.19-staging-amd64/bin/wine``
5) Prefix is the SAME location but ONLY in the root directory, EX: ``/mnt/2tbgaming/dcs_wine``

That's it, save it, run it. Wine and DCS HAVE to be the same version otherwise they don't talk to each other.

Video [here](https://youtu.be/CWsxbvZJ_jI)


# Things that are working.... On my machine

X50 hotas, IR tracking with [DelanClip](https://delanclip.com/) and [Opentrack](https://github.com/opentrack/opentrack/wiki/Building-on-Linux) (details for that will be later)



## Thank yous to the people that has helped me

[LUG HELPER](https://github.com/starcitizen-lug/lug-helper/tree/main) 
> Basically the code im using for examples and creating this.

[theSane.](https://github.com/the-sane)
> basically helped me start this and didn't complain about my noobness and constant bugging




## Known issues

- Mulplayer crashes on loading

fix:

1) go to ``drive_c/Program Files/Eagle Dynamics/DCS World/MissionEditor/modules/Options/options.Db.lua`` and comment out lines 118-131 AND **sound('voice_chat_input')** line 457
   
2) ``drive_c/Program Files/Eagle Dynamics/DCS World/MissionEditor/modules/mul_voicechat.lua`` and look for **voice_chat.onPeerConnect(connectData)** 2440 and comment it out with -- at the start.
