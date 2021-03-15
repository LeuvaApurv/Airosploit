#!/bin/bash

##   Airosploit	: 	Automated Wifi Hacking Tool
##   Author 	: 	Apurv Leuva
##   Version 	: 	1.0
##   Github 	: 	https://github.com/LeuvaApurv/Airosploit

## If you Copy Then Give the credits :)

#==================#
# Library Includes #
#==================#
readonly AIROSPLOITPath=$(pwd)

readonly AIROSPLOITLibPath="$AIROSPLOITPath/lib"
readonly AIROSPLOITPythonPath="$AIROSPLOITLibPath/python"
readonly AIROSPLOITNull=/dev/null

source "$AIROSPLOITLibPath/ColorUtils.sh"
source "$AIROSPLOITLibPath/RootUtils.sh"
source "$AIROSPLOITLibPath/InternetUtils.sh"
source "$AIROSPLOITLibPath/BannerUtils.sh"
source "$AIROSPLOITLibPath/AllFunctionUtils.sh"
source "$AIROSPLOITLibPath/CheckSetupUtils.sh"

#=======#
# First #
#=======#
airosploit_1() {
clear
airosploit_banner
echo "${RED}[${ORANGE}1${RED}]${GREEN} List of Connected Device in your Network"
echo "${RED}[${ORANGE}2${RED}]${GREEN} About"
echo "${RED}[${ORANGE}3${RED}]${RED} Exit"
echo -e "\n${BLUE}=============================================="
echo -en "\n${GREEN}[${WHITE}*${GREEN}]${ORANGE} Select an option :${CYAN} "
read  h
case "$h" in
1)airosploit_net_discover;;
2);;
3)clear
ariosploit_shutdown
exit;;
*)echo -e "\n${RED}[${WHITE}-${RED}]${RED} Invalid";sleep 1;clear
airosploit_1;;
esac
}

#========#
# second #
#========#
airosploit_2(){
clear
airosploit_banner
echo "${RED}[${ORANGE}1${RED}]${GREEN} Create Man in the Middle"
echo "${RED}[${ORANGE}2${RED}]${GREEN} Back"
echo "${RED}[${ORANGE}3${RED}]${RED} Exit"
echo -e "\n${BLUE}=============================================="
echo -en "\n${GREEN}[${WHITE}*${GREEN}]${ORANGE} Select an option :${CYAN} "
read  a
case "$a" in
1)airosploit_arp_spoof;;
2)airosploit_1;;
3)clear
ariosploit_shutdown
exit;;
*)echo -e "\n${RED}[${WHITE}-${RED}]${RED} Invalid";sleep 1;clear
airosploit_2;;
esac
}

#=======#
# third #
#=======#
airosploit_3() {
clear
airosploit_banner
echo "${RED}[${ORANGE}1${RED}]${GREEN} Packet Sniffing"
echo "${RED}[${ORANGE}2${RED}]${GREEN} DNS Spoofing"
echo "${RED}[${ORANGE}3${RED}]${ORANGE} File Intercepter ${GREEN}(Coming soon stay tuned)"
echo "${RED}[${ORANGE}4${RED}]${ORANGE} Code Injector ${GREEN}(Coming soon stay tuned)"
echo "${RED}[${ORANGE}5${RED}]${ORANGE} Bypassing HTTPS ${GREEN}(Coming soon stay tuned)"
echo "${RED}[${ORANGE}6${RED}]${GREEN} Back"
echo "${RED}[${ORANGE}7${RED}]${RED} Exit"
echo -e "\n${BLUE}=============================================="
echo -en "\n${GREEN}[${WHITE}*${GREEN}]${ORANGE} Select an option :${CYAN} "
read  s
case "$s" in
1)airosploit_packet_sniffer;;
2)airosploit_dns_spoof;;
3);;
4);;
5);;
6)airosploit_2;;
7)clear
ariosploit_shutdown
exit;;
*)echo -e "\n${RED}[${WHITE}-${RED}]${RED} Invalid";sleep 1;clear
airosploit_3;;
esac
}

ariosploit_shutdown(){
airosploit_banner
echo "${RED}[${WHITE}+${RED}]${RED} Cleaning and Closing"
local processes
readarray processes < <(ps -A)
local -r target=('xterm')
local targetID
for targetID in "${target[@]}"; do
   local targetID
   targetPID=$(echo "${processes[@]}" | awk '$4~/'"$targetID"'/{print $1}')
   if [ ! "targetPID" ]; then continue; fi
   echo -e "\n${GREEN}[${WHITE}+${GREEN}]${GREEN} Cleanup performed successfully !"
   kill -s SIGKILL $targetPID &> $AIROSPLOITNull
done
echo -e "\n${GREEN}[${ORANGE}#${GREEN}]${GREEN} Thank you for using ${ORANGE}AIROSPLOIT${RESET}"
}

airosploit_check_root
airosploit_check_internet
airosploit_check_setup
airosploit_1

