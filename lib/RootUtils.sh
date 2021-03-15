airosploit_check_root() {
#============#
# Check Root #
#============#
if [ $(id -u) != "0" ]; then
   echo -e "\n${RED}[${WHITE}-${RED}] [${WHITE}NOT root${RED}] You need to be root user to run this script. ${GREEN}[use SUDO]${RESET}"
   exit
fi
}
