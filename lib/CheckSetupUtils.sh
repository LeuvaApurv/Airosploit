airosploit_check_setup() {
pkgs=(xterm wget tar make python3.6)
for pkg in "${pkgs[@]}"; do
	type -p "$pkg" &>/dev/null
	if [ $? -eq 0 ]; then
		echo -e "\n${GREEN}[${ORANGE}*${GREEN}] ${ORANGE}$pkg ${GREEN}Already Installed."
		sleep 1
	else
		echo -e "\n${RED}[${WHITE}+${RED}]${GREEN} Setup install using this command :${BLINK}${ORANGE} sudo bash setup.sh ${RESET}"
		exit
	fi
done
}