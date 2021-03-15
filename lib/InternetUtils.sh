airosploit_check_internet() {
#=====================#
# Check WiFI Internet #
#=====================#
echo -e "\n${GREEN}[${ORANGE}*${GREEN}]${ORANGE} Checking for Internet Connection"
sleep 2
ping -q -w 1 -c 1 `ip r | grep default | cut -d ' ' -f 3` > /dev/null 2>&1
#ping -c 1 -q google.com >&/dev/null 2>&1
if [ $? -ne 0 ]; then
   echo -e "\n${RED}[${WHITE}-${RED}]${RED} Internet Connection : OFFLINE!$RESET"
   exit
else
   echo -e "\n${RED}[${WHITE}+${RED}]${GREEN} Internet Connection : CONNECTED!$RESET"
   sleep 2
fi
clear 
}
