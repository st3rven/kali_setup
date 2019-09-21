# kali_setup


this is a script for my own use, with some upgrades from the original.
----------------------------------------------------------------------------------------------------
-----------------------------------
Kali Setup script

Update and upgrade Kali before running the script.  On fresh installs there are a few programs that 
have post install scripts that don't work well with unattended upgrades.

```
apt update && apt upgrade -y

curl -L --silent https://bit.ly/31BE8PI | bash
```

for default the majority of the options has been disable, feel free to change wherever you needs.
