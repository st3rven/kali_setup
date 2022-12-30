# kali_setup

Kali Setup script

Update and upgrade Kali before running the script.  On fresh installs there are a few programs that 
have post install scripts that don't work well with unattended upgrades.

```
apt update && apt upgrade -y

./setup.sh <user>
```

### Docker option
For Kali docker you can use `setup_docker.sh` 


for default the majority of the options has been disable, feel free to change wherever you needs.
