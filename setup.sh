#!/usr/bin/env bash

#==================#
# Library Includes #
#==================#
#readonly AIROSPLOITPath=$(dirname $(readlink -f "$0"))
readonly AIROSPLOITPath=$(pwd)
readonly AIROSPLOITLibPath="$AIROSPLOITPath/lib"
readonly AIROSPLOITTmpPath="$AIROSPLOITPath/tmp"
readonly AIROSPLOITPython="$AIROSPLOITTmpPath/Python-3.6.13"

source "$AIROSPLOITLibPath/ColorUtils.sh"
source "$AIROSPLOITLibPath/RootUtils.sh"
source "$AIROSPLOITLibPath/InternetUtils.sh"

airosploit_dependencies() {
echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Update System Packages...${RESET}"
if [[ "type -p apt" ]]; then
	sudo apt install update &> /dev/null
	sudo apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev curl libbz2-dev build-essential python-dev libnetfilter-queue-dev &> /dev/null
elif [[ "type -p apt-get" ]]; then
	sudo apt-get install update &> /dev/null
	sudo apt-get install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev curl libbz2-dev &> /dev/null
else
	echo -e "\n${RED}[${WHITE}!${RED}]${RED} Unsupported package Manager, Update System Packages Manually. [update system]${RESET}"
	exit
fi

echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing Required Packages...${RESET}"

pkgs=(xterm wget tar make)
for pkg in "${pkgs[@]}"; do
	type -p "$pkg" &>/dev/null
	if [ $? -eq 0 ]; then
		echo -e "\n${GREEN}[${WHITE}+${GREEN}] ${ORANGE}$pkg ${GREEN}Already Installed."
	else
		echo -e "\n${RED}[${WHITE}+${RED}]${CYAN} Installing Package : ${ORANGE}$pkg${CYAN}"${WHITE}
		if [[ "type -p apt" ]]; then
			sudo apt install "$pkg" -y &> /dev/null
		elif [[ "type -p apt-get" ]]; then
			sudo apt-get install "$pkg" -y &> /dev/null
		else
			echo -e "\n${RED}[${WHITE}!${RED}]${RED} Unsupported Package Manager, Install Packages Manually. [xterm wget tar make python]${RESET}"
			exit
		fi
	fi
done
}
airosploit_pip(){
if [[ "type -p pip3" ]]; then	
	if [[ $(pip3 list --disable-pip-version-check | grep -F scapy) ]]; then		
		echo -e "\n${GREEN}[${WHITE}+${GREEN}]${GREEN} ${ORANGE}Scapy ${GREEN}Already Installed."		
	else	
		echo -e "\n${RED}[${WHITE}+${RED}]${CYAN} Installing Package : ${ORANGE}Scapy${CYAN}"${WHITE}		
		sudo python3.6 -m pip install scapy &> /dev/null
	fi
	if [[ $(pip3 list --disable-pip-version-check | grep -F NetfilterQueue) ]]; then
		echo -e "\n${GREEN}[${WHITE}+${GREEN}]${GREEN} ${ORANGE}NetfilterQueue ${GREEN}Already Installed."		
	else		
		echo -e "\n${RED}[${WHITE}+${RED}]${CYAN} Installing Package : ${ORANGE}NetfilterQueue${CYAN}"${WHITE}		
		sudo python3.6 -m pip install NetfilterQueue &> /dev/null
	fi	
fi
}
airosploit_python(){
echo
echo -e "\n${RED}[${WHITE}+${RED}]${GREEN} This Will Take Some Time...${RESET}"
cd $AIROSPLOITPython
sudo ./configure -q --with-ensurepip=install &> /dev/null
sudo make &> /dev/null
sudo make install &> /dev/null
}
airosploit_install() {
#==============#
# Installation #
#==============#

cd $AIROSPLOITTmpPath
if [ $(type -p python3.6) ]; then
	echo -e "\n${GREEN}[${WHITE}+${GREEN}]${GREEN} ${ORANGE}Python 3.6 ${GREEN}Already Installed."
	airosploit_pip
else
	if [[ -d "$AIROSPLOITPython" ]]; then 
		echo -e "\n${RED}[${WHITE}+${RED}]${CYAN} Installing Python : ${ORANGE}Python 3.6${CYAN}"${RESET}
		airosploit_python
		airosploit_pip
	else
		echo -e "\n${RED}[${WHITE}+${RED}]${CYAN} Downloading and Installing Python : ${ORANGE}Python 3.6${CYAN}"${RESET}
		sudo wget https://www.python.org/ftp/python/3.6.13/Python-3.6.13.tgz &> /dev/null
		sudo tar xvf Python-3.6.13.tgz &> /dev/null
		sudo rm -rf Python-3.6.13.tgz 		
		airosploit_python
		airosploit_pip
	fi
fi
sleep 4
clear
echo "${RED}[${WHITE}+${RED}]${GREEN} Installation Successfully Done."
echo -e "\n${RED}[${WHITE}+${RED}]${GREEN} Run Airosploit using this command :${BLINK}${ORANGE} sudo bash airosploit.sh ${RESET}"
}

airosploit_check_root
airosploit_check_internet
airosploit_dependencies
airosploit_install
