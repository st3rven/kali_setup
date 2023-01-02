#!/bin/bash
# icons
# ❌⏳💀🎉 ℹ️ ⚠️ 🚀 ✅ ♻ 🚮 🛡 🔧  ⚙ 

# run update and upgrade, before running script
# apt update && apt upgrade -y
## curl -L --silent https://bit.ly/31BE8PI <user> | bash
#
# set -x
# user input

user=$1
downloads=/home/"$user"/Downloads

# set colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE="\033[01;34m" # Heading
NO_COLOR='\033[0m'
CLEAR_LINE='\r\033[K'
BOLD="\033[01;01m" # Highlight
RESET="\033[00m" # Normal

# set env variable for apt-get installs
export DEBIAN_FRONTEND=noninteractive

# verify running as root
if [[ "${EUID}" -ne 0 ]]; then
  echo -e ' '${RED}'[!]'${RESET}" This script must be ${RED}run as root${RESET}" 1>&2
  echo -e ' '${RED}'[!]'${RESET}" Quitting..." 1>&2
  exit 1
fi

# verify argument
if [ $# -eq 0 ]
  then
    echo "${RED}No arguments supplied${RESET}"1>&2
else
  echo -e "  🚀 ${BOLD}Starting Kali setup script${RESET}"
fi

# enable https repository
cat <<EOF >/etc/apt/sources.list
deb https://http.kali.org/kali kali-rolling main non-free contrib
EOF

compute_start_time(){
    start_time=$(date +%s)
    echo "\n\n Install started - $start_time \n" >> script.log
}

configure_environment(){
    echo "HISTTIMEFORMAT='%m/%d/%y %T '" >> /root/.bashrc
}

apt_update() {  
    printf "  ⏳  apt update\n" | tee -a script.log
    apt update -qq >> script.log 2>>script_error.log
}

apt_upgrade() {
    printf "  ⏳  apt upgrade\n" | tee -a script.log
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -qq >> script.log 2>>script_error.log
}

apt_package_install() {
    echo "\n [+] installing $1 via apt\n" >> script.log
    apt install -y -q $1 >> script.log 2>>script_error.log
}

install_kernel_headers() {
    printf "  ⏳  install kernel headers\n" | tee -a script.log
    apt -y -qq install make gcc "linux-headers-$(uname -r)" >> script.log 2>>script_error.log \
    || printf ' '${RED}'[!] Issue with apt install\n'${RESET} 1>&2
    if [[ $? != 0 ]]; then
    echo -e ' '${RED}'[!]'${RESET}" There was an ${RED}issue installing kernel headers${RESET}" 1>&2
        printf " ${YELLOW}[i]${RESET} Are you ${YELLOW}USING${RESET} the ${YELLOW}latest kernel${RESET}? \n"
        printf " ${YELLOW}[i]${RESET} ${YELLOW}Reboot${RESET} your machine\n"
    fi
}

install_base_os_tools(){
    printf "  ⏳  Installing base os tools programs\n" | tee -a script.log
    # sshfs - mount file system over ssh
    # nfs-common - 
    # sshuttle - VPN/proxy over ssh 
    # autossh - specify password ofr ssh in cli
    # dbeaver - GUI universal db viewer
    # jq - cli json processor
    # micro - text editor
    # pip3 and pip
    # apt-utils
    for package in strace ltrace sshfs nfs-common sshuttle autossh dbeaver jq micro python3-pip python-pip net-tools sshuttle wget curl git mlocate apt-utils nano
    do
        apt install -y -q "$package" >> script.log 2>>script_error.log
    done 
}

install_libs(){
    printf "  ⏳  Installing some libs\n" | tee -a script.log
    for package in libcurl4-openssl-dev libssl-dev ruby-full libxml2 libxml2-dev libxslt1-dev ruby-dev \
    build-essential libgmp-dev zlib1g-dev build-essential libssl-dev libffi-dev python3-dev \
    libldns-dev rename
    do
        apt install -y -q "$package" >> script.log 2>>script_error.log
    done
}

install_python3_related(){
    printf "  ⏳  Installing python3 related libraries\n" | tee -a script.log
    # pipenv - python virtual environments
    # pysmb - python smb library used in some exploits
    # pycryptodome - python crypto module
    # pysnmp - 
    # requests - 
    # future - 
    # paramiko - 
    # selenium - control chrome browser
    # awscli
    pip3 -q install pipenv pysmb pycryptodome pysnmp requests future paramiko selenium awscli setuptools 2>>script_error.log
}

install_fonts(){
    printf "  ⏳  Downloading fonts\n" | tee -a script.log
    cd "$downloads"
    wget --quiet https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/FiraMono/Regular/complete/Fura%20Mono%20Regular%20Nerd%20Font%20Complete.otf?raw=true -O Fura_Mono_Regular_Nerd_Font_Complete.otf
    if [[ $? != 0 ]]; then
        printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
    mkdir -p /home/"$user"/.fonts
    cp Fura_Mono_Regular_Nerd_Font_Complete.otf /home/"$user"/.fonts
    rm -f Fura_Mono_Regular_Nerd_Font_Complete.otf
    fc-cache -f
}

install_zsh(){
    printf "  ⏳  Installing zsh shell and set custom config\n" | tee -a script.log
    cd "$downloads"
    for package in zsh
    do
        apt install -y -q "$package" >> script.log 2>>script_error.log
    done
    wget --quiet https://www.dropbox.com/s/as1ld1dylio14pv/myconfig_zsh.tar.gz\?dl\=0 -O zsh_config.tar.gz
    if [[ $? != 0 ]]; then
        printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
    tar -xzf zsh_config.tar.gz
    cp -r .zshrc /home/"$user"
    cp -r .oh-my-zsh/ /home/"$user"/
    chsh -s $(which zsh)
}

install_re_tools(){
    printf "  ⏳  Installing file analyzer apps\n" | tee -a script.log
    # exiftool - 
    # okteta - 
    # hexcurse - 
    for package in exiftool okteta hexcurse
    do
        apt install -y -q $package >> script.log 2>>script_error.log
    done
}

install_metapackage(){
    printf "  ⏳  Installing Kali Metapackages\n" | tee -a "$home"/script.log
    for package in kali-linux-core kali-linux-headless kali-linux-default kali-tools-crypto-stego \
    kali-tools-fuzzing kali-tools-windows-resources kali-tools-information-gathering kali-tools-vulnerability \
    kali-tools-web kali-tools-database kali-tools-passwords kali-tools-reverse-engineering kali-tools-exploitation \
    kali-tools-social-engineering kali-tools-sniffing-spoofing kali-tools-post-exploitation kali-tools-forensics
    do
        apt install -y -q $package >> "$home"/script.log 2>> "$home"/script_error.log
    done
}

install_exploit_tools(){
    printf "  ⏳  Installing exploit apps\n" | tee -a script.log
    # gcc-multilib - multi arch libs
    # mingw-w64 - windows compile
    # crackmapexec - pass the hash
    # metasploit-framework - exploit framework
    # sqlmap - automated sql injection attacks
    # exploitdb -
    # enum4linux - smb enumeration
    # smbmap - smb enumeration
    # bettercap - poisoning and more
    # backdoor-factory - backdoors
    # shellter - backdoors
    # veil - backdoors
    # veil-evasion obfuscation
    # commix - command injection
    # routersploit -
    # python3-impacket - impacket arsenal 
    for package in gcc-multilib mingw-w64 crackmapexec metasploit-framework sqlmap exploitdb enum4linux smbmap bettercap backdoor-factory shellter veil veil-evasion commix routersploit \
    linux-exploit-suggester powersploit shellnoob hydra john davtest kerberoast set knockpy ssh-audit python3-impacket 
    do
        apt install -y -q $package >> "$home"/script.log 2>>script_error.log
    done 
}
install_steg_programs(){
    printf "  ⏳  Installing steg apps\n" | tee -a script.log
    # stegosuite - steganography
    # steghide - steganography
    # steghide-doc - documentation for steghide
    # audacity - sound editor / spectogram
    for package in stegosuite steghide steghide-doc audacity 
    do
        apt install -y -q $package >> script.log 2>>script_error.log
    done
}

install_recon_tools(){
    printf "  ⏳  Installing recon apps\n" | tee -a script.log
    # gobuster - directory brute forcer
    # dirb - directory brute forcer
    # wpscan - wordpress scanner
    # dirbuster - web fuzzing
    # netcat
    # nmap - network scanner
    # nikto - web scanner
    # netdiscover - network scanner
    # wafw00f - waf scanner
    # masscan - network scanner
    # fping
    # theharvester - osint
    # wfuzz - web fuzzing
    # amass - Asset Discovery
    # sublist3r -  subdomains enumeration too
    # flawfinder - static analysis tool for C/C++ 
    # eyewitness - take screenshots of websites
    # massdns - dns scanner
    # subfinder - subdomain discovery tool
    # urlcrazy - Generate domain permutation
    # python3-lsassy - Extract credentials from lsass remotely
    # python3-pypykatz - Mimikatz in pure python
    # nishang - Powershell OffSec framework
    # sslscan - ssl scanner
    # sslyze - ssl/tls scanner
    # seclists - list collection
    # photon - osint 
    # ffuf - web fuzzing
    for package in gobuster dirb wpscan dirbuster netcat nmap nikto netdiscover wafw00f masscan fping theharvester wfuzz amass sublist3r flawfinder eyewitness massdns \
    subfinder urlcrazy python3-lsassy python3-pypykatz nishang sslscan sslyze seclists photon ffuf
    do
        apt install -y -q "$package" >> script.log 2>>script_error.log
    done 
}

install_bloodhound(){
    printf " ⏳  Installing BloodHound\n" | tee -a script.log
    # bloodhound
    for package in bloodhound 
    do
        apt install -y -q $package >> script.log 2>>script_error.log
    done
    cd "$downloads"
    curl -L --silent -o "/home/"$user"/.config/bloodhound/customqueries.json" "https://raw.githubusercontent.com/CompassSecurity/BloodHoundQueries/master/customqueries.json"
}

fix_kali() {
    printf "  ⏳  Clonning PIMPMYKALI Repository\n" | tee -a "$home"/script.log
    cd "$downloads"
    git clone --quiet https://github.com/Dewalt-arch/pimpmykali.git
    if [[ $? -ne 0 ]]; then
        printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> "$home"/script.log
    fi 
}

install_sublime() {
    printf "  ⏳  Installing Sublime Text\n" | tee -a script.log
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    if [[ $? != 0 ]]; then
        printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    apt update
    apt install -y -q sublime-text >> script.log 2>>script_error.log
}

install_opera(){
    printf "  ⏳  Installing Opera browser\n" | tee -a script.log
    wget -qO - https://deb.opera.com/archive.key | sudo apt-key add -
    if [[ $? != 0 ]]; then
        printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
    echo 'deb https://deb.opera.com/opera-stable/ stable non-free' | sudo tee /etc/apt/sources.list.d/opera-stable.list
    apt update
    apt install -y -q opera-stable >> script.log 2>>script_error.log
}

install_mega() {
    printf "  ⏳  Installing MEGAsync\n" | tee -a script.log
    cd "$downloads"
    wget --quiet https://mega.nz/linux/MEGAsync/Debian_10.0/amd64/megasync-Debian_10.0_amd64.deb
    if [[ $? != 0 ]]; then
        printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
    dpkg -i ./megasync-Debian_10.0_amd64.deb >> script.log
    apt --fix-broken install -y
    rm -f ./megasync-Debian_10.0_amd64.deb
}

install_stegcracker(){
    printf "  ⏳  Install Stegcracker\n" | tee -a script.log
    for package in steghide
    do 
        apt install -y -q "$package" >> script.log 2>>script_error.log
    done
    for pip_package in stegcracker
    do
        pip3 -q install "$pip_package" >> script.log 2>>script_error.log
    done
    if [[ $? != 0 ]]; then
        printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi    
}

install_nmap_vulscan(){
    printf "  ⏳  Install NMAP vulscan\n" | tee -a script.log
    cd /usr/share/nmap/scripts/
    git clone --quiet https://github.com/scipag/vulscan.git
    if [[ $? != 0 ]]; then
        printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi  
}

john_bash_completion() {
    printf "  ⏳  enabling john bash completion\n" | tee -a script.log
    echo ". /usr/share/bash-completion/completions/john.bash_completion" >> /$user/.zshrc
}

configure_metasploit(){
    printf "  🔧  configure metasploit\n" | tee -a script.log
    systemctl start postgresql >> script.log
    msfdb init >> script.log
}

additional_clean(){
    printf "  ♻  additional cleaning\n" | tee -a script.log
    cd ~/ # go home
    updatedb # update slocated database
    history -cw 2>/dev/null # clean history
}

manual_stuff_to_do(){
    printf "\n  ⏳  Adding Manual work\n" | tee -a script.log
    echo ""
    echo "  Complete zsh configuration" >> script_todo.log
    echo "" >> script_todo.log
    echo "  Complete megasync configuration" >> script_todo.log
    echo "" >> script_todo.log
    echo "  Complete opera browser configuration" >> script_todo.log
    echo "" >> script_todo.log
    echo "  Complete GUI configuration" >> script_todo.log
    echo "" >> script_todo.log
    echo "=============Firefox addons===========" >> script_todo.log
    echo "  FoxyProxy Standard" >> script_todo.log
    echo "" >> script_todo.log  
}

compute_finish_time(){
    finish_time=$(date +%s)
    echo -e "  ⌛ Time (roughly) taken: ${YELLOW}$(( $(( finish_time - start_time )) / 60 )) minutes${RESET}"
    echo "\n\n Install completed - $finish_time \n" >> script.log
}

script_todo_print() {
    printf "  ⏳  Printing notes\n" | tee -a script.log
    cat script_todo.log
}

main () {
    compute_start_time
    configure_environment
    apt_update
    apt_upgrade
    install_kernel_headers
    install_libs
    install_base_os_tools
    install_python3_related
    ##install_fonts
    ##install_zsh
    install_re_tools
    install_exploit_tools
    install_steg_programs
    install_recon_tools
    install_bloodhound
    #install_sublime
    #install_opera
    #install_mega
    install_stegcracker
    install_nmap_vulscan
    install_metapackage
    #john_bash_completion
    #configure_metasploit
    fix_kali
    additional_clean
    #manual_stuff_to_do
    compute_finish_time
    script_todo_print
}

main
