# Disclaimer
My discord has been suspended, I won't be able to assist anyone in the discord at the current moment, fighting discord staff to get it back.

# DCS-wine-installer
A way to play DCS on Linux using pure wine...


Basically this installer will help people install DCS on wine properly to be able to play without using Lutris. No proton will be supported as it's way to difficult to get working.


## Instructions will be posted at a later date.


At the current moment, things will be changing a lot so this will be changing...

Right now the steps are not needed as im recoding my entire thing... Hurray...


# Things that are working.... On my machine

X50 hotas, IR tracking with DelanClip and Opentrack (details for that will be later)



## Thank yous to the people that has helped me

[LUG HELPER](https://github.com/starcitizen-lug/lug-helper/tree/main) 
> Basically the code im using for examples and creating this.

[theSane.](https://github.com/the-sane)
> basically helped me start this and didn't complain about my noobness and constant bugging




## Known issues

- Mulplayer crashes on loading

fix:

1) go to ``drive_c/Program Files/Eagle Dynamics/DCS World/MissionEditor/modules/Options/options.Db.lua`` and comment out lines 118-131 AND line 457 ``sound('voice_chat_input')``
    
2) ``drive_c/Program Files/Eagle Dynamics/DCS World/MissionEditor/modules/mul_voicechat.lua`` and look for ``voice_chat.onPeerConnect(connectData)`` (line 2440) and comment it out with -- at the start.
